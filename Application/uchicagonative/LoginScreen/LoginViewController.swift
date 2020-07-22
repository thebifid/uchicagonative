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

    let loginLabel = UILabel(title: "Log In", numberOfLines: 1, font: R.font.helveticaNeueCyrMedium(size: 28)!)

    let emailTextiField = UITextField(placeholder: "email",
                                      borderStyle: .none, font: R.font.karlaRegular(size: 20)!)

    let passwordTextiField = UITextField(placeholder: "password",
                                         borderStyle: .none, font: R.font.karlaRegular(size: 20)!, isSecureTextEntry: true)

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Log In", for: .normal)
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
        // signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
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
        view.addSubview(loginLabel)

        view.addSubview(emailTextiField)
        let separatorViewEmail = getSeparator()
        emailTextiField.addSubview(separatorViewEmail)

        view.addSubview(passwordTextiField)
        let separatorViewPassword = getSeparator()
        passwordTextiField.addSubview(separatorViewPassword)

        constrain(loginLabel, emailTextiField, separatorViewEmail,
                  passwordTextiField, separatorViewPassword) { loginLabel, emailTextiField, separatorViewEmail, passwordTextiField, separatorViewPassword in

            // Login Label
            loginLabel.centerX == loginLabel.superview!.centerX
            loginLabel.top == loginLabel.superview!.top + 100

            // emailTextField with separator
            emailTextiField.top == loginLabel.bottom + 70
            emailTextiField.left == emailTextiField.superview!.left + Constants.defaultInsets
            emailTextiField.right == emailTextiField.superview!.right - Constants.defaultInsets
            separatorViewEmail.top == emailTextiField.bottom
            separatorViewEmail.left == emailTextiField.left
            separatorViewEmail.right == emailTextiField.right
            separatorViewEmail.height == 2
            separatorViewEmail.width == 100

            // passwordTextField with separator
            passwordTextiField.top == emailTextiField.bottom + 70
            passwordTextiField.left == passwordTextiField.superview!.left + Constants.defaultInsets
            passwordTextiField.right == passwordTextiField.superview!.right - Constants.defaultInsets
            separatorViewPassword.top == passwordTextiField.bottom
            separatorViewPassword.left == passwordTextiField.left
            separatorViewPassword.right == passwordTextiField.right
            separatorViewPassword.height == 2
            separatorViewPassword.width == 100
        }
    }

    private func getSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }
}
