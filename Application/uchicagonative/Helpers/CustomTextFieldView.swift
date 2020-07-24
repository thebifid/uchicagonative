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
    private let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = R.font.karlaRegular(size: Constants.textFieldFontSize)!
        return tf
    }()

    private let separatorView = UIView()

    var didChangeText: ((String) -> Void)?

    var text: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        separatorView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)

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
            separatorView.height == 1
        }
    }

    func configure(placeholder: String, isSecureTextEntry: Bool = false, spellCheck: UITextSpellCheckingType = .default) {
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        textField.spellCheckingType = spellCheck
    }

    @objc private func editingChanged(_ sender: UITextField) {
        didChangeText?(text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
