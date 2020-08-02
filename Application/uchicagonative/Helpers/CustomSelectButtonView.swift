//
//  CustomSelectButtonView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 28.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class CustomSelectButtonView: UIView {
    // MARK: - UI Controls

    private let label: UILabel = {
        let label = UILabel()
        label.font = R.font.karlaRegular(size: Constants.textFieldFontSize)!
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(R.color.lightGrayCustom(), for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private let arrowDown: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.arrowDown()
        imageView.alpha = 0.5
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .black
        return ai
    }()

    private let separatorView = UIView()

    // MARK: - Public Properties

    var text: String {
        return button.titleLabel?.text ?? ""
    }

    // MARK: - Hanldeers

    var didTapButton: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        separatorView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)

        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        button.isEnabled = false

        addSubview(separatorView)

        constrain(label, button, separatorView) { label, button, separatorView in
            label.top == label.superview!.top + 20
            label.left == label.superview!.left
            label.right == label.superview!.right

            button.top == label.bottom + 10
            button.centerX == button.superview!.centerX
            button.width == button.superview!.width
            button.height == 30

            separatorView.top == button.bottom
            separatorView.height == 2

            separatorView.left == button.superview!.left
            separatorView.right == button.superview!.right
        }

        button.addSubview(arrowDown)

        constrain(button, arrowDown) { _, arrowDown in
            arrowDown.height == 15
            arrowDown.width == 15

            arrowDown.centerY == arrowDown.superview!.centerY
            arrowDown.right == arrowDown.superview!.right - 10
        }

        button.addSubview(activityIndicator)

        constrain(activityIndicator) { activityIndicator in

            activityIndicator.center == activityIndicator.superview!.center
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(labelTitle: String, buttonTitle: String) {
        label.text = labelTitle
        button.setTitle(buttonTitle, for: .normal)
    }

    func setTitle(title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
    }

    /// Enables/disables activity indicator animation.
    func setAnimation(enabled: Bool) {
        button.isEnabled = !enabled
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    @objc private func handleButtonPressed() {
        didTapButton?()
    }
}
