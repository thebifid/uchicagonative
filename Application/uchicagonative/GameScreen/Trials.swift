//
//  Trials.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct Trials {
    private var id: Int {
        return Int.random(in: 12 ... 12345)
    }

    private(set) var results = [RoundResult]()
    private var sample = [Sample]()
    private var test = [Test]()

    mutating func addResult(result: RoundResult) {
        results.append(result)
    }

    mutating func addSample(sample: Sample) {
        self.sample.append(sample)
    }

    mutating func addTest(test: Test) {
        self.test.append(test)
    }
}
