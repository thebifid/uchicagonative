//
//  CreateAccountViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class CreateAccountViewController: UIViewController {
    // MARK: - Init

    init(viewModel model: CreateAccountViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private var viewModel: CreateAccountViewModel

    // MARK: - UI Controls

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let emailTextField = CustomTextFieldView()

    private let passwordTextField = CustomTextFieldView()

    private let dropDownButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        dropDownButton.addTarget(self, action: #selector(handleDD), for: .touchUpInside)
    }

    @objc private func handleDD() {
        print("DD")
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)

        scrollView.addSubview(emailTextField)
        emailTextField.configure(placeholder: "name@email.com", spellCheck: .no)

        scrollView.addSubview(passwordTextField)
        passwordTextField.configure(placeholder: "password", isSecureTextEntry: true)

        scrollView.addSubview(dropDownButton)

        constrain(scrollView, emailTextField, passwordTextField, dropDownButton) { scrollView, emailTextField, passwordTextField, dropDownButton in

            scrollView.edges == scrollView.superview!.edges

            emailTextField.height == 30
            emailTextField.width == emailTextField.superview!.width - 4 * Constants.defaultInsets
            emailTextField.centerX == emailTextField.superview!.centerX
            emailTextField.top == emailTextField.superview!.top + 100

            passwordTextField.height == 30
            passwordTextField.width == emailTextField.width
            passwordTextField.centerX == emailTextField.centerX
            passwordTextField.top == emailTextField.bottom + 30

            dropDownButton.height == 30
            dropDownButton.width == passwordTextField.width
            dropDownButton.top == passwordTextField.bottom + 30
            dropDownButton.centerX == passwordTextField.centerX
        }
    }
}
