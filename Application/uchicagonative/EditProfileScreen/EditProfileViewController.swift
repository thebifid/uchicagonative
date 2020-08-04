//
//  EditProfileViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit
///  Shows editing user's profile
class EditProfileViewController: UIViewController {
    // MARK: - Init

    init(viewModel model: EditProfileViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let viewModel: EditProfileViewModel
    private let spacing: CGFloat = 30

    private var pickerViewCard: PickerViewController!

    // MARK: - Enums

    enum PickerViewType {
        case none, gender, project
    }

    // MARK: - UI Controls

    private let scrollView = UIScrollView()

    private let emailLabel: UILabel = {
        let label = UILabel(title: "Email:", font: R.font.karlaBold(size: Constants.fontSize)!, color: R.color.lightBlack()!)
        return label
    }()

    private let firstNameTextFeildView = CustomTextFieldView()
    private let lastNameTextFieldView = CustomTextFieldView()
    private let birthdayTextFieldView = CustomTextFieldView()
    private let zipCodeTextFieldView = CustomTextFieldView()

    private let selectGenderSelectView = CustomSelectButtonView()
    private let selectProjectSelectView = CustomSelectButtonView()

    private let saveButton = PrimaryButton()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .large
        ai.color = .white
        return ai
    }()

    private let buttonActivityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .black
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        setupHandlers()
        setupUI()
        setupTextFieldsHanslers()

        activityIndicator.startAnimating()
        scrollView.backgroundColor = .lightGray
        scrollView.isUserInteractionEnabled = false
        scrollView.keyboardDismissMode = .onDrag

        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(sendUserInfo), for: .touchUpInside)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Private Methods

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func sendUserInfo() {
        viewModel.sendUserInfo { [weak self] result in

            switch result {
            case let .failure(error):
                let alert = AlertAssist.showErrorAlert(error)
                self?.present(alert, animated: true)

            case .success:
                let alert = AlertAssist.showSuccessAlert(withMessage: "Your profile successfully saved.", handler: nil)
                self?.present(alert, animated: true)
            }
        }
    }

    private func setupTextFieldsHanslers() {
        firstNameTextFeildView.didChangeText = { [weak self] firstName in
            self?.viewModel.setFirstName(firstName)
        }

        lastNameTextFieldView.didChangeText = { [weak self] lastName in
            self?.viewModel.setLastName(lastName)
        }

        birthdayTextFieldView.didChangeText = { [weak self] birthYear in
            guard let birthYear = Int(birthYear) else { return }
            self?.viewModel.setBirthYear(birthYear)
        }

        zipCodeTextFieldView.didChangeText = { [weak self] zipCode in
            guard let zipCode = Int(zipCode) else { return }
            self?.viewModel.setZipCode(zipCode)
        }
    }

    private func fetchUserData() {
        viewModel.fetchUserInfo { [weak self] result in

            switch result {
            case let .failure(error):
                let alert = AlertAssist.showErrorAlert(error)
                self?.present(alert, animated: true)

            case .success:
                self?.emailLabel.text = "Email: \(self?.viewModel.userInfo["email"] ?? "")"
                self?.firstNameTextFeildView.text = self?.viewModel.userInfo["firstName"] as? String ?? ""
                self?.lastNameTextFieldView.text = self?.viewModel.userInfo["lastName"] as? String ?? ""
                self?.birthdayTextFieldView.text = "\(self?.viewModel.userInfo["birthYear"] ?? "")"
                self?.zipCodeTextFieldView.text = "\(self?.viewModel.userInfo["zipCode"] ?? "")"
                self?.selectGenderSelectView.setTitle(title: self?.viewModel.userInfo["gender"] as? String ?? "Select an item...")
                self?.selectProjectSelectView.setTitle(title: self?.viewModel.userInfo["projectId"] as? String ?? "Select an item...")

                self?.activityIndicator.stopAnimating()
                self?.scrollView.backgroundColor = .white
                self?.scrollView.isUserInteractionEnabled = true

                if self?.viewModel.userInfo["role"] as? String != "admin" {
                    self?.selectProjectSelectView.disableButton()
                }
            }
        }
    }

    private func setupHandlers() {
        viewModel.didUpdateState = { [weak self] in
            let state = self?.viewModel.saveButtonState
            switch state {
            case .animating:
                self?.buttonActivityIndicator.startAnimating()
                self?.saveButton.isEnabled = false
                self?.saveButton.backgroundColor = R.color.lightGrayCustom()
            case let .enabled(status):
                self?.buttonActivityIndicator.stopAnimating()
                self?.saveButton.isEnabled = status ? true : false
                self?.saveButton.backgroundColor = status ? R.color.mediumAquamarine() : R.color.lightGrayCustom()
            case .none:
                break
            }
        }

        selectGenderSelectView.didTapButton = { [weak self] in
            self?.scrollView.isUserInteractionEnabled = false
            self?.dismissKeyboard()
            self?.showPickerViewCard(items: self?.viewModel.genderList ?? [],
                                     selectedItem: self?.viewModel.userInfo["gender"] as? String ?? "",
                                     title: "Select Your Gender") { [weak self] value in
                self?.scrollView.isUserInteractionEnabled = true
                self?.viewModel.setGender(value)
                self?.selectGenderSelectView.setTitle(title: value)
                self?.hidePickerViewCard()
                self?.view.endEditing(true)
            }
        }

        selectProjectSelectView.didTapButton = { [weak self] in
            self?.scrollView.isUserInteractionEnabled = false
            self?.dismissKeyboard()
            self?.showPickerViewCard(items: self?.viewModel.groups ?? [],
                                     selectedItem: self?.viewModel.userInfo["projectId"] as? String ?? "",
                                     title: "Select Project") { [weak self] value in
                self?.scrollView.isUserInteractionEnabled = true
                self?.viewModel.setProject(value)
                self?.selectProjectSelectView.setTitle(title: value)
                self?.hidePickerViewCard()
                self?.view.endEditing(true)
            }
        }
    }

    private func showPickerViewCard(items: [String], selectedItem: String,
                                    title: String = "", didDoneButtonTapped: @escaping (String) -> Void) {
        guard pickerViewCard == nil else { return }
        pickerViewCard = PickerViewController()
        view.addSubview(pickerViewCard.view)
        pickerViewCard.configure(items: items, selectedItem: selectedItem, labelText: title)
        pickerViewCard.showPickerViewCard(didDoneButtonTapped: didDoneButtonTapped)
    }

    private func hidePickerViewCard() {
        pickerViewCard.hidePickerViewCard()
        pickerViewCard = nil
    }

    private func makeConstrain(downView: UIView, upperView: UIView, height: CGFloat = 30) {
        constrain(downView, upperView) { firstView, secondView in

            firstView.top == secondView.bottom + spacing
            firstView.centerX == firstView.superview!.centerX
            firstView.width == firstView.superview!.width - 2 * Constants.defaultInsets
            firstView.height == height
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        scrollView.alwaysBounceVertical = true

        // ScrollView
        scrollView.backgroundColor = R.color.appBackgroundColor()!
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)
        scrollView.fillSuperView()

        scrollView.addSubview(emailLabel)
        constrain(emailLabel) { emailLabel in

            emailLabel.top == emailLabel.superview!.top + 10
            emailLabel.centerX == emailLabel.superview!.centerX
            emailLabel.width == emailLabel.superview!.width - 2 * Constants.defaultInsets
        }

        firstNameTextFeildView.configure(placeholder: "First Name", textFieldInputType: .latters, autocapitalization: .words)
        scrollView.addSubview(firstNameTextFeildView)
        makeConstrain(downView: firstNameTextFeildView, upperView: emailLabel)

        lastNameTextFieldView.configure(placeholder: "Last Name", textFieldInputType: .latters, autocapitalization: .words)
        scrollView.addSubview(lastNameTextFieldView)
        makeConstrain(downView: lastNameTextFieldView, upperView: firstNameTextFeildView)

        birthdayTextFieldView.configure(placeholder: "Year of Birth", maxLenght: 4, textFieldInputType: .digits)
        scrollView.addSubview(birthdayTextFieldView)
        makeConstrain(downView: birthdayTextFieldView, upperView: lastNameTextFieldView)

        zipCodeTextFieldView.configure(placeholder: "Zip Code", maxLenght: 5, textFieldInputType: .digits)
        scrollView.addSubview(zipCodeTextFieldView)
        makeConstrain(downView: zipCodeTextFieldView, upperView: birthdayTextFieldView)

        selectGenderSelectView.setAnimation(enabled: false)
        selectGenderSelectView.configure(labelTitle: "Select Your Gender", buttonTitle: "Select an item...")
        scrollView.addSubview(selectGenderSelectView)
        makeConstrain(downView: selectGenderSelectView, upperView: zipCodeTextFieldView, height: 90)

        selectProjectSelectView.setAnimation(enabled: false)
        selectProjectSelectView.configure(labelTitle: "Select Project", buttonTitle: "Select an item...")
        scrollView.addSubview(selectProjectSelectView)
        makeConstrain(downView: selectProjectSelectView, upperView: selectGenderSelectView, height: 90)

        saveButton.configure(title: "Save Changes", font: R.font.karlaBold(size: 18)!)
        scrollView.addSubview(saveButton)

        constrain(saveButton, selectProjectSelectView) { saveButton, selectProjectSelectView in

            saveButton.top == selectProjectSelectView.bottom + spacing
            saveButton.centerX == saveButton.superview!.centerX
            saveButton.width == saveButton.superview!.width - 4 * Constants.defaultInsets
            saveButton.height == 50
        }

        scrollView.addSubview(activityIndicator)

        constrain(activityIndicator) { activityIndicator in

            activityIndicator.centerX == activityIndicator.superview!.centerX
            activityIndicator.centerY == activityIndicator.superview!.centerY - 3 * topbarHeight
        }

        saveButton.addSubview(buttonActivityIndicator)

        constrain(buttonActivityIndicator) { buttonActivityIndicator in
            buttonActivityIndicator.center == buttonActivityIndicator.superview!.center
        }
    }
}
