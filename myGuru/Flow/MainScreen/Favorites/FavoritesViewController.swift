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
    private let viewModel: FavoritesViewModelProtocol
    private let favoritesView: FavoritesViewProtocol
    private let removeFavoriteRelay = PublishRelay<Int>()

    // MARK: - Init
    init(viewModel: FavoritesViewModelProtocol, view: FavoritesViewProtocol) {
        self.viewModel = viewModel
        self.favoritesView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = favoritesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Bindings
    private func setupBindings() {
        bindTableViewDataSource()
        bindFavoriteButton()
        bindRemoveAllFavoritesButton()
        bindEmptyStateVisibility()
    }

    private func bindTableViewDataSource() {
        viewModel.output.favoriteItems
            .bind(to: favoritesView.tableView.rx.items(cellIdentifier: FavoriteCell.identifier,
                                                       cellType: FavoriteCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.configure(with: item)
                cell.bindFavoriteButton(to: self.removeFavoriteRelay, indexPath: index)
            }
            .disposed(by: disposeBag)
    }

    private func bindFavoriteButton() {
        removeFavoriteRelay
            .bind(to: viewModel.input.toggleFavorite)
            .disposed(by: disposeBag)
    }

    private func bindRemoveAllFavoritesButton() {
        favoritesView.deleteAllButton.rx.tap
            .bind(to: viewModel.input.removeAllFavorites)
            .disposed(by: disposeBag)
    }

    private func bindEmptyStateVisibility() {
        viewModel.output.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: favoritesView.deleteAllButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.hasFavorites
            .observe(on: MainScheduler.instance)
            .bind(to: favoritesView.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
