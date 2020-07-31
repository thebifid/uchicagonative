//
//  Dictionary+Extension.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 31.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

extension Dictionary where Value: Hashable {
    func swapKeyValues() -> [Value: Key] {
        assert(Set(values).count == keys.count, "Values must be unique")
        var newDict = [Value: Key]()
        for (key, value) in self {
            newDict[value] = key
        }
        return newDict
    }
}
