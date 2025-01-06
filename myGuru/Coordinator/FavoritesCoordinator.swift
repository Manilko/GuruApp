//
//  FavoritesCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import UIKit
import RxSwift

class FavoritesCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let serviceProvider: ServiceProviderProtocol

    init(serviceProvider: ServiceProviderProtocol) {
        self.navigationController = UINavigationController()
        self.serviceProvider = serviceProvider
    }

    func start() {
        let viewModel = FavoritesViewModel(itemRepository: serviceProvider)
        let favoritesView = FavoritesView()
        let favoritesVC = FavoritesViewController(viewModel: viewModel, view: favoritesView)

        navigationController.setViewControllers([favoritesVC], animated: false)
    }
}
