//
//  PopupMenu.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 28.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class PopupMenu: UIView {
    var items: [String] = ["Select an item..."]
    var didSelectItem: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        backgroundColor = .white
    }

    func configure(items: [String]) {
        self.items += items
        backgroundColor = .white
        self.items.enumerated().forEach { index, _ in
            let button = makeButton(withTitle: self.items[index])
            button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
            self.addSubview(button)

            constrain(button) { button in
                button.top == 5 + button.superview!.top + CGFloat(30 * index)
                button.height == 30
                button.right == button.superview!.right
                button.left == button.superview!.left + 15
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleButtonPressed(sender: UIButton) {
        guard let item = sender.titleLabel?.text else { return }
        didSelectItem?(item)
    }

    private func makeButton(withTitle title: String) -> UIButton {
        let button = UIButton(titleColor: .white, title: title)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = R.font.karlaRegular(size: 18)!
        button.contentHorizontalAlignment = .leading
        return button
    }
}
