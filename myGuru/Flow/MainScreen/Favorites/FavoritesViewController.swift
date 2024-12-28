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
    private let favoritesView: FavoritesViewProtocol
    private let removeFavoriteRelay = PublishRelay<Int>()

    // MARK: - Init
    init(viewModel: ItemListViewModel, view: FavoritesViewProtocol) {
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
        viewModel.output.favoriteItems
            .bind(to: favoritesView.tableView.rx.items(cellIdentifier: FavoriteCell.identifier, cellType: FavoriteCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.configure(with: item)
                cell.bindFavoriteButton(to: self.removeFavoriteRelay, indexPath: index)
            }
            .disposed(by: disposeBag)

        removeFavoriteRelay
            .withLatestFrom(viewModel.output.favoriteItems) { (index: $0, favorites: $1) }
            .subscribe(onNext: { [weak self] index, favorites in
                guard let self = self else { return }
                
                guard index < favorites.count else { return }
                
                let itemToRemove = favorites[index]
                
                viewModel.output.items
                    .take(1)
                    .subscribe(onNext: { allItems in
                        if let originalIndex = allItems.firstIndex(where: { $0.title == itemToRemove.title }) {
                            self.viewModel.toggleFavorite(at: originalIndex)
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hasFavorites
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: favoritesView.deleteAllButton.rx.isHidden)
            .disposed(by: disposeBag)

        favoritesView.deleteAllButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeAllFavorites()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.hasFavorites
            .map { $0 }
            .observe(on: MainScheduler.instance)
            .bind(to: favoritesView.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
