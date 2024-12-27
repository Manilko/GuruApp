//
//  ViewController .swift
//  myGuru
//
//  Created by Yevhenii Manilko on 28.12.2024.
//

import UIKit

extension UIViewController {
    func showSpinner() {
        guard view.subviews.contains(where: { $0 is SpinnerOverlayView }) == false else { return }
        let spinnerOverlay = SpinnerOverlayView()
        view.addSubview(spinnerOverlay)
    }

    func hideSpinner() {
        view.subviews
            .filter { $0 is SpinnerOverlayView }
            .forEach { $0.removeFromSuperview() }
    }
}
