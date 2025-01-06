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
    var input: SplashViewModel.Input { get }
    var output: SplashViewModel.Output { get }
}

class SplashViewModel: BaseViewModel, SplashViewModelProtocol {
    
    struct Input {
        let startLoading: PublishRelay<Int>
    }
    
    struct Output {
        let loadingComplete: Observable<Void>
    }
    
    var input: Input
    var output: Output
    
    // MARK: - Private Subjects
    private let loadingCompleteRelay = PublishRelay<Void>()

    // MARK: - Initializer
    init(serviceProvider: ServiceProviderProtocol) {
        let startLoadingRelay = PublishRelay<Int>()

        self.input = Input(startLoading: startLoadingRelay)
        self.output = Output(
            loadingComplete: loadingCompleteRelay.asObservable()
        )

        super.init(provider: serviceProvider)

        startLoadingRelay
            .subscribe{ [weak self] count in
                self?.startLoading(count: count)
            }
            .disposed(by: disposeBag)
    }

    private func startLoading(count: Int) {
        isLoading.accept(true)
        
        serviceProvider.dataService.fetchItems(count: count)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    guard let self = self else { return }
                    self.saveItems(items)
                    self.loadingComplete()
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.handleError(error)
                    self.loadingComplete()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func saveItems(_ items: [Item]) {
        serviceProvider.itemService.setItems(items)
    }
    
    private func loadingComplete() {
        loadingCompleteRelay.accept(())
        isLoading.accept(false)
    }
}
