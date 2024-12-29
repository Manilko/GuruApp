//
//  DataService.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import RxCocoa
import UIKit

protocol DataServiceProtocol {
    func fetchItems(count: Int) -> Observable<[Item]>
}

class DataService: DataServiceProtocol {
    static let shared = DataService()

    private init() {}

    func fetchItems(count: Int) -> Observable<[Item]> {
        NetworkManager.shared.fetchNumbers(count: count)
            .map { ParseManager.shared.parseNumbersToItems(numbers: $0) }
    }
}
