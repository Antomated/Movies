//
//  UIViewController+Blur.swift
//  Movies
//
//  Created by Anton Petrov on 22.10.2023.
//

import UIKit

extension UIViewController {
    func setupBlur() {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
    }
}
