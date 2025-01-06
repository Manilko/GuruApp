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
    let serviceProvider: ServiceProviderProtocol

    init(navigationController: UINavigationController, serviceProvider: ServiceProviderProtocol) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }

    func start() {
        
        let splashViewModel = SplashViewModel(serviceProvider: serviceProvider)
        let splashViewController = SplashViewController(viewModel: splashViewModel)

        splashViewModel.output.loadingComplete
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self] _ in
                self?.showMainScreen()
            }
            .disposed(by: splashViewModel.disposeBag)

        navigationController.pushViewController(splashViewController, animated: false)
    }

    private func showMainScreen() {
        let itemCoordinator = TabBarCoordinator(navigationController: navigationController, serviceProvider: serviceProvider)
        itemCoordinator.start()
    }
}
