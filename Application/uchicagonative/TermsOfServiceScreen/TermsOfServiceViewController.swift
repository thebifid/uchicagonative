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
    private let webView = WKWebView()

    let url = Bundle.main.url(forResource: "HTML", withExtension: "html", subdirectory: "Resources/HTML")!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)

//            webView.loadFileURL(url, allowingReadAccessTo: url)
//            let request = URLRequest(url: url)
//            webView.load(request)

        //   webView.loadHTMLString(HTML, baseURL: nil)

        view.addSubview(webView)

        constrain(webView) { webView in
            webView.edges == webView.superview!.edges
        }
    }
}
