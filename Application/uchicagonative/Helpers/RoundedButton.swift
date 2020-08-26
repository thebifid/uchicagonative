//
//  RoundedButton.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 26.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let buttonImageView = UIImageView()

    func configure(color: UIColor, image: UIImage, buttonSize size: CGFloat) {
        backgroundColor = color
        layer.cornerRadius = size / 2

        constrain(self) { button in
            button.height == size
            button.width == size
        }

        addSubview(buttonImageView)
        buttonImageView.image = image
        buttonImageView.contentMode = .scaleToFill
        constrain(buttonImageView) { imageView in
            imageView.center == imageView.superview!.center
            imageView.width == 60
            imageView.height == 60
        }
    }
}
