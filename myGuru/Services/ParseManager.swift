//
//  ParseManager.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import UIKit

class ParseManager {
    static let shared = ParseManager()

    private init() {}

    func parseNumbersToItems(numbers: [Int]) -> [Item] {
        numbers.map { Item(title: "Item \($0)",
                           subtitle: "Subtitle \($0)",
                           description: "This is a description for \($0)",
                           isFavorite: false) }
    }
}
