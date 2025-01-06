//
//  MainCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit
import RxSwift

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let splashViewModel = SplashViewModel()
        let splashViewController = SplashViewController(viewModel: splashViewModel)

        splashViewModel.output.loadingComplete
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self] items in
                self?.showMainScreen(with: items)
            }
            .disposed(by: splashViewModel.disposeBag)

        navigationController.pushViewController(splashViewController, animated: false)
    }

    private func showMainScreen(with items: [Item]) {
        let itemCoordinator = TabBarCoordinator(navigationController: navigationController, initialItems: items)
        itemCoordinator.start()
    }
}
