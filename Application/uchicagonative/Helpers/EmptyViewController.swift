//
//  EmptyViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class EmptyViewController: UIViewController {
    let dismissButton = UIButton(titleColor: .green, title: "Dismiss", font: .boldSystemFont(ofSize: 35))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.lightBlack()

        setupUI()
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }

    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        view.addSubview(dismissButton)

        constrain(dismissButton) { button in

            button.center == button.superview!.center
        }
    }
}
