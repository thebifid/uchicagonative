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

    private let emailTextFieldView = CustomTextFieldView()

    private let passwordTextFieldView = CustomTextFieldView()

    private let dropDownButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Select an item", for: .normal)
        return button
    }()

    private let dropDownSelectView = CustomSelectButtonView()

    private let popupMenu = PopupMenu()

    private let signUpButton = PrimaryButton()

    private let termText = "By signing up, you agree to our Terms of Service and Privacy Policy"
    private let term = "Terms of Service"
    private let termLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        return label
    }()

    private var formattedText: NSAttributedString?

    private let alreadyMemberButton = UIButton(titleColor: R.color.lightRed()!, title: "Already a member? Log In!",
                                               font: R.font.karlaBold(size: 20)!, breakMode: .byWordWrapping)

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .black
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        setupHandlers()
        setupTextFieldsHandlers()

        viewModel.didUpdateState = {
            let status = self.viewModel.signUpButtonState

            switch status {
            case .animating:
                print("this state")
                self.signUpButton.isEnabled = false
                self.activityIndicator.startAnimating()
                self.signUpButton.backgroundColor = R.color.lightGrayCustom()
            case let .enabled(state):
                if state {
                    self.signUpButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.signUpButton.backgroundColor = .green
                } else {
                    self.signUpButton.isEnabled = true
                    self.signUpButton.backgroundColor = R.color.lightGrayCustom()
                    self.activityIndicator.stopAnimating()
                }

                print("state is", state)
            }
        }

        let termTap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        termLabel.addGestureRecognizer(termTap)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        signUpButton.addTarget(self, action: #selector(HandleSignIn), for: .touchUpInside)
        alreadyMemberButton.addTarget(self, action: #selector(HandleAlreadyMember), for: .touchUpInside)
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)

        scrollView.addSubview(emailTextFieldView)
        emailTextFieldView.configure(placeholder: "name@email.com", spellCheck: .no)

        scrollView.addSubview(passwordTextFieldView)
        passwordTextFieldView.configure(placeholder: "password", isSecureTextEntry: true)

        scrollView.addSubview(dropDownButton)

        constrain(scrollView, emailTextFieldView, passwordTextFieldView) { scrollView, emailTextField, passwordTextField in

            scrollView.edges == scrollView.superview!.edges

            emailTextField.height == 30
            emailTextField.width == emailTextField.superview!.width - 4 * Constants.defaultInsets
            emailTextField.centerX == emailTextField.superview!.centerX
            emailTextField.top == emailTextField.superview!.top + 100

            passwordTextField.height == 30
            passwordTextField.width == emailTextField.width
            passwordTextField.centerX == emailTextField.centerX
            passwordTextField.top == emailTextField.bottom + 30
        }

        scrollView.addSubview(dropDownSelectView)
        dropDownSelectView.configure(labelTitle: "Select Project:", buttonTitle: "Select an item...")

        constrain(passwordTextFieldView, dropDownSelectView) { passwordTextField, dropDownSelectView in

            dropDownSelectView.top == passwordTextField.bottom + 20
            dropDownSelectView.width == passwordTextField.width
            dropDownSelectView.centerX == passwordTextField.centerX

            dropDownSelectView.height == 100
        }

        scrollView.addSubview(popupMenu)
        popupMenu.transform = .init(scaleX: 1, y: 0)

        signUpButton.configure(title: "Sign Up with Email",
                               font: R.font.karlaBold(size: 18)!, backgroundColor: R.color.lightGrayCustom()!, isEnabled: false)

        scrollView.addSubview(signUpButton)

        constrain(dropDownSelectView, signUpButton) { dropDownSelectView, signUpButton in

            signUpButton.top == dropDownSelectView.bottom + 20
            signUpButton.centerX == signUpButton.superview!.centerX
            signUpButton.height == 50
            signUpButton.width == dropDownSelectView.width
        }

        formattedText = String.format(strings: [term],
                                      boldFont: UIFont.boldSystemFont(ofSize: 15),
                                      boldColor: R.color.lightRed()!,
                                      inString: termText,
                                      font: UIFont.systemFont(ofSize: 15),
                                      color: .gray)

        termLabel.attributedText = formattedText

        scrollView.addSubview(termLabel)

        constrain(signUpButton, termLabel) { signUpButton, termLabel in

            termLabel.top == signUpButton.bottom + 20
            termLabel.centerX == termLabel.superview!.centerX
            termLabel.width == signUpButton.width
            termLabel.height == 50
        }

        scrollView.addSubview(alreadyMemberButton)

        constrain(termLabel, alreadyMemberButton) { termLabel, alreadyMemberButton in

            alreadyMemberButton.top == termLabel.bottom + 70
            alreadyMemberButton.centerX == alreadyMemberButton.superview!.centerX
        }

        signUpButton.addSubview(activityIndicator)

        constrain(activityIndicator) { activityIndicator in

            activityIndicator.center == activityIndicator.superview!.center
        }
    }

    @objc private func hidePopUpWindow() {
        scrollView.backgroundColor = .white
        popupMenu.alpha = 0
        popupMenu.transform = .init(scaleX: 1, y: 0)
        signUpButton.isHidden = false
        termLabel.isHidden = false
        alreadyMemberButton.isHidden = false
    }

    private func setupPopUpMenu(withHeight height: CGFloat) {
        constrain(dropDownSelectView, popupMenu) { dropDownSelectView, popupMenu in
            popupMenu.top == dropDownSelectView.top
            popupMenu.width == dropDownSelectView.width
            popupMenu.centerX == dropDownSelectView.centerX
            popupMenu.height == height
        }
    }

    // MARK: - Private Methods

    @objc private func HandleAlreadyMember() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func handleTermTapped(gesture: UITapGestureRecognizer) {
        print("hello")
    }

    @objc private func HandleSignIn() {
        viewModel.createNewUser { result in

            switch result {
            case .success:
                AppDelegate.shared.rootViewController.switchToMainScreen()
            case let .failure(error):
                let alertController = AlertAssist.showErrorAlert(error)
                self.present(alertController, animated: true)
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

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

    private func setupHandlers() {
        dropDownSelectView.didTapButton = { [weak self] in
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.2) {
                self?.scrollView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                self?.navigationController?.navigationBar.alpha = 0.5
                self?.emailTextFieldView.isUserInteractionEnabled = false
                self?.passwordTextFieldView.isUserInteractionEnabled = false
                self?.popupMenu.alpha = 1
                self?.popupMenu.transform = .identity
                self?.signUpButton.isHidden = true
                self?.termLabel.isHidden = true
                self?.alreadyMemberButton.isHidden = true
            }
        }

        viewModel.didFetchedGroups = {
            let height: CGFloat = CGFloat(self.viewModel.availableGroups.count * 30) + 35
            self.setupPopUpMenu(withHeight: height)
            self.popupMenu.layoutIfNeeded()
            self.popupMenu.configure(items: self.viewModel.availableGroups)
            self.dropDownSelectView.activateButton()
        }

        popupMenu.didSelectItem = { [weak self] group in
            self?.viewModel.didChangeGroup(group: group)
            print("group set \(group)")
            self?.dropDownSelectView.setTitle(title: group)

            UIView.animate(withDuration: 0.4, animations: {
                self?.hidePopUpWindow()
                self?.navigationController?.navigationBar.alpha = 1
                self?.emailTextFieldView.isUserInteractionEnabled = true
                self?.passwordTextFieldView.isUserInteractionEnabled = true
            })
        }
    }
}
