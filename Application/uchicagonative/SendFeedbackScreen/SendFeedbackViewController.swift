//
//  SendFeedbackViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit
/// Shows send user's Feedback screen
class SendFeedbackViewController: UIViewController {
    let scrollView = UIScrollView()

    let feedbackLabel = UILabel(title: "Please send us feedback about your Mobile Memory App experience", numberOfLines: 0)

    let feedbackTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Leave feedback here"
        return tf
    }()

    let submitButton = UIButton(titleColor: .black, title: "Submit Feedback")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let navBarFrameY = navigationController?.navigationBar.frame.origin.y ?? 0
        let statusBarHeight = navBarHeight + navBarFrameY

        // ScrollView
        scrollView.backgroundColor = R.color.appBackgroundColor()!
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - statusBarHeight)

        view.addSubview(scrollView)

        // StackView

        let stackView = VerticalStackVIew(arrangedSubviews:
            [
                feedbackLabel,
                feedbackTextField,
                submitButton
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
