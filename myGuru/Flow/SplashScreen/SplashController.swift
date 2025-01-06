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
    private let splashView: SplashViewProtocol

    init(viewModel: SplashViewModelProtocol, view: SplashViewProtocol) {
        self.viewModel = viewModel
        self.splashView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.input.startLoading.accept(20)
    }

    private func setupUI() {
        splashView.backgroundImageView.image = UIImage(named: Asset.Images.icon.name)
        splashView.backgroundColor = .clear
    }

    private func setupBindings() {
        viewModel.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isLoading in
                if isLoading {
                    self?.showSpinner()
                } else {
                    self?.hideSpinner()
                }
            }
            .disposed(by: disposeBag)
    }
}
