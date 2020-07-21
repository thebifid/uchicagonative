//
//  UIButton + Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(titleColor color: UIColor, title: String) {
        self.init(type: .system)
        setTitleColor(color, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: Constants.fontSize)
    }
}
