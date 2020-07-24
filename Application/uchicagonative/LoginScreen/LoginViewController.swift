//
//  ViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    var viewModel: LoginViewModel!
    private let scrollView = UIScrollView()

    private let loginLabel = UILabel(title: "Log In", numberOfLines: 1, font: R.font.helveticaNeueCyrMedium(size: 28)!,
                                     color: R.color.lightBlack()!)

    private let emailTextFieldView = CustomTextFieldView()
    private let passwordTextFieldView = CustomTextFieldView()

    private var loginButton = PrimaryButton()

    private let forgotPasswordButton = UIButton(titleColor: R.color.lightRed()!,
                                                title: "Forgot Password?", font: R.font.karlaBold(size: 20)!)

    private let createAccountButton = UIButton(titleColor: R.color.lightRed()!, title: "Not a Member? Create an Account",
                                               font: R.font.karlaBold(size: 20)!, breakMode: .byWordWrapping)

    override func viewDidLoad() {
        super.viewDidLoad()

        let didUpdateHandler = {
            let isEnabled = self.viewModel.isLoginButtonEnabled()
            self.loginButton.isEnabled = isEnabled
            self.loginButton.backgroundColor = isEnabled ? .green : R.color.lightGrayCustom()
        }
        viewModel.didUpdateState = didUpdateHandler

        setupTextFieldsHandlers()

        setupUI()
        // setting button actions
        // Login Action
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        // Forgot password action
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)

        // scrollView will scrollUp if devices heigh is small like iphone 8 and smaller
        registerKeyBoardNotifications()
    }

    private func setupTextFieldsHandlers() {
        let didEmailChange: ((String) -> Void) = { [weak self] email in
            self?.viewModel?.setEmail(email)
        }
        emailTextFieldView.didChangeText = didEmailChange

        let didPasswordChange: ((String) -> Void) = { [weak self] password in
            self?.viewModel?.setPassword(password)
        }
        passwordTextFieldView.didChangeText = didPasswordChange
    }

    // observers for show and hide keyboard
    private func registerKeyBoardNotifications() {
        if Constants.deviseHeight < 700 {
            NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow),
                                                   name: UIResponder.keyboardWillShowNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide),
                                                   name: UIResponder.keyboardDidHideNotification, object: nil)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        // move the root view up by the distance of keyboard height
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height / 3)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // move the root view down
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }

    // handle login action
    @objc private func handleLogin() {
        loginButton.isEnabled = false
        viewModel.login { [weak self] result in
            switch result {
            case .success:
                AppDelegate.shared.rootViewController.switchToMainScreen()
            case let .failure(error):
                print(error.localizedDescription)
                self?.loginButton.isEnabled = true
            }
        }
    }

    // handle forget password action
    @objc private func handleForgotPassword() {
        let emptyViewController = EmptyViewController()
        emptyViewController.modalPresentationStyle = .fullScreen
        present(emptyViewController, animated: true)
    }

    // handle sign up action
    @objc private func handleSignUp() {
        print("SignUp button pressed...")
    }

    private func setupUI() {
        // configure Log In button
        loginButton.configure(title: "Log In",
                              font: R.font.karlaBold(size: 18)!,
                              backgroundColor: R.color.lightGrayCustom()!,
                              isEnabled: false)

        // adding components on screen
        view.addSubview(scrollView)
        scrollView.backgroundColor = .white

        // ScrollView
        scrollView.fillsuperView()

        // Login label constraints
        scrollView.addSubview(loginLabel)
        constrain(loginLabel) { loginLabel in
            loginLabel.centerX == loginLabel.superview!.centerX
            loginLabel.top == loginLabel.superview!.top + 100
        }

        // emailTextFieldView
        emailTextFieldView.configure(placeholder: "email",
                                     spellCheck: .no)
        scrollView.addSubview(emailTextFieldView)
        constrain(loginLabel, emailTextFieldView) { loginLabel, emailTextFieldView in
            emailTextFieldView.top == loginLabel.bottom + 30
            emailTextFieldView.left == emailTextFieldView.superview!.superview!.left + Constants.defaultInsets
            emailTextFieldView.right == emailTextFieldView.superview!.superview!.right - Constants.defaultInsets
            emailTextFieldView.height == 30
        }

        // passwordTextFieldView
        passwordTextFieldView.configure(placeholder: "password",
                                        isSecureTextEntry: true)
        scrollView.addSubview(passwordTextFieldView)
        constrain(emailTextFieldView, passwordTextFieldView) { emailTextFieldView, passwordTextFieldView in
            passwordTextFieldView.top == emailTextFieldView.bottom + 30
            passwordTextFieldView.left == passwordTextFieldView.superview!.superview!.left + Constants.defaultInsets
            passwordTextFieldView.right == passwordTextFieldView.superview!.superview!.right - Constants.defaultInsets
            passwordTextFieldView.height == 30
        }

        // buttonsView block
        let buttonsView = UIView()
        scrollView.addSubview(buttonsView)

        buttonsView.addSubview(loginButton)
        buttonsView.addSubview(forgotPasswordButton)
        buttonsView.addSubview(createAccountButton)

        // passwordTextField and buttonsView constraints
        constrain(passwordTextFieldView, buttonsView) { passwordTextFieldView, buttonsView in

            buttonsView.width == buttonsView.superview!.width - 4 * Constants.defaultInsets
            buttonsView.centerX == buttonsView.superview!.centerX
            buttonsView.top == passwordTextFieldView.bottom + 50
        }

        // constraints in buttonsView ( loginButton, frogotPasswordButton and createAccountButton )
        constrain(buttonsView, loginButton,
                  forgotPasswordButton, createAccountButton) { buttonsView, loginButton, forgotPasswordButton, createAccountButton in

            // login button constraints
            loginButton.top == buttonsView.top
            loginButton.width == loginButton.superview!.width
            loginButton.height == 50

            // forgotButton constraints
            forgotPasswordButton.top == loginButton.bottom + 3
            forgotPasswordButton.centerX == forgotPasswordButton.superview!.centerX

            // createAccountButton constraints
            createAccountButton.top == forgotPasswordButton.bottom + 10
            createAccountButton.centerX == createAccountButton.superview!.centerX
            createAccountButton.width == loginButton.width

            buttonsView.bottom == createAccountButton.bottom
        }
    }
}
