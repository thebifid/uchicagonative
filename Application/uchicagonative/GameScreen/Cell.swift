//
//  Cell.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

/// Represents position, size and color of a cell.
struct Cell {
    private(set) var frame: CGRect
    private(set) var color: String
    private(set) var iconName: String
    private(set) var id: Int
    private(set) var stimuliSize: Int

    var location: [Int] {
        return [Int(frame.origin.x), Int(frame.origin.y)]
    }

    init(frame: CGRect, color: String, iconName: String, stimuliSize: Int) {
        self.frame = frame
        self.color = color
        self.iconName = iconName
        self.stimuliSize = stimuliSize
        id = Int.random(in: 12 ... 12345)
    }
}
