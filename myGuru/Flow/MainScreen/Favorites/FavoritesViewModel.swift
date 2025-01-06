//
//  FavoritesViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import RxSwift
import RxCocoa

protocol FavoritesViewModelProtocol: BaseViewModelProtocol {
    var output: FavoritesViewModel.Output { get }
    
    func toggleFavorite(at index: Int)
    func removeAllFavorites()
}

class FavoritesViewModel: BaseViewModel, FavoritesViewModelProtocol {
    struct Output {
        let favoriteItems: Observable<[Item]>
        let hasFavorites: Observable<Bool>
    }

    var output: Output

    init(itemRepository: ServiceProviderProtocol) {
        self.output = Output(
            favoriteItems: itemRepository.itemService.favoriteItems,
            hasFavorites: itemRepository.itemService.favoriteItems.map { !$0.isEmpty }
        )

        super.init(provider: itemRepository)
    }

    func toggleFavorite(at index: Int) {
        let favorites = serviceProvider.itemService.itemsRelay.value.filter { $0.isFavorite }
        guard index >= 0 && index < favorites.count else { return }

        let favoriteItem = favorites[index]
        if let originalIndex = serviceProvider.itemService.itemsRelay.value.firstIndex(where: { $0.title == favoriteItem.title }) {
            serviceProvider.itemService.toggleFavorite(at: originalIndex)
        }
    }

    func removeAllFavorites() {
        serviceProvider.itemService.removeAllFavorites()
    }
}
