//
//  CGRect+Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension CGRect {
    /// Returns true if intersects at least one rect.
    func intersectsAny(_ rects: [CGRect]) -> Bool {
        for rect in rects {
            if intersects(rect) {
                return true
            }
        }
        return false
    }
}
