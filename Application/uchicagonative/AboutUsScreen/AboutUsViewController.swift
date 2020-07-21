//
//  AboutUsViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class AboutUsViewController: UIViewController {
    let scrollView = UIScrollView()

    let firstLabel = UILabel(title:
        "This app was developed as part of a research project led by Ed Awh and Ed Vogel at University of Chicago", numberOfLines: 0)

    let secondLabel = UILabel(title:
        "Our goal is to better understand the limits of attention and working memory. Thank you for helping us comlete our research",
                              numberOfLines: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

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

        // stackView
        let stackView = VerticalStackVIew(arrangedSubviews:
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
            stackView.centerY == stackView.superview!.centerY
            stackView.centerX == stackView.superview!.centerX
        }
    }
}
