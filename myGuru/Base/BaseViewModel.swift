//
//  BaseViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import RxCocoa

protocol LoadProtocol {
    func loadMoreItems(count: Int)
}

protocol BaseViewModelProtocol {
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    func handleError(_ error: Error)
}

class BaseViewModel: BaseViewModelProtocol {
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()

    let dataService: DataServiceProtocol
    let disposeBag = DisposeBag()

    init(dataService: DataServiceProtocol = DataService.shared) {
        self.dataService = dataService
    }

    func handleError(_ error: Error) {
        self.error.accept(error)
    }
}
