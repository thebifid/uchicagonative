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

/// Shows 'Terms Of Service' info
class TermsOfServiceViewController: UIViewController {
    // MARK: - Private Properties

    private let webView = WKWebView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHtml()
    }

    // MARK: - UI Actions

    private func setupUI() {
        webView.isOpaque = false
        webView.backgroundColor = R.color.webViewBackgroundColor()!
        view.addSubview(webView)

        constrain(webView) { webView in
            webView.edges == webView.superview!.edges
        }
    }

    // MARK: - Private Methods

    private func loadHtml() {
        if let indexURL = Bundle.main.url(forResource: "tos",
                                          withExtension: "html") {
            webView.loadFileURL(indexURL,
                                allowingReadAccessTo: indexURL)
        }
    }
}
