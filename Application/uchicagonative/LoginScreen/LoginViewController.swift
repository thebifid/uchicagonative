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

    let loginLabel = UILabel(title: "Log In", numberOfLines: 1, font: R.font.helveticaNeueCyrMedium(size: 28)!, color: R.color.lightBlack()!)

    let emailTextiField = UITextField(placeholder: "email",
                                      borderStyle: .none, font: R.font.karlaRegular(size: 22)!)

    let passwordTextiField = UITextField(placeholder: "password",
                                         borderStyle: .none, font: R.font.karlaRegular(size: 22)!, isSecureTextEntry: true)

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = R.font.karlaBold(size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 24
        button.backgroundColor = R.color.lightGrayCustom()!
        return button
    }()

    let forgotPasswordButton = UIButton(titleColor: R.color.lightRed()!, title: "Forgot Password?", font: R.font.karlaBold(size: 20)!)

    let createAccountButton = UIButton(titleColor: R.color.lightRed()!, title: "Not a Member? Create an Acoount", font: R.font.karlaBold(size: 20)!)

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

        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)

        view.addSubview(createAccountButton)
        constrain(loginLabel, emailTextiField, separatorViewEmail,
                  passwordTextiField, separatorViewPassword,
                  loginButton, forgotPasswordButton,
                  createAccountButton) { loginLabel, emailTextiField, separatorViewEmail,
            passwordTextiField, separatorViewPassword, loginButton, forgotPasswordButton, createAccountButton in

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

            // passwordTextField with separator
            passwordTextiField.top == emailTextiField.bottom + 50
            passwordTextiField.left == passwordTextiField.superview!.left + Constants.defaultInsets
            passwordTextiField.right == passwordTextiField.superview!.right - Constants.defaultInsets
            separatorViewPassword.top == passwordTextiField.bottom
            separatorViewPassword.left == passwordTextiField.left
            separatorViewPassword.right == passwordTextiField.right
            separatorViewPassword.height == 2

            // login button
            loginButton.top == passwordTextiField.bottom + 50
            loginButton.centerX == loginButton.superview!.centerX
            loginButton.width == loginButton.superview!.width - 6 * Constants.defaultInsets
            loginButton.height == 50

            // forgotPasswordButton
            forgotPasswordButton.top == loginButton.bottom
            forgotPasswordButton.centerX == forgotPasswordButton.superview!.centerX

            // createAccountLabel
            createAccountButton.top == forgotPasswordButton.bottom + 20
            createAccountButton.centerX == createAccountButton.superview!.centerX
        }
    }

    private func getSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }
}
