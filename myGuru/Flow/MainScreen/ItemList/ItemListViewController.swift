//
//  ItemListViewController.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import UIKit
import RxSwift
import RxCocoa

class ItemListViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: ItemListViewModelProtocol
    private let itemListView: ItemListViewProtocol
    private var isLoadingMoreItems = false

    private let dataSource: ItemListDataSource
    private let favoriteButtonRelay: PublishRelay<Int>

    // MARK: - Initializer
    init(viewModel: ItemListViewModelProtocol, view: ItemListViewProtocol) {
        self.viewModel = viewModel
        self.itemListView = view
        self.favoriteButtonRelay = PublishRelay<Int>()
        self.dataSource = ItemListDataSource(favoriteButtonRelay: favoriteButtonRelay)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = itemListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Bindings
    private func setupBindings() {
        let itemSource = dataSource.create()

        viewModel.output.items
            .map { [SectionOfItems(header: Naming.headerItems, items: $0)] }
            .bind(to: itemListView.tableView.rx.items(dataSource: itemSource))
            .disposed(by: disposeBag)

        itemListView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        favoriteButtonRelay
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.toggleFavorite(at: index)
            })
            .disposed(by: disposeBag)

        viewModel.output.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: itemListView.removeAllFavoritesButton.rx.isHidden)
            .disposed(by: disposeBag)

        itemListView.removeAllFavoritesButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeAllFavorites()
            })
            .disposed(by: disposeBag)

        itemListView.tableView.rx.contentOffset
           .filter { [weak self] offset in
               guard let self = self else { return false }
               return offset.y > self.itemListView.tableView.contentSize.height - self.itemListView.tableView.frame.size.height - 100
           }
           .throttle(.seconds(1), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self] _ in
               self?.viewModel.loadMoreItems(count: 10)
           })
           .disposed(by: disposeBag)

       viewModel.isLoading
           .distinctUntilChanged()
           .observe(on: MainScheduler.instance)
           .subscribe(onNext: { [weak self] isLoading in
               if isLoading {
                   self?.showSpinner()
               } else {
                   self?.hideSpinner()
               }
           })
           .disposed(by: disposeBag)

        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: Naming.errorAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Naming.errorAlertActionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            self.viewModel.deleteItem(at: indexPath.row)
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: Naming.deleteImage)
        deleteAction.backgroundColor = UIColor.red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
