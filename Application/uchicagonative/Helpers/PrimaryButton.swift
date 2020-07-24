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
