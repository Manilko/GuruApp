//
//  FavoritesViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import RxSwift
import RxCocoa

protocol FavoritesViewModelProtocol: BaseViewModelProtocol {
    var input: FavoritesViewModel.Input { get }
    var output: FavoritesViewModel.Output { get }
}

class FavoritesViewModel: BaseViewModel, FavoritesViewModelProtocol {
    struct Input {
        let toggleFavorite: PublishRelay<Int>
        let removeAllFavorites: PublishRelay<Void>
    }

    struct Output {
        let favoriteItems: Observable<[Item]>
        let hasFavorites: Observable<Bool>
    }

    // MARK: - Properties
    var input: Input
    var output: Output

    private let toggleFavoriteRelay = PublishRelay<Int>()
    private let removeAllFavoritesRelay = PublishRelay<Void>()

    // MARK: - Initializer
    init(itemRepository: ServiceProviderProtocol) {
        self.input = Input(
            toggleFavorite: toggleFavoriteRelay,
            removeAllFavorites: removeAllFavoritesRelay
        )

        self.output = Output(
            favoriteItems: itemRepository.itemService.favoriteItems,
            hasFavorites: itemRepository.itemService.favoriteItems.map { !$0.isEmpty }
        )

        super.init(provider: itemRepository)

        bindInputs()
    }

    private func bindInputs() {
        toggleFavoriteRelay
            .subscribe{ [weak self] index in
                self?.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)

        removeAllFavoritesRelay
            .subscribe{ [weak self] _ in
                self?.removeAllFavorites()
            }
            .disposed(by: disposeBag)
    }

    private func toggleFavorite(at index: Int) {
        let favorites = serviceProvider.itemService.itemsRelay.value.filter { $0.isFavorite }
        guard index >= 0 && index < favorites.count else { return }

        let favoriteItem = favorites[index]
        if let originalIndex = serviceProvider.itemService.itemsRelay.value.firstIndex(where: { $0.title == favoriteItem.title }) {
            serviceProvider.itemService.toggleFavorite(at: originalIndex)
        }
    }

    private func removeAllFavorites() {
        serviceProvider.itemService.removeAllFavorites()
    }
}
