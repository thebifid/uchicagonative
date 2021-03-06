//
//  UIViewController+Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 31.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return view.safeAreaLayoutGuide.layoutFrame.minY + (navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
}
