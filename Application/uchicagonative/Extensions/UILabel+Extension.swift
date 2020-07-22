//
//  UILabel + Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(title: String, numberOfLines: Int = 1, font: UIFont = .systemFont(ofSize: 14), color: UIColor = .black) {
        self.init()
        text = title
        self.numberOfLines = numberOfLines
        self.font = font
        textColor = color
    }
}
