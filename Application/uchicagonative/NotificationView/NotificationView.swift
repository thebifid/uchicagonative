//
//  NotificationView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class NotificationView: UIViewController {
    // MARK: - UI Controls

    private let notificationRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    private var delayTime: Int = 1000

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(notificationRectangle)
        notificationRectangle.layer.cornerRadius = 8

        constrain(notificationRectangle) { notificationRectangle in

            notificationRectangle.height == 50
            notificationRectangle.width == notificationRectangle.superview!.width - 20

            notificationRectangle.top == notificationRectangle.superview!.top + 20
            notificationRectangle.centerX == notificationRectangle.superview!.centerX
        }
    }

    // MARK: - Enums

    enum TypeNotification {
        case success, failure
    }

    // MARK: - Public Methods

    func show(type: TypeNotification, withDelay delay: Int = 1000) {
        delayTime = delay
        configureNotification(type: type)

        guard let viewController = viewController else { return }
        viewController.addChild(self)
        viewController.view.addSubview(view)
        view.frame = .init(x: 0, y: viewController.view.frame.height, width: viewController.view.frame.width, height: 150)

        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = .init(x: 0, y: viewController.view.frame.height - 150, width: viewController.view.frame.width, height: 150)
        }, completion: hideAction)
    }

    // MARK: - Private Methods

    private func configureNotification(type: TypeNotification) {
        switch type {
        case .success:
            notificationRectangle.backgroundColor = .green

        case .failure:
            notificationRectangle.backgroundColor = R.color.lightRed()
        }
    }

    private lazy var hideAction: ((Bool) -> Void) = { _ in

        guard let viewController = self.viewController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.delayTime)) {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = .init(x: 0, y: viewController.view.frame.height, width: viewController.view.frame.width, height: 150)
            }, completion: self.removeHandler)
        }
    }

    private lazy var removeHandler: ((Bool) -> Void) = { _ in
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    // MARK: - Init

    init(to viewController: UIViewController) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
