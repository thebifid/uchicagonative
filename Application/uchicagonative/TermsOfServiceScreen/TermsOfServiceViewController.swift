//
//  TermsOfServiceViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit
import WebKit

/// This View Controller shows 'Terms Of Service' info
class TermsOfServiceViewController: UIViewController {
    // MARK: - Private Properties

    private let webView = WKWebView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.isOpaque = false
        webView.backgroundColor = R.color.lightGrayCustom()

        if let indexURL = Bundle.main.url(forResource: "HTML",
                                          withExtension: "html") {
            webView.loadFileURL(indexURL,
                                allowingReadAccessTo: indexURL)
        }

        view.addSubview(webView)

        constrain(webView) { webView in
            webView.edges == webView.superview!.edges
        }
    }
}
