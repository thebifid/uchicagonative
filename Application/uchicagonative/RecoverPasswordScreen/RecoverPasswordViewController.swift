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

        /// Handler for change 'Request New Password' button state and start/stop activity indicator
        viewModel.didUpdateState = { [weak self] in
            let buttonState = self?.viewModel.requestNewPasswordButtonState
            switch buttonState {
            case .animating:
                self?.requestNewPasswordButton.isEnabled = false
                self?.activityIndicator.startAnimating()

            case let .enabled(state):
                self?.activityIndicator.stopAnimating()
                self?.requestNewPasswordButton.isEnabled = state
            case .none:
                break
            }
        }

        setupUI()
        setupTextFieldHandler()

        requestNewPasswordButton.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)

        scrollView.keyboardDismissMode = .onDrag
    }

    // MARK: - Private Methods

    private func setupTextFieldHandler() {
        let didEmailChange: ((String) -> Void) = { [weak self] email in
            self?.viewModel.setEmail(email)
        }
        emailTextField.didChangeText = didEmailChange
    }

    /// Try to reset FireBase users's password and shows success or error alert to user
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
        emailTextField.configure(placeholder: "name@email.com", spellCheck: .no, nextTextField: nil)

        scrollView.addSubview(requestNewPasswordButton)
        requestNewPasswordButton.configure(title: "Request New Password",
                                           font: R.font.karlaBold(size: Constants.buttonFontSize)!, isEnabled: false)

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
