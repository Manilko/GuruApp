//
//  ItemListViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
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
        let favoriteItems: Observable<[Item]>
        let hasFavorites: Observable<Bool>
    }
    
    var output: Output
    // MARK: - private subject
    private var items = BehaviorRelay<[Item]>(value: [])
    
    init(initialItems: [Item]) {
        self.items.accept(initialItems)
        self.output = Output(
            items: items.asObservable(),
            favoriteItems: items.map { $0.filter { $0.isFavorite } },
            hasFavorites: items.map { !$0.filter { $0.isFavorite }.isEmpty }
        )
        super.init()
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
        currentItems = currentItems.map {
            Item(title: $0.title, subtitle: $0.subtitle, description: $0.description, isFavorite: false)
        }
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
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }

    private func appendItems(newItems: [Item]) {
        var currentItems = items.value
        currentItems.append(contentsOf: newItems)
        items.accept(currentItems)
    }
}
