//
//  RecoverPasswordViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class RecoverPasswordViewController: UIViewController {
    // MARK: - Init

    init(viewModel model: RecoverPasswordViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let viewModel: RecoverPasswordViewModel

    // MARK: - UI Controls

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .black
        return ai
    }()

    private let emailTextField = CustomTextFieldView()

    private let requestNewPasswordButton = PrimaryButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /// This is a handler for change 'Request New Password' button state and start/stop activity indicator
        let didUpdateHandler = {
            let buttonState = self.viewModel.requestNewPasswordButtonState
            switch buttonState {
            case .animating:
                self.requestNewPasswordButton.isEnabled = false
                self.requestNewPasswordButton.backgroundColor = R.color.lightGrayCustom()
                self.activityIndicator.startAnimating()

            case let .enabled(state):
                self.activityIndicator.stopAnimating()
                self.requestNewPasswordButton.isEnabled = state
                self.requestNewPasswordButton.backgroundColor = state ? .green : R.color.lightGrayCustom()
            }
        }
        viewModel.didUpdateState = didUpdateHandler

        setupUI()
        setupTextFieldHandler()

        requestNewPasswordButton.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Private Methods

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupTextFieldHandler() {
        let didEmailChange: ((String) -> Void) = { [weak self] email in
            self?.viewModel.setEmail(email)
        }
        emailTextField.didChangeText = didEmailChange
    }

    /// This method try to reset FireBase users's password and shows success or error alert to user
    @objc private func handleResetPassword() {
        viewModel.resetPassword { [weak self] result in
            switch result {
            case .success:
                let handler: ((UIAlertAction) -> Void) = { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                let ac = AlertAssist.showSuccessAlert(withMessage:
                    "Instructions for password recovery have been sent to your email address.", handler: handler)
                self?.present(ac, animated: true)
            case let .failure(error):
                let ac = AlertAssist.showErrorAlert(error)
                self?.present(ac, animated: true)
            }
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)

        scrollView.addSubview(emailTextField)
        emailTextField.configure(placeholder: "name@email.com", spellCheck: .no)

        scrollView.addSubview(requestNewPasswordButton)
        requestNewPasswordButton.configure(title: "Request New Password",
                                           font: R.font.karlaBold(size: 18)!, backgroundColor: R.color.lightGrayCustom()!, isEnabled: false)

        constrain(scrollView, emailTextField, requestNewPasswordButton) { scrollView, emailTextField, requestNewPasswordButton in

            scrollView.edges == scrollView.superview!.edges

            emailTextField.height == 30
            emailTextField.width == emailTextField.superview!.width - 4 * Constants.defaultInsets
            emailTextField.centerX == emailTextField.superview!.centerX
            emailTextField.top == emailTextField.superview!.top + 100

            requestNewPasswordButton.top == emailTextField.bottom + 40
            requestNewPasswordButton.width == emailTextField.width
            requestNewPasswordButton.centerX == emailTextField.centerX
            requestNewPasswordButton.height == 50
        }

        requestNewPasswordButton.addSubview(activityIndicator)

        constrain(activityIndicator) { activityIndicator in
            activityIndicator.center == activityIndicator.superview!.center
        }
    }
}
