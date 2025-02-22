//
//  TabBarController.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarController: UITabBarController {

    private let viewModel: TabBarViewModelProtocol

    init(viewModel: TabBarViewModelProtocol, controllers: [TabBarItemType: UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTabBar(controllers: controllers)
        setTabBarAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar(controllers: [TabBarItemType: UIViewController]) {
       viewControllers = viewModel.output.tabBarItems.compactMap { tabBarItem in
           guard let controller = controllers[tabBarItem] else {
               assertionFailure("Missing controller for \(tabBarItem)")
               return nil
           }
           controller.tabBarItem.title = tabBarItem.title
           controller.tabBarItem.image = tabBarItem.image
           return controller
       }
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2

        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        roundLayer.path = bezierPath.cgPath
        roundLayer.fillColor = Asset.Colors.mainWhite1.color.cgColor
        tabBar.layer.insertSublayer(roundLayer, at: 0)

        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        tabBar.tintColor = Asset.Colors.tabBarItemAccent1.color
        tabBar.unselectedItemTintColor = Asset.Colors.tabBarItemLight1.color
    }
}
