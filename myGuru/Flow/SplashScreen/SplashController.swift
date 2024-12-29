//
//  SplashController.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: SplashViewModelProtocol
    var onLoadingComplete: (([Item]) -> Void)?

    init(viewModel: SplashViewModelProtocol) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.startLoading(count: 20)
    }

    private func setupUI() {
        view.backgroundColor = .blue
    }

    private func setupBindings() {
        viewModel.output.data
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self] items in
                self?.onLoadingComplete?(items)
            }
            .disposed(by: disposeBag)

        viewModel.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self] isLoading in
                if isLoading {
                    self?.showSpinner()
                } else {
                    self?.hideSpinner()
                }
            }
            .disposed(by: disposeBag)
    }
}
