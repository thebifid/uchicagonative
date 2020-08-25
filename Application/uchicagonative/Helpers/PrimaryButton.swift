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
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = R.color.mediumAquamarine()!
                self.setTitleColor(.black, for: .normal)
            } else {
                self.backgroundColor = R.color.lightGrayCustom()
                self.setTitleColor(.white, for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 24
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, font: UIFont, isEnabled: Bool = true) {
        setTitle(title, for: .normal)
        titleLabel?.font = font
        self.isEnabled = isEnabled
    }
}
