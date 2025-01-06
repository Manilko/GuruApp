//
//  ItemCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//
import RxSwift
import RxCocoa
import UIKit

class TabBarCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let itemListViewModel: ItemListViewModel
    private var controllers: [TabBarItemType: UIViewController] = [:]

    init(navigationController: UINavigationController, initialItems: [Item]) {
        self.navigationController = navigationController
        self.itemListViewModel = ItemListViewModel(initialItems: initialItems)
    }

    func start() {
        let itemListView = ItemListView()
        let itemListVC = ItemListViewController(viewModel: itemListViewModel, view: itemListView)
        let favoritesView = FavoritesView()
        let favoritesVC = FavoritesViewController(viewModel: itemListViewModel, view: favoritesView)
        
        let tabBarViewModel = TabBarViewModel(tabBarItems: [.items, .favorites])

        controllers = [
            .items: itemListVC,
            .favorites: favoritesVC
        ]

        let mainTabBarController = TabBarController(
            viewModel: tabBarViewModel,
            controllers: controllers
        )

        navigationController.setViewControllers([mainTabBarController], animated: false)
    }
}
