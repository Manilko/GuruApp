//
//  SectionOfItems.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit
import RxDataSources

struct SectionOfItems {
    var header: String
    var items: [Item]
}

extension SectionOfItems: SectionModelType {
    init(original: SectionOfItems, items: [Item]) {
        self = original
        self.items = items
    }
}
