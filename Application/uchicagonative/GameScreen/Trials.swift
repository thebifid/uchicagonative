//
//  Trials.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct Trials {
    var id: Int {
        return Int.random(in: 12 ... 12345)
    }

    var results = [RoundResult]()
    var sample = [Sample]()
    var test = [Test]()
}
