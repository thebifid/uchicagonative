//
//  TermsOfServiceViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class TermsOfServiceViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.appBackgroundColor()!

        // WebView on this screen

        let webViewLabel = UILabel(title: "WebView")
        view.addSubview(webViewLabel)

        constrain(webViewLabel) { wv in
            wv.centerX == wv.superview!.centerX
            wv.centerY == wv.superview!.centerY
        }
    }
}
