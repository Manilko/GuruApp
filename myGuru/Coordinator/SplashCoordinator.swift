//
//  SplashCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import UIKit
import RxSwift

class SplashCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let serviceProvider: ServiceProviderProtocol
    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationController, serviceProvider: ServiceProviderProtocol) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }

    func start() {
        let splashView = SplashView()
        let splashViewModel = SplashViewModel(serviceProvider: serviceProvider)
        let splashViewController = SplashViewController(viewModel: splashViewModel, view: splashView)

        splashViewModel.output.loadingComplete
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.showMainScreen()
            }
            .disposed(by: disposeBag)

        navigationController.pushViewController(splashViewController, animated: false)
    }

    private func showMainScreen() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, serviceProvider: serviceProvider)
        tabBarCoordinator.start()
    }
}
