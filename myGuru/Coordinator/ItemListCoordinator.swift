//
//  ItemListCoordinator.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 06.01.2025.
//

import UIKit
import RxSwift

class ItemListCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let serviceProvider: ServiceProviderProtocol

    init(serviceProvider: ServiceProviderProtocol) {
        self.navigationController = UINavigationController()
        self.serviceProvider = serviceProvider
    }

    func start() {
        let viewModel = ItemListViewModel(itemRepository: serviceProvider)
        let itemListView = ItemListView()
        let itemListVC = ItemListViewController(viewModel: viewModel, view: itemListView)

        navigationController.setViewControllers([itemListVC], animated: false)
    }
}
