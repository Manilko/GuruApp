//
//  TabBarItemType.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

enum TabBarItemType: Hashable {
    case items
    case favorites

    var title: String {
        switch self {
        case .items:
            return "Items"
        case .favorites:
            return "Favorites"
        }
    }

    var image: UIImage? {
        switch self {
        case .items:
            return UIImage(systemName: "list.bullet")
        case .favorites:
            return UIImage(systemName: "heart.fill")
        }
    }
}
