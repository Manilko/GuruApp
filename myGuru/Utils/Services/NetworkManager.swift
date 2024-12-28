//
//  NetworkManager.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import UIKit

class NetworkManager {
    static let shared = NetworkManager()

    private var itemCounter = 0
    private init() {}

    func fetchNumbers(count: Int) -> Observable<[Int]> {
        Observable.just(())
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
                guard let self = self else { return [] }
                let startIndex = self.itemCounter + 1
                let endIndex = self.itemCounter + count
                let numbers = Array(startIndex...endIndex)
                self.itemCounter += count
                return numbers
            }
    }
}
