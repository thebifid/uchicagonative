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
        button.backgroundColor = .orange
        button.setTitle("Select an item", for: .normal)
        return button
    }()

    private let dropDownSelectView = CustomSelectButtonView()

    private let popupMenu = PopupMenu()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        setupHandlers()
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)

        scrollView.addSubview(emailTextField)
        emailTextField.configure(placeholder: "name@email.com", spellCheck: .no)

        scrollView.addSubview(passwordTextField)
        passwordTextField.configure(placeholder: "password", isSecureTextEntry: true)

        scrollView.addSubview(dropDownButton)

        constrain(scrollView, emailTextField, passwordTextField) { scrollView, emailTextField, passwordTextField in

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

        constrain(passwordTextField, dropDownSelectView) { passwordTextField, dropDownSelectView in

            dropDownSelectView.top == passwordTextField.bottom + 20
            dropDownSelectView.width == passwordTextField.width
            dropDownSelectView.centerX == passwordTextField.centerX

            dropDownSelectView.height == 100
        }

        scrollView.addSubview(popupMenu)
        popupMenu.transform = .init(scaleX: 1, y: 0)
    }

    // MARK: - Private Methods

    private func setupHandlers() {
        dropDownSelectView.didTapButton = {
            UIView.animate(withDuration: 0.2) {
                self.scrollView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                self.popupMenu.alpha = 1
                self.popupMenu.transform = .identity
            }
        }

        viewModel.didFetchedGroups = {
            let heihght: CGFloat = CGFloat(self.viewModel.availableGroups!.count * 30) + 35
            self.setupPopUpMenu(withHeight: heihght)
            self.popupMenu.layoutIfNeeded()
            self.popupMenu.configure(items: self.viewModel.availableGroups!)
        }

        popupMenu.didSelectItem = { [weak self] group in
            self?.viewModel.didChangeGroup(group: group)
            print("group set \(group)")
            self?.dropDownSelectView.setTitle(title: group)

            UIView.animate(withDuration: 0.4, animations: {
                self?.scrollView.backgroundColor = .white
                self?.popupMenu.alpha = 0
                self?.popupMenu.transform = .init(scaleX: 1, y: 0)
            })
        }
    }

    private func setupPopUpMenu(withHeight height: CGFloat) {
        constrain(dropDownSelectView, popupMenu) { dropDownSelectView, popupMenu in
            popupMenu.top == dropDownSelectView.top
            popupMenu.width == dropDownSelectView.width
            popupMenu.centerX == dropDownSelectView.centerX
            popupMenu.height == height
        }
    }
}
