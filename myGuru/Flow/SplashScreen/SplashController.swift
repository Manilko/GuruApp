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
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: Asset.Images.icon.name)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.backgroundColor = .clear
    }

    private func setupBindings() {
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
