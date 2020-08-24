//
//  ViewControllerWithMiddleBackSwipe.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullWidthBackGesture()
    }

    private lazy var fullWidthBackGestureRecognizer = UIPanGestureRecognizer()

    private func setupFullWidthBackGesture() {
        guard
            let interactivePopGestureRecognizer = interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets")
        else {
            return
        }

        fullWidthBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullWidthBackGestureRecognizer.delegate = self
        view.addGestureRecognizer(fullWidthBackGestureRecognizer)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeToBackEnabled = interactivePopGestureRecognizer?.isEnabled == true
        let isThereStackedViewControllers = viewControllers.count > 1
        return isSystemSwipeToBackEnabled && isThereStackedViewControllers
    }
}
