//
//  GetHelpViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class GetHelpViewController: UIViewController {
    let firstBlockLabel = UILabel(title: "Thank you for using our app. If you have an issue to report, please contact us via email",
                                  numberOfLines: 0)

    let sendEmailButton = UIButton(titleColor: .black, title: "Send Email")
    let secondBlcokLabel = UILabel(title: "Read more about our research on our website at AwhVogelLab.com", numberOfLines: 0)

    let visitWebsiteButton = UIButton(titleColor: .black, title: "Visit Website")
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let navBarFrameY = navigationController?.navigationBar.frame.origin.y ?? 0
        let statusBarHeight = navBarHeight + navBarFrameY

        // ScrollView
        scrollView.backgroundColor = Constants.appBackgroundColor
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - statusBarHeight)

        view.addSubview(scrollView)

        // StackView

        let stackView = VerticalStackVIew(arrangedSubviews:
            [
                firstBlockLabel,
                sendEmailButton,
                secondBlcokLabel,
                visitWebsiteButton
            ], spacing: 12)

        scrollView.addSubview(stackView)

        // constraints
        constrain(scrollView, stackView) { scrollView, stackView in
            scrollView.top == scrollView.superview!.top
            scrollView.left == scrollView.superview!.left
            scrollView.right == scrollView.superview!.right
            scrollView.bottom == scrollView.superview!.bottom

            stackView.width == scrollView.superview!.width - Constants.defaultInsets
            stackView.centerY == stackView.superview!.centerY
            stackView.centerX == stackView.superview!.centerX
        }
    }
}
