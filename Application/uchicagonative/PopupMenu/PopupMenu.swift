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
    var selectedItem: String?
    var items = [String]()
    var didSelectItem: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }

    func configure(items: [String]) {
        self.items = items
        items.enumerated().forEach { index, _ in
            let button = makeButton(withTitle: items[index])
            self.addSubview(button)

            constrain(button) { button in
                button.top == button.superview!.top + CGFloat(30 * index)
                button.height == 30
                button.right == button.superview!.right
                button.left == button.superview!.left
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeButton(withTitle title: String) -> UIButton {
        let button = UIButton(titleColor: .white, title: title)
        return button
    }
}
