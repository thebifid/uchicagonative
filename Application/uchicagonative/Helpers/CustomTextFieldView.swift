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

// func getTFBlock(addTo view: UIView, textField: UITextField, topView: UIView, yOffset: CGFloat) {
//       let textFieldView = getView()
//       view.addSubview(textFieldView)
//
//       textFieldView.addSubview(textField)
//       let separatorView = getSeparator()
//
//       textFieldView.addSubview(separatorView)
//
//       constrain(topView, textFieldView) { topView, textFieldView in
//           textFieldView.height == 30
//           textFieldView.centerX == textFieldView.superview!.centerX
//           textFieldView.width == textFieldView.superview!.width - 2 * Constants.defaultInsets
//           textFieldView.top == topView.bottom + yOffset
//       }
//
//       constrain(textFieldView, textField, separatorView) { textFieldView, textField, separatorView in
//           textField.left == textFieldView.left
//           textField.right == textFieldView.right
//           textField.height == 30
//           separatorView.top == textFieldView.bottom
//           separatorView.left == textFieldView.left
//           separatorView.right == textFieldView.right
//           separatorView.height == 1
//       }
//   }
//
//   func getView() -> UIView {
//       let view = UIView()
//       return view
//   }
//
//   // generate separatorView
//   func getSeparator() -> UIView {
//       let view = UIView()
//       view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
//       return view
//   }
