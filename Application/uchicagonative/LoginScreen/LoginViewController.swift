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
    let scrollView = UIScrollView()

    let loginLabel = UILabel(title: "Log In", numberOfLines: 1, font: R.font.helveticaNeueCyrMedium(size: 28)!,
                             color: R.color.lightBlack()!)

    let emailTextiField = UITextField(placeholder: "email",
                                      borderStyle: .none, font: R.font.karlaRegular(size: 22)!, spellCheck: .no)

    let passwordTextiField = UITextField(placeholder: "password",
                                         borderStyle: .none, font: R.font.karlaRegular(size: 22)!, isSecureTextEntry: true)

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = R.font.karlaBold(size: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = R.color.lightGrayCustom()!
        button.isEnabled = false
        return button
    }()

    let forgotPasswordButton = UIButton(titleColor: R.color.lightRed()!, title: "Forgot Password?", font: R.font.karlaBold(size: 20)!)

    let createAccountButton = UIButton(titleColor: R.color.lightRed()!, title: "Not a Member? Create an Account",
                                       font: R.font.karlaBold(size: 20)!)

    // if email have a valid form
    var isEmailValid: Bool = false {
        didSet {
            activateLoginButton()
        }
    }

    // if password is not empty
    var isPasswordNotEmpty: Bool = false {
        didSet {
            activateLoginButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextiField.delegate = self
        passwordTextiField.delegate = self
        setupUI()
        // setting button actions
        // Login Action
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        // Forgot password action
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)

        // signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        // scrollView will scrollUp if devices heigh is small like iphone 8 and smaller

        registerKeyBoardNotifications()

        emailTextiField.addTarget(self, action: #selector(isValidEmail), for: .editingChanged)
        passwordTextiField.addTarget(self, action: #selector(isPasswordFieldNotEmpty), for: .editingChanged)
    }

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

    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        emailTextiField.resignFirstResponder()
        passwordTextiField.resignFirstResponder()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        // move the root view up by the distance of keyboard height
        // view.frame.origin.y = 0 - keyboardSize.height / 3
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height / 3)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // move the root view down
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }

    // check correct email
    @objc private func isValidEmail() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        isEmailValid = emailPred.evaluate(with: emailTextiField.text) ? true : false
    }

    // check if password is not empty
    @objc private func isPasswordFieldNotEmpty() {
        guard let text = passwordTextiField.text else { return }
        isPasswordNotEmpty = !text.isEmpty ? true : false
    }

    // activate button if email and password are correct
    private func activateLoginButton() {
        if isEmailValid, isPasswordNotEmpty {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .green
        } else {
            // disable button if email incorrect or password is empty
            loginButton.isEnabled = false
            loginButton.backgroundColor = R.color.lightGrayCustom()!
        }
    }

    // handle login action
    @objc private func handleLogin() {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = emailTextiField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordTextiField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        // LogIn FireBase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in

            // if error - show alert with description
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertOkAction)
                self?.present(alertController, animated: true)

            } else {
                // if success - go to mainMenu
                AppDelegate.shared.rootViewController.switchToMainScreen()
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
        // adding components on screen
        view.addSubview(scrollView)
        scrollView.backgroundColor = Constants.appBackgroundColor

        scrollView.addSubview(loginLabel)

        scrollView.addSubview(emailTextiField)
        let separatorViewEmail = getSeparator()
        emailTextiField.addSubview(separatorViewEmail)

        scrollView.addSubview(passwordTextiField)
        let separatorViewPassword = getSeparator()
        passwordTextiField.addSubview(separatorViewPassword)

        scrollView.addSubview(loginButton)
        scrollView.addSubview(forgotPasswordButton)

        scrollView.addSubview(createAccountButton)

        constrain(scrollView, loginLabel, emailTextiField, separatorViewEmail,
                  passwordTextiField, separatorViewPassword,
                  loginButton, forgotPasswordButton,
                  createAccountButton) { scrollView, loginLabel, emailTextiField, separatorViewEmail,
            passwordTextiField, separatorViewPassword, loginButton, forgotPasswordButton, createAccountButton in

            // scrollView
            scrollView.top == scrollView.superview!.top
            scrollView.left == scrollView.superview!.left
            scrollView.right == scrollView.superview!.right
            scrollView.bottom == scrollView.superview!.bottom

            // Login Label
            loginLabel.centerX == loginLabel.superview!.centerX
            loginLabel.top == loginLabel.superview!.top + 100

            // emailTextField with separator
            emailTextiField.top == loginLabel.bottom + 70
            emailTextiField.left == emailTextiField.superview!.left + Constants.defaultInsets
            emailTextiField.right == emailTextiField.superview!.superview!.right - Constants.defaultInsets
            emailTextiField.height == 30
            separatorViewEmail.top == emailTextiField.bottom
            separatorViewEmail.left == emailTextiField.left
            separatorViewEmail.right == emailTextiField.right
            separatorViewEmail.height == 2

            // passwordTextField with separator
            passwordTextiField.top == emailTextiField.bottom + 50
            passwordTextiField.left == passwordTextiField.superview!.left + Constants.defaultInsets
            passwordTextiField.right == passwordTextiField.superview!.superview!.right - Constants.defaultInsets
            passwordTextiField.height == 30
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

    // generate separatorView
    private func getSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }
}
