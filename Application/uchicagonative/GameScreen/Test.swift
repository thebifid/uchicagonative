//
//  Test.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct Test {
    private(set) var cell: Cell

    mutating func setTestCell(cell: Cell) {
        self.cell = cell
    }
}
