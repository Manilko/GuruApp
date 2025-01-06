//
//  ItemListViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//
import RxSwift
import RxCocoa

protocol ItemListViewModelProtocol: BaseViewModelProtocol, LoadProtocol {
    var output: ItemListViewModel.Output { get }
    
    func toggleFavorite(at index: Int)
    func deleteItem(at index: Int)
    func removeAllFavorites()
}

class ItemListViewModel: BaseViewModel, ItemListViewModelProtocol {
    struct Output {
        let items: Observable<[Item]>
        let hasFavorites: Observable<Bool>
    }

    var output: Output

    init(itemRepository: ServiceProviderProtocol) {
        self.output = Output(
            items: itemRepository.itemService.items,
            hasFavorites: itemRepository.itemService.favoriteItems.map { !$0.isEmpty }
        )

        super.init(provider: itemRepository)
    }

    func toggleFavorite(at index: Int) {
        serviceProvider.itemService.toggleFavorite(at: index)
    }

    func deleteItem(at index: Int) {
        serviceProvider.itemService.deleteItem(at: index)
    }

    func removeAllFavorites() {
        serviceProvider.itemService.removeAllFavorites()
    }

    func loadMoreItems(count: Int) {
        isLoading.accept(true)

        serviceProvider.itemService.loadMoreItems(count: count)
            .subscribe(
                onError: { [weak self] error in
                    self?.handleError(error)
                    self?.isLoading.accept(false)
                }, onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
