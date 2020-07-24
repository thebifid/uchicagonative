//
//  UIView+ExtensionLayout.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

extension UIView {
    func fillsuperView() {
        constrain(self) { view in
            view.edges == view.superview!.edges
        }
    }
}
