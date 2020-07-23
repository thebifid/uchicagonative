//
//  UIElements.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class UIElements {
    func getTFBlock(addTo view: UIView, textField: UITextField, topView: UIView, yOffset: CGFloat) {
        let textFieldView = getView()
        view.addSubview(textFieldView)

        textFieldView.addSubview(textField)
        let separatorView = getSeparator()

        textFieldView.addSubview(separatorView)

        constrain(topView, textFieldView) { topView, textFieldView in
            textFieldView.height == 30
            textFieldView.centerX == textFieldView.superview!.centerX
            textFieldView.width == textFieldView.superview!.width - 2 * Constants.defaultInsets
            textFieldView.top == topView.bottom + yOffset
        }

        constrain(textFieldView, textField, separatorView) { textFieldView, textField, separatorView in
            textField.left == textFieldView.left
            textField.right == textFieldView.right
            textField.height == 30
            separatorView.top == textFieldView.bottom
            separatorView.left == textFieldView.left
            separatorView.right == textFieldView.right
            separatorView.height == 1
        }
    }

    func getRoundedButton(withTitle title: String,
                          fontSize: CGFloat,
                          backGroundColor color: UIColor = R.color.lightGrayCustom()!,
                          isEnabled: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = R.font.karlaBold(size: fontSize)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = color
        button.isEnabled = isEnabled
        return button
    }

    func getView() -> UIView {
        let view = UIView()
        return view
    }

    // generate separatorView
    func getSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }
}
