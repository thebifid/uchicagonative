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

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }

    func showLoginScreen() {
        let new = EmptyViewController()
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = new
    }

    func switchToMainScreen() {
        let mainScreen = MenuScreenViewController()
        animateFadeTransition(to: mainScreen)
    }

    func switchToLogout() {
        let logoutScreen = LoginViewController(viewModel: LoginViewModel())
        let navController = UINavigationController(rootViewController: logoutScreen)
        animateDismissTransition(to: navController)
    }

    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)

        let animation = {
            new.view.frame = self.view.bounds
        }

        transition(from: current, to: new, duration: 0.3, options: [], animations: animation) { _ in
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
                   options: [.transitionCrossDissolve, .curveEaseOut], animations: nil) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
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
