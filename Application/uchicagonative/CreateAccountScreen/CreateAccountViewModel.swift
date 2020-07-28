//
//  CreateAccountViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class CreateAccountViewModel {
    var email: String?
    var password: String?
    var selectedGroup: String?

    var availableGroups: [String]?

    var isRequesting: Bool = true

    var didFetchedGroups: (() -> Void)?

    init() {
        FireBaseManager.sharedInstance.fetchAvailableGroups { [weak self] result in

            switch result {
            case let .failure(error):
                print(error)
            case let .success(groups):
                self?.availableGroups = groups
                self?.didFetchedGroups?()
                self?.isRequesting = false
                print("groups fetched")
            }
        }
    }
}
