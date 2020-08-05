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

/// Shows login screen
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

    private let viewModel: LoginViewModel

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

        /// Handler for change 'Log In' button state and start/stop activity indicator
        let didUpdateHandler = {
            let buttonState = self.viewModel.loginButtonState
            switch buttonState {
            case .animating:
                self.loginButton.isEnabled = false
                self.activityIndicator.startAnimating()
            case let .enabled(state):
                self.loginButton.isEnabled = state
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

        // Create account action
        createAccountButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        // scrollView will scrollUp if devices heigh is small like iphone 8 and smaller
        registerKeyBoardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
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

    // setting up observers for show and hide keyboard
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
            case let .success(state):
                if state {
                    FirebaseManager.sharedInstance.fetchUser { user in
                        AppDelegate.shared.rootViewController.switchToMainScreen(userSession: UserSession(user: user))
                    }
                } else {
                    let message = "Your account data is not set. Please, try registering again with same password or reset it."
                    let alert = AlertAssist.showCustomAlert("Error!",
                                                            message: message,
                                                            optionHadler: nil)
                    self?.present(alert, animated: true)
                    do {
                        try FirebaseAuth.Auth.auth().signOut()
                        AppDelegate.shared.rootViewController.switchToLogout()
                    } catch let logOutError {
                        let alert = AlertAssist.showErrorAlert(logOutError)
                        self?.present(alert, animated: true)
                    }
                }

            case let .failure(error):
                let alert = AlertAssist.showErrorAlert(error)
                self?.present(alert, animated: true)
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
        let recoverPasswordViewController = RecoverPasswordViewController(viewModel: RecoverPasswordViewModel())
        recoverPasswordViewController.navigationItem.title = "Recover Password"
        navigationController?.pushViewController(recoverPasswordViewController, animated: true)
    }

    // handle sign up action
    @objc private func handleSignUp() {
        let createAccountController = CreateAccountViewController(viewModel: CreateAccountViewModel())
        createAccountController.navigationItem.title = "Create Account"
        navigationController?.pushViewController(createAccountController, animated: true)
    }

    // MARK: - UI Actions

    private func setupUI() {
        // configure Log In button
        loginButton.configure(title: "Log In",
                              font: R.font.karlaBold(size: 18)!,
                              isEnabled: false)

        // adding components on screen
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
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
