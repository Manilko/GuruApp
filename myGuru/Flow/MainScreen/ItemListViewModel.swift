//
//  ItemListViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import RxSwift
import RxCocoa

class ItemListViewModel: BaseViewModel, LoadableViewModel {
    var items = BehaviorRelay<[Item]>(value: [])

    var favoriteItems: Observable<[Item]> {
        items.map { $0.filter { $0.isFavorite } }
    }

    var hasFavorites: Observable<Bool> {
        favoriteItems.map { !$0.isEmpty }
    }

    init(initialItems: [Item]) {
        super.init()
        self.items.accept(initialItems)
    }

    func toggleFavorite(at index: Int) {
        var currentItems = items.value
        currentItems[index].isFavorite.toggle()
        items.accept(currentItems)
    }

    func deleteItem(at index: Int) {
        var currentItems = items.value
        currentItems.remove(at: index)
        items.accept(currentItems)
    }

    func removeAllFavorites() {
        var currentItems = items.value
        currentItems = currentItems.map { Item(title: $0.title,
                                               subtitle: $0.subtitle,
                                               description: $0.description,
                                               isFavorite: false) }
        items.accept(currentItems)
    }

    func appendItems(newItems: [Item]) {
        var currentItems = items.value
        currentItems.append(contentsOf: newItems)
        items.accept(currentItems)
    }

    func loadMoreItems(count: Int) {
        isLoading.accept(true)

        dataService.fetchItems(count: count)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] newItems in
                    guard let self = self else { return }
                    self.appendItems(newItems: newItems)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    self.handleError(error)
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}

