//
//  AboutUsViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit
/// Shows 'About Us' info
class AboutUsViewController: UIViewController {
    let scrollView = UIScrollView()

    let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "This app was developed as part of a research project led by Ed Awh and Ed Vogel at University of Chicago."
        label.numberOfLines = 0
        label.font = R.font.karlaRegular(size: 20)
        label.textColor = .black
        return label
    }()

    let secondLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Our goal is to better understand the limits of attention
        and working memory. Thank you for helping us comlete our research.
        """
        label.numberOfLines = 0
        label.font = R.font.karlaRegular(size: 20)
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        setupUI()
    }

    private func setupUI() {
        // ScrollView
        scrollView.backgroundColor = R.color.appBackgroundColor()!
        scrollView.alwaysBounceVertical = true

        view.addSubview(scrollView)

        // stackView
        let stackView = VerticalStackView(arrangedSubviews:
            [
                firstLabel,
                secondLabel
            ], spacing: 12)

        scrollView.addSubview(stackView)

        // constraints
        constrain(scrollView, stackView) { scrollView, stackView in
            scrollView.top == scrollView.superview!.top
            scrollView.left == scrollView.superview!.left
            scrollView.right == scrollView.superview!.right
            scrollView.bottom == scrollView.superview!.bottom

            stackView.width == scrollView.superview!.width - Constants.defaultInsets
            stackView.centerY == stackView.superview!.centerY - topbarHeight
            stackView.centerX == stackView.superview!.centerX
        }
    }
}
