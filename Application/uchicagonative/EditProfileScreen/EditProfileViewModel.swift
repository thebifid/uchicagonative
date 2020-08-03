//
//  EditProfileViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 31.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class EditProfileViewModel {
    // MARK: - Private Properties

    private var firstName: String = ""
    private var lastName: String = ""
    private var birthYear: Int = 0 // ?
    private var zipCode: Int = 0 // ?
    private var gender: String = ""
    private var project: String = ""
    private var role: String = ""

    private var availableGroups = [String: String]()
    private var userInfo = [String: Any]()

    // MARK: - Public Properties

    var groups: [String] {
        return Array(availableGroups.values)
    }

    var genderList: [String] {
        return ["Select an item...", "Female", "Male", "Non-binary", "TransMale", "TransFemale", "Something Else", "No Answer"]
    }

    // MARK: - Handlers

    var didUpdateState: (() -> Void)?

    var didFetchedUserInfo: (() -> Void)?

    // MARK: - Private Methods

    // MARK: Public Methods

    /// Fetches user information like firt name, last name and etc
    func fetchUserInfo(completion: @escaping ((Result<[String: Any], Error>) -> Void)) {
        fetchAvailableGroups { result in

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case .success:
                FirebaseManager.sharedInstance.fetchUserInfo { result in

                    switch result {
                    case let .failure(error):
                        completion(.failure(error))

                    case var .success(userInfo):
                        userInfo["projectId"] = self.availableGroups[userInfo["projectId"] as? String ?? ""]
                        self.userInfo = userInfo

                        self.project = userInfo["projectId"] as? String ?? ""
                        self.firstName = userInfo["firstName"] as? String ?? ""
                        self.lastName = userInfo["lastName"] as? String ?? ""
                        self.birthYear = userInfo["birthYear"] as? Int ?? 0
                        self.zipCode = userInfo["zipCode"] as? Int ?? 0
                        self.gender = userInfo["gender"] as? String ?? ""

                        completion(.success(self.userInfo))
                    }
                }
            }
        }
    }

    /// Fetches availables user groups
    func fetchAvailableGroups(completion: @escaping ((Result<[String: String], Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchAvailableGroups { result in

            switch result {
            case let .success(groups):
                self.availableGroups = groups.swapKeyValues()
                completion(.success(groups))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func sendUserInfo(competion: @escaping ((Result<Void, Error>) -> Void)) {
        userInfo["firstName"] = firstName
        userInfo["lastName"] = lastName
        userInfo["gender"] = gender
        userInfo["birthYear"] = birthYear
        userInfo["zipCode"] = zipCode

        let groups = availableGroups.swapKeyValues()
        userInfo["projectId"] = groups[project]

        FirebaseManager.sharedInstance.updateUserInfo(attributes: userInfo) { result in

            switch result {
            case let .failure(error):
                competion(.failure(error))

            case .success:
                competion(.success(()))
            }
        }
    }

    func setFirstName(_ firstName: String) {
        self.firstName = firstName
        didUpdateState?()
    }

    func setLastName(_ lastName: String) {
        self.lastName = lastName
        didUpdateState?()
    }

    func setBirthYear(_ birthYear: Int) {
        self.birthYear = birthYear
        didUpdateState?()
    }

    func setZipCode(_ zipCode: Int) {
        self.zipCode = zipCode
        didUpdateState?()
    }

    func setGender(_ gender: String) {
        self.gender = gender
        didUpdateState?()
    }

    func setProject(_ project: String) {
        self.project = project
        didUpdateState?()
    }
}
