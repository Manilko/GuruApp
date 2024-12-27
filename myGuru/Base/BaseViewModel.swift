//
//  BaseViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import RxCocoa

protocol LoadableViewModel {
    func loadMoreItems(count: Int)
}

class BaseViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()

    let dataService: DataServiceProtocol
    let disposeBag = DisposeBag()

    init() {
        self.dataService = DataService.shared
    }

    func handleError(_ error: Error) {
        self.error.accept(error)
    }
}
