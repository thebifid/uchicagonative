//
//  PickerViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 02.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class PickerViewModel {
    private(set) var items = [String]()

    func setItems(_ items: [String]) {
        self.items = items
    }
}
