//
//  Test.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct Test {
    private(set) var cell = Cell(frame: .zero, color: "#ffff", iconName: "square", stimuliSize: 0)

    mutating func setTestCell(cell: Cell) {
        self.cell = cell
    }
}
