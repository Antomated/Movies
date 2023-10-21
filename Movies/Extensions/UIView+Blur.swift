//
//  UIView+Blur.swift
//  Movies
//
//  Created by Anton Petrov on 21.10.2023.
//

import UIKit

extension UIView {
    func applyBlurEffect(alpha: CGFloat = 0.5) {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        self.alpha = alpha
    }
}
