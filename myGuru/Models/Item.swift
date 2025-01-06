//
//  Item.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxDataSources
import Foundation

struct Item: IdentifiableType, Equatable {
    let title: String
    let subtitle: String?
    let description: String?
    var isFavorite: Bool

    var identity: String {
        UUID().uuidString
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identity == rhs.identity &&
               lhs.subtitle == rhs.subtitle &&
               lhs.description == rhs.description &&
               lhs.isFavorite == rhs.isFavorite
    }
}

extension Item {
    init(title: String, isFavorite: Bool) {
        self.title = title
        self.subtitle = nil
        self.description = nil
        self.isFavorite = isFavorite
    }
}
