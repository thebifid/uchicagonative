//
//  RootViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current) // 1
        current.view.frame = view.bounds // 2
        view.addSubview(current.view) // 3
        current.didMove(toParent: self) // 4
    }

    func showLoginScreen() {
        let new = UINavigationController(rootViewController: LoginViewController()) // 1
        addChild(new) // 2
        new.view.frame = view.bounds // 3
        view.addSubview(new.view) // 4
        new.didMove(toParent: self) // 5
        current.willMove(toParent: nil) // 6
        current.view.removeFromSuperview() // 7
        current.removeFromParent() // 8
        current = new // 9
    }

    func switchToMainScreen() {
        let mainViewController = MenuScreenViewController()
        let mainScreen = UINavigationController(rootViewController: mainViewController)
        animateFadeTransition(to: mainScreen)
    }

    func switchToLogout() {
        let loginViewController = LoginViewController()
        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: logoutScreen)
    }

    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)

        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }

    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)

        transition(from: current, to: new, duration: 0.3,
                   options: [.transitionCrossDissolve, .curveEaseOut], animations: {}) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?() // 1
        }
    }

    init() {
        current = SplashViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
