//
//  ViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import FirebaseAuth
import KeyboardNotificationsObserver
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Init

    init(viewModel model: LoginViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let viewModel: LoginViewModel!

    // MARK: - UI Controls

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

    private let keyboardObserver = KeyboardNotificationsObserver()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .black
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let didUpdateHandler = {
            let buttonState = self.viewModel.loginButtonState
            switch buttonState {
            case .animating:
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = R.color.lightGrayCustom()
                self.activityIndicator.startAnimating()
            case let .enabled(state):
                self.loginButton.isEnabled = state
                self.loginButton.backgroundColor = state ? .green : R.color.lightGrayCustom()
                self.activityIndicator.stopAnimating()
            }
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

    // MARK: - Private Methods

    private func setupTextFieldsHandlers() {
        let didEmailChange: ((String) -> Void) = { [weak self] email in
            self?.viewModel.setEmail(email)
        }
        emailTextFieldView.didChangeText = didEmailChange

        let didPasswordChange: ((String) -> Void) = { [weak self] password in
            self?.viewModel.setPassword(password)
        }
        passwordTextFieldView.didChangeText = didPasswordChange
    }

    // observers for show and hide keyboard
    private func registerKeyBoardNotifications() {
        if Constants.deviseHeight < 700 {
            keyboardObserver.onWillShow = { [weak self] info in
                self?.scrollView.contentOffset = CGPoint(x: 0, y: info.endFrame.height / 3)
            }

            keyboardObserver.onWillHide = { [weak self] _ in
                self?.scrollView.contentOffset = .zero
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // handle login action
    @objc private func handleLogin() {
        viewModel.login { [weak self] result in
            switch result {
            case .success:
                AppDelegate.shared.rootViewController.switchToMainScreen()
            case let .failure(error):
                self?.showAlert(withError: error)
            }
        }
    }

    private func showAlert(withError error: Error) {
        let ac = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(alertOkAction)
        present(ac, animated: true)
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

    // MARK: - UI Actions

    private func setupUI() {
        // configure Log In button
        loginButton.configure(title: "Log In",
                              font: R.font.karlaBold(size: 18)!,
                              backgroundColor: R.color.lightGrayCustom()!,
                              isEnabled: false)

        // adding components on screen
        view.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.fillSuperView()

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

        loginButton.addSubview(activityIndicator)
        constrain(loginButton, activityIndicator) { loginButton, activityIndicator in
            activityIndicator.center == loginButton.center
        }
    }
}
