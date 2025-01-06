//
//  ItemService.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import RxSwift
import RxCocoa

protocol ItemServiceProtocol {
    var items: Observable<[Item]> { get }
    var favoriteItems: Observable<[Item]> { get }
    var itemsRelay: BehaviorRelay<[Item]> { get }
    
    func setItems(_ items: [Item])
    func toggleFavorite(at index: Int)
    func deleteItem(at index: Int)
    func removeAllFavorites()
    func loadMoreItems(count: Int) -> Observable<Void>

}

class ItemService: ItemServiceProtocol {
    
    // MARK: - Properties
    var itemsRelay = BehaviorRelay<[Item]>(value: [])
    private let disposeBag = DisposeBag()
    let dataService: DataServiceProtocol

    // MARK: - Init
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    var items: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    var favoriteItems: Observable<[Item]> {
        itemsRelay.map { $0.filter { $0.isFavorite } }
    }
    
    // MARK: - Public Methods
    func setItems(_ items: [Item]) {
        itemsRelay.accept(items)
    }

    func toggleFavorite(at index: Int) {
        var currentItems = itemsRelay.value
        guard index >= 0 && index < currentItems.count else { return }
        currentItems[index].isFavorite.toggle()
        itemsRelay.accept(currentItems)
    }

    func deleteItem(at index: Int) {
        var currentItems = itemsRelay.value
        guard index >= 0 && index < currentItems.count else { return }
        currentItems.remove(at: index)
        itemsRelay.accept(currentItems)
    }

    func removeAllFavorites() {
        var currentItems = itemsRelay.value
        currentItems = currentItems.map {
            Item(title: $0.title, subtitle: $0.subtitle, description: $0.description, isFavorite: false)
        }
        itemsRelay.accept(currentItems)
    }

    func loadMoreItems(count: Int) -> Observable<Void> {
        return dataService.fetchItems(count: count)
            .observe(on: MainScheduler.instance)
            .do{ [weak self] newItems in
                self?.appendItems(newItems: newItems)
            }
            .map { _ in () }
    }

    private func appendItems(newItems: [Item]) {
        var currentItems = itemsRelay.value
        currentItems.append(contentsOf: newItems)
        itemsRelay.accept(currentItems)
    }
}
