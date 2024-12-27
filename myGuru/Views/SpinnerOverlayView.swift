//
//  SpinnerOverlayView.swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

class SpinnerOverlayView: UIView {
    private let spinner = UIActivityIndicatorView(style: .large)

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.startAnimating()

        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

