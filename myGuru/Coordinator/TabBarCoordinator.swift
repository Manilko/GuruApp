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
    private let serviceProvider: ServiceProviderProtocol
    private let itemListCoordinator: ItemListCoordinator
    private let favoritesCoordinator: FavoritesCoordinator

    init(navigationController: UINavigationController, serviceProvider: ServiceProviderProtocol) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
        self.itemListCoordinator = ItemListCoordinator(serviceProvider: serviceProvider)
        self.favoritesCoordinator = FavoritesCoordinator(serviceProvider: serviceProvider)
    }

    func start() {
        let tabBarViewModel = TabBarViewModel(tabBarItems: [.items, .favorites])

        itemListCoordinator.start()
        favoritesCoordinator.start()

        let controllers: [TabBarItemType: UIViewController] = [
            .items: itemListCoordinator.navigationController.viewControllers.first ?? UIViewController(),
            .favorites: favoritesCoordinator.navigationController.viewControllers.first ?? UIViewController()
        ]

        let mainTabBarController = TabBarController(
            viewModel: tabBarViewModel,
            controllers: controllers
        )

        navigationController.setViewControllers([mainTabBarController], animated: false)
    }
}
