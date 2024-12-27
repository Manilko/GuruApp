//
//  ItemCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import RxSwift
import RxCocoa
import UIKit

class ItemCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let initialItems: [Item]
    private let itemListViewModel: ItemListViewModel
    private var controllers: [TabBarItemType: UIViewController] = [:]

    init(navigationController: UINavigationController, initialItems: [Item]) {
        self.navigationController = navigationController
        self.initialItems = initialItems
        self.itemListViewModel = ItemListViewModel(initialItems: initialItems)
    }

    func start() {
        let itemListVC = ItemListViewController(viewModel: itemListViewModel)
        let favoritesVC = FavoritesViewController(viewModel: itemListViewModel)

           controllers = [
               .items: itemListVC,
               .favorites: favoritesVC
           ]

           let mainTabBarController = TabBarController(
                itemListViewModel: itemListViewModel,
                tabBarItems: [.items, .favorites],
               controllers: controllers
           )
        navigationController.setViewControllers([mainTabBarController], animated: false)
    }
}
