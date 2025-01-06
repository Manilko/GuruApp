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
        let loadingComplete: Observable<Void>
    }
    
    var output: Output
    // MARK: - private subject
    private let loadingCompleteRelay = PublishRelay<Void>()

    init(serviceProvider: ServiceProviderProtocol) {
        self.output = Output(
            loadingComplete: loadingCompleteRelay.asObservable()
        )
        super.init(provider: serviceProvider)
    }

    func startLoading(count: Int) {
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
