//
//  FavoritesViewController.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: ItemListViewModel
    private let removeFavoriteRelay = PublishRelay<Int>()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete All Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorite list is empty"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
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
        view.addSubview(deleteAllButton)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 64),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: deleteAllButton.topAnchor, constant: -16),

            deleteAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deleteAllButton.heightAnchor.constraint(equalToConstant: 44),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.favoriteItems
            .bind(to: tableView.rx.items(cellIdentifier: FavoriteCell.identifier, cellType: FavoriteCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }

                cell.configure(with: item)

                cell.bindFavoriteButton(to: self.removeFavoriteRelay, indexPath: index)
            }
            .disposed(by: disposeBag)

        removeFavoriteRelay
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }

                let currentFavorites = self.viewModel.items.value.filter { $0.isFavorite }
                guard index < currentFavorites.count else { return }
                let itemToRemove = currentFavorites[index]

                if let originalIndex = self.viewModel.items.value.firstIndex(where: { $0.title == itemToRemove.title }) {
                    self.viewModel.toggleFavorite(at: originalIndex)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: deleteAllButton.rx.isHidden)
            .disposed(by: disposeBag)

        deleteAllButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.removeAllFavorites()
            })
            .disposed(by: disposeBag)
        
        viewModel.hasFavorites
            .map { $0 }
            .observe(on: MainScheduler.instance)
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
