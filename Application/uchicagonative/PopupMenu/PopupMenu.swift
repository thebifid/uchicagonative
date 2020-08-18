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
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private var items = [String]()

    private var buttons = [UIButton]()

    // MARK: - Handlers

    var didSelectItem: ((String) -> Void)?

    // MARK: - Public Methods

    /// set seilf items
    func configure(items: [String]) {
        self.items = items
        buttons.forEach { button in
            button.removeFromSuperview()
        }

        backgroundColor = .white

        let selectAnItemButton = makeButton(withTitle: "Select an item...")
        selectAnItemButton.tag = -1
        buttons.append(selectAnItemButton)

        addSubview(selectAnItemButton)
        constrain(selectAnItemButton) { selectAnItemButton in

            selectAnItemButton.top == 5 + selectAnItemButton.superview!.top
            selectAnItemButton.left == selectAnItemButton.superview!.left + 15
        }
        selectAnItemButton.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)

        self.items.enumerated().forEach { index, _ in
            let button = makeButton(withTitle: self.items[index])
            button.tag = index
            buttons.append(button)
            button.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
            self.addSubview(button)

            constrain(button) { button in
                button.top == 45 + button.superview!.top + CGFloat(40 * index)
                button.height == 30
                button.right == button.superview!.right
                button.left == button.superview!.left + 15
            }
        }
    }

    // MARK: - Private Methods

    @objc private func handleButtonPressed(sender: UIButton) {
        guard sender.tag >= 0 else { return }
        didSelectItem?(items[sender.tag])
    }

    private func makeButton(withTitle title: String) -> UIButton {
        let button = UIButton(titleColor: .white, title: title)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = R.font.karlaRegular(size: 18)!
        button.contentHorizontalAlignment = .leading
        return button
    }
}
