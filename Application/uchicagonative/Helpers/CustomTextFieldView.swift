//
//  CustomTextField.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 24.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class CustomTextFieldView: UIView {
    // MARK: - UI Controls

    private let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.spellCheckingType = .no
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.font = R.font.karlaBold(size: Constants.textFieldFontSize)!
        tf.textColor = R.color.lightBlack()
        return tf
    }()

    private let separatorView = UIView()

    // MARK: - Handlers

    var didChangeText: ((String) -> Void)?
    var didReturnLastTextField: (() -> Void)?

    // MARK: - Private Properties

    private var maxLength: Int = 0
    private var textFieldInputType: TextFieldInputType = .any
    private weak var nextTextField: UITextField?

    // MARK: - Public Properties

    var tf: UITextField {
        return textField
    }

    var text: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }

    // MARK: - Enum

    enum TextFieldInputType {
        case digits, latters, any
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        separatorView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        textField.delegate = self
        addSubview(textField)
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        addSubview(separatorView)

        constrain(textField, separatorView) { textField, separatorView in
            textField.left == textField.superview!.left
            textField.right == textField.superview!.right
            textField.height == 30
            separatorView.top == textField.bottom
            separatorView.left == textField.left
            separatorView.right == textField.right
            separatorView.height == 2
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(placeholder: String, isSecureTextEntry: Bool = false,
                   spellCheck: UITextSpellCheckingType = .default, maxLenght: Int = 0,
                   textFieldInputType: TextFieldInputType = .any,
                   autocapitalization: UITextAutocapitalizationType = .none,
                   keyboardType: UIKeyboardType = .default,
                   nextTextField: UITextField?) {
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        textField.spellCheckingType = spellCheck
        maxLength = maxLenght
        self.textFieldInputType = textFieldInputType
        textField.autocapitalizationType = autocapitalization
        self.nextTextField = nextTextField

        if keyboardType == .numberPad {
            textField.addDoneButtonOnKeyBoardWithControl()
        }
    }

    // MARK: - Private Methods

    @objc private func editingChanged(_ sender: UITextField) {
        didChangeText?(text)
    }
}

extension CustomTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textFieldInputType {
        case .any:
            return true
        case .digits:

            if textField == textField {
                let allowedCharacters = CharacterSet(charactersIn: "0123456789")
                let characterSet = CharacterSet(charactersIn: string)
                guard let text = textField.text as NSString? else { return false }
                let currentString: NSString = text
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length <= maxLength || maxLength == 0 {
                    return allowedCharacters.isSuperset(of: characterSet)
                }
            }

        case .latters:
            if textField == textField {
                let allowedCharacters = CharacterSet.letters
                let characterSet = CharacterSet(charactersIn: string)
                guard let text = textField.text as NSString? else { return false }
                let currentString: NSString = text
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length <= maxLength || maxLength == 0 {
                    return allowedCharacters.isSuperset(of: characterSet)
                }
            }
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = nextTextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            didReturnLastTextField?()
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
