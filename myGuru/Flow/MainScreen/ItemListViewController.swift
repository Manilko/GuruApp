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
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Items"
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let removeAllFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove All Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    private let disposeBag = DisposeBag()
    private let viewModel: ItemListViewModel
    private var isLoadingMoreItems = false

    private let dataSource: ItemListDataSource
    private let favoriteButtonRelay: PublishRelay<Int>

    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
        self.favoriteButtonRelay = PublishRelay<Int>()
        self.dataSource = ItemListDataSource(favoriteButtonRelay: favoriteButtonRelay)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(removeAllFavoritesButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 64),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: removeAllFavoritesButton.topAnchor, constant: -16),

            removeAllFavoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            removeAllFavoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            removeAllFavoritesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            removeAllFavoritesButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupBindings() {
        let itemSource = dataSource.create()

        viewModel.items
            .map { [SectionOfItems(header: "Items", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: itemSource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        favoriteButtonRelay
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.toggleFavorite(at: index)
            })
            .disposed(by: disposeBag)

        viewModel.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: removeAllFavoritesButton.rx.isHidden)
            .disposed(by: disposeBag)

        removeAllFavoritesButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeAllFavorites()
            })
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
           .filter { [weak self] offset in
               guard let self = self else { return false }
               return offset.y > self.tableView.contentSize.height - self.tableView.frame.size.height - 100
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
    
       private func showError(_ error: Error) {
           let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

