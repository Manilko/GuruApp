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
    let itemListViewModel: ItemListViewModel
    let favoritesViewModel: FavoritesViewModel

    init(navigationController: UINavigationController, serviceProvider: ServiceProviderProtocol) {
        self.navigationController = navigationController
        self.favoritesViewModel = FavoritesViewModel(itemRepository: serviceProvider)
        self.itemListViewModel = ItemListViewModel(itemRepository: serviceProvider)
        
    }

    func start() {
        let itemListView = ItemListView()
        let itemListVC = ItemListViewController(viewModel: itemListViewModel, view: itemListView)
        let favoritesView = FavoritesView()
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel, view: favoritesView)

        let tabBarViewModel = TabBarViewModel(tabBarItems: [.items, .favorites])

        let controllers: [TabBarItemType: UIViewController] = [
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
