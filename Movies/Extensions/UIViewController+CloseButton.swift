//
//  UIViewController+CloseButton.swift
//  Movies
//
//  Created by Anton Petrov on 22.10.2023.
//

import UIKit

extension UIViewController {
    func setupCloseButton() {
        guard let navigationController else { return }
        navigationController.navigationBar.backgroundColor = .systemGroupedBackground
        let item = UIBarButtonItem(barButtonSystemItem: .close,
                                   target: self,
                                   action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = item
    }

    @objc private func didTapCloseButton() {
        if let navigationController, navigationController.presentingViewController != nil {
            navigationController.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
