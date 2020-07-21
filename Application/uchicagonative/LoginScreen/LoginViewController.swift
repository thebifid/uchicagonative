//
//  ViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class LoginViewController: UIViewController {
    // AppLogo or title for login screen
    let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8085949421, green: 1, blue: 0.9020573497, alpha: 1)
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    let loginLabel = UILabel(title: "Input your login")

    let loginTextiField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Login..."
        tf.borderStyle = .roundedRect
        return tf
    }()

    let passwordLabel = UILabel(title: "Input your password")

    let passwordTextiField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.appBackgroundColor

        setupUI()

        // setting button actions
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        print("Login button pressed...")

        let msvc = MenuScreenViewController()
        let navController = UINavigationController(rootViewController: msvc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    @objc private func handleSignUp() {
        print("SignUp button pressed...")
    }

    private func setupUI() {
        // stackView for logo, login and password fields
        let stackView = VerticalStackVIew(arrangedSubviews:
            [
                appLogo,
                loginLabel,
                loginTextiField,
                passwordLabel,
                passwordTextiField,
                loginButton,
                signUpButton
            ], spacing: 12)

        view.addSubview(stackView)

        constrain(stackView, appLogo) { stackView, appLogo in
            // constraints for stackView
            stackView.centerY == stackView.superview!.centerY
            stackView.centerX == stackView.superview!.centerX
            stackView.width == stackView.superview!.width - 32

            // constraints for logo
            appLogo.height == 100
        }
    }
}
