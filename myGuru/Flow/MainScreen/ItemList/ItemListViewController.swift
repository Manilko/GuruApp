//
//  ItemListViewController.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ItemListViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: ItemListViewModelProtocol
    private let itemListView: ItemListViewProtocol
    private var isLoadingMoreItems = false
    private let favoriteButtonRelay: PublishRelay<Int>

    // MARK: - Initializer
    init(viewModel: ItemListViewModelProtocol, view: ItemListViewProtocol) {
        self.viewModel = viewModel
        self.itemListView = view
        self.favoriteButtonRelay = PublishRelay<Int>()
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
        bindTableViewDataSource()
        bindTableViewDelegate()
        bindFavoriteButton()
        bindRemoveAllFavoritesButton()
        bindPrefetchRowsForPagination()
        bindLoadingIndicator()
        bindErrorHandling()
    }

    // MARK: - private Methods
    private func bindTableViewDataSource() {
        let itemSource = RxTableViewSectionedReloadDataSource<SectionOfItems>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self = self else { return UITableViewCell() }
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ItemTableViewCell.identifier,
                    for: indexPath
                ) as? ItemTableViewCell else {
                    fatalError("Unable to dequeue ItemTableViewCell")
                }
                cell.configure(with: item)
                cell.bindFavoriteButton(to: self.favoriteButtonRelay, indexPath: indexPath.row)
                return cell
            }
        )

        viewModel.output.items
            .map { [SectionOfItems(header: L10n.headerItems, items: $0)] }
            .bind(to: itemListView.tableView.rx.items(dataSource: itemSource))
            .disposed(by: disposeBag)
    }

    private func bindTableViewDelegate() {
        itemListView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func bindFavoriteButton() {
        favoriteButtonRelay
            .subscribe { [weak self] index in
                self?.viewModel.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)
    }

    private func bindRemoveAllFavoritesButton() {
        viewModel.output.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: itemListView.removeAllFavoritesButton.rx.isHidden)
            .disposed(by: disposeBag)

        itemListView.removeAllFavoritesButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.removeAllFavorites()
            }
            .disposed(by: disposeBag)
    }

    private func bindPrefetchRowsForPagination() {
        itemListView.tableView.rx.prefetchRows
            .filter { [weak self] indexPaths in
                guard let self = self else { return false }
                return indexPaths.contains { indexPath in
                    let lastSectionIndex = self.itemListView.tableView.numberOfSections - 1
                    let lastRowIndex = self.itemListView.tableView.numberOfRows(inSection: lastSectionIndex) - 1
                    return indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex
                }
            }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.viewModel.loadMoreItems(count: 10)
            }
            .disposed(by: disposeBag)
    }

    private func bindLoadingIndicator() {
        viewModel.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isLoading in
                if isLoading {
                    self?.showSpinner()
                } else {
                    self?.hideSpinner()
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindErrorHandling() {
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                self?.showError(error)
            }
            .disposed(by: disposeBag)
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: L10n.errorAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.errorAlertActionTitle, style: .default, handler: nil))
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

        deleteAction.image = UIImage(systemName: L10n.deleteImage)
        deleteAction.backgroundColor = UIColor.red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
