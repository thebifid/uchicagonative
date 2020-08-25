//
//  UITextField+Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 22.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String,
                     borderStyle: BorderStyle = .line, font: UIFont = .systemFont(ofSize: 14), isSecureTextEntry: Bool = false,
                     spellCheck: UITextSpellCheckingType = .default) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .none
        self.font = font
        self.isSecureTextEntry = isSecureTextEntry
        spellCheckingType = spellCheck
    }

    func addDoneButtonOnKeyBoardWithControl() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barStyle = .default
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputAccessoryView = keyboardToolbar
    }
}
