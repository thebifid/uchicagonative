//
//  PrimaryButton.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 24.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 24
        backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, font: UIFont, backgroundColor color: UIColor = .green, isEnabled: Bool = true) {
        setTitle(title, for: .normal)
        titleLabel?.font = font
        backgroundColor = color
        self.isEnabled = isEnabled
    }
}

// width
// buttonsView.superview!.width - 4 * Constants.defaultInsets

// func getRoundedButton(withTitle title: String,
//                      fontSize: CGFloat,
//                      backGroundColor color: UIColor = R.color.lightGrayCustom()!,
//                      isEnabled: Bool = true) -> UIButton {
//    let button = UIButton(type: .system)
//    button.setTitle(title, for: .normal)
//    button.titleLabel?.font = R.font.karlaBold(size: fontSize)
//    button.setTitleColor(.white, for: .normal)
//    button.layer.cornerRadius = 24
//    button.backgroundColor = color
//    button.isEnabled = isEnabled
//    return button
// }
