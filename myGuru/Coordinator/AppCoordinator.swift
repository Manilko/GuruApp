//
//  MainCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let splashViewModel = SplashViewModel()
        let splashViewController = SplashViewController(viewModel: splashViewModel)
        splashViewController.onLoadingComplete = { [weak self] items in
            self?.showMainScreen(with: items)
        }
        navigationController.pushViewController(splashViewController, animated: false)
    }

    private func showMainScreen(with items: [Item]) {
        let itemCoordinator = ItemCoordinator(navigationController: navigationController, initialItems: items)
        itemCoordinator.start()
    }
}
