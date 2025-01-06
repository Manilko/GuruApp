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
    private let serviceProvider: ServiceProviderProtocol
    private var splashCoordinator: SplashCoordinator?

    init(navigationController: UINavigationController, serviceProvider: ServiceProviderProtocol) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }

    func start() {
        splashCoordinator = SplashCoordinator(navigationController: navigationController, serviceProvider: serviceProvider)
        splashCoordinator?.start()
    }
}
