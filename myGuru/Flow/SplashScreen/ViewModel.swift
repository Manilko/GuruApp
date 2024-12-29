//
//  ViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import RxCocoa
import UIKit

protocol SplashViewModelProtocol: BaseViewModelProtocol {
    var output: SplashViewModel.Output { get }
    
    func startLoading(count: Int)
}

class SplashViewModel: BaseViewModel, SplashViewModelProtocol{
    
    struct Output {
        let data: Observable<[Item]>
    }
    
    var output: Output
    // MARK: - private subject
    private let data = PublishRelay<[Item]>()
    
    init() {
        self.output = Output(
            data: data.asObservable()
        )
        super.init()
    }

    func startLoading(count: Int) {
        isLoading.accept(true)

        dataService.fetchItems(count: count)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    self?.data.accept(items)
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.handleError(error)
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
