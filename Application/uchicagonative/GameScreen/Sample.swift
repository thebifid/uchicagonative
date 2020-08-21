//
//  Sample.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct Sample {
    private(set) var cells = [Cell]()

    mutating func setSampleCells(cells: [Cell]) {
        self.cells = cells
    }
}
