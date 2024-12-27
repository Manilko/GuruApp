//
//  Item.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit
import RxDataSources

struct Item {
    let title: String
    let subtitle: String?
    let description: String?
    var isFavorite: Bool
}

extension Item{
    init(title: String, isFavorite: Bool) {
        self.title = title
        self.subtitle = nil
        self.description = nil
        self.isFavorite = isFavorite
    }
}
