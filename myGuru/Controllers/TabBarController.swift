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

    private let itemListViewModel: ItemListViewModel

        init(itemListViewModel: ItemListViewModel, tabBarItems: [TabBarItemType], controllers: [TabBarItemType: UIViewController]) {
            self.itemListViewModel = itemListViewModel
            super.init(nibName: nil, bundle: nil)
            setupTabBar(tabBarItems: tabBarItems, controllers: controllers)
            setTabBarAppearance()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func setupTabBar(tabBarItems: [TabBarItemType], controllers: [TabBarItemType: UIViewController]) {
           viewControllers = tabBarItems.compactMap { tabBarItem in
               guard let controller = controllers[tabBarItem] else { return nil }
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
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        tabBar.layer.insertSublayer(roundLayer, at: 0)

        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
