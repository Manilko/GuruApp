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
    var input: ItemListViewModel.Input { get }
}

class ItemListViewModel: BaseViewModel, ItemListViewModelProtocol {
    struct Input {
        let loadMoreItems: PublishRelay<Int>
        let toggleFavorite: PublishRelay<Int>
        let deleteItem: PublishRelay<Int>
        let removeAllFavorites: PublishRelay<Void>
    }

    struct Output {
        let items: Observable<[Item]>
        let hasFavorites: Observable<Bool>
    }

    // MARK: - Properties
    var input: Input
    var output: Output
    
    private let loadMoreRelay = PublishRelay<Int>()
    private let toggleFavoriteRelay = PublishRelay<Int>()
    private let deleteItemRelay = PublishRelay<Int>()
    private let removeAllFavoritesRelay = PublishRelay<Void>()

    // MARK: - Init
    init(itemRepository: ServiceProviderProtocol) {
        self.input = Input(
            loadMoreItems: loadMoreRelay,
            toggleFavorite: toggleFavoriteRelay,
            deleteItem: deleteItemRelay,
            removeAllFavorites: removeAllFavoritesRelay
        )

        self.output = Output(
            items: itemRepository.itemService.items,
            hasFavorites: itemRepository.itemService.favoriteItems.map { !$0.isEmpty }
        )

        super.init(provider: itemRepository)

        bindInputs(
            loadMoreRelay: loadMoreRelay,
            toggleFavoriteRelay: toggleFavoriteRelay,
            deleteItemRelay: deleteItemRelay,
            removeAllFavoritesRelay: removeAllFavoritesRelay
        )
    }

    private func bindInputs(
        loadMoreRelay: PublishRelay<Int>,
        toggleFavoriteRelay: PublishRelay<Int>,
        deleteItemRelay: PublishRelay<Int>,
        removeAllFavoritesRelay: PublishRelay<Void>
    ) {
        loadMoreRelay
            .subscribe{ [weak self] count in
                self?.loadMoreItems(count: count)
            }
            .disposed(by: disposeBag)

        toggleFavoriteRelay
            .subscribe{ [weak self] index in
                self?.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)

        deleteItemRelay
            .subscribe{ [weak self] index in
                self?.deleteItem(at: index)
            }
            .disposed(by: disposeBag)

        removeAllFavoritesRelay
            .subscribe{ [weak self] _ in
                self?.removeAllFavorites()
            }
            .disposed(by: disposeBag)
    }

    private func toggleFavorite(at index: Int) {
        serviceProvider.itemService.toggleFavorite(at: index)
    }

    private func deleteItem(at index: Int) {
        serviceProvider.itemService.deleteItem(at: index)
    }

    private func removeAllFavorites() {
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
