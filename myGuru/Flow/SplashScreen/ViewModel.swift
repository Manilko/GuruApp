//
//  ViewModel.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import RxSwift
import RxCocoa
import UIKit

class SplashViewModel: BaseViewModel {
    let data = PublishRelay<[Item]>()

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
