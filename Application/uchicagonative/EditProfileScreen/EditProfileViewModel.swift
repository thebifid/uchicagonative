//
//  EditProfileViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 31.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class EditProfileViewModel {
    // MARK: - Init

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Private Properties

    private(set) var userSession: UserSession

    private(set) var email: String = ""
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var birthYear: Int = 0
    private(set) var zipCode: Int = 0
    private(set) var gender: String = ""
    private(set) var project: String = ""
    private(set) var role: String = ""

    private var availableGroupNameById = [String: String]()
    private var availableGroupIdByName = [String: String]()

    private let adminRole: String = "admin"

    private var userInfo = [String: Any]()

    // MARK: - Public Properties

    /// Return true if User if Admin
    var isAdmin: Bool {
        return role == adminRole
    }

    /// Returns names of groups
    var groups: [String] {
        return Array(availableGroupNameById.values)
    }

    var genderList: [String] {
        return ["Select an item...", "Female", "Male", "Non-binary", "TransMale", "TransFemale", "Something Else", "No Answer"]
    }

    /// Request status
    var isRequesting: Bool = false {
        didSet {
            didUpdateState?()
        }
    }

    var saveButtonState: SaveButtonState {
        if isRequesting {
            return .animating
        } else {
            return .enabled(isAllFieldsAreFill())
        }
    }

    // MARK: - Handlers

    /// Calls when get updated
    var didUpdateState: (() -> Void)?

    // MARK: - Enums

    enum SaveButtonState {
        case animating, enabled(Bool)
    }

    // MARK: - Private Methods

    /// Fetches availables user groups
    private func fetchAvailableGroups(completion: @escaping ((Result<[String: String], Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchAvailableGroups { [weak self] result in

            switch result {
            case let .success(groups):
                self?.availableGroupIdByName = groups
                self?.availableGroupNameById = groups.swapKeyValues()
                completion(.success(groups))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func isAllFieldsAreFill() -> Bool {
        let isFilled = !firstName.isEmpty && !lastName.isEmpty && birthYear != 0 &&
            zipCode != 0 && !gender.isEmpty && gender != genderList[0]

        let isFullyFilled = isFilled && String(birthYear).count == 4 && String(zipCode).count == 5

        return isFullyFilled
    }

    // MARK: Public Methods

    /// Fetches user information like firt name, last name and etc
    func fetchUserInfo(completion: @escaping ((Result<Void, Error>) -> Void)) {
        fetchAvailableGroups { result in

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case .success:
                FirebaseManager.sharedInstance.fetchUserInfo { [weak self] result in

                    switch result {
                    case let .failure(error):
                        completion(.failure(error))

                    case var .success(userInfo):
                        userInfo["projectId"] = self?.availableGroupNameById[userInfo["projectId"] as? String ?? ""]
                        self?.userInfo = userInfo

                        self?.email = userInfo["email"] as? String ?? ""
                        self?.role = userInfo["role"] as? String ?? ""
                        self?.project = userInfo["projectId"] as? String ?? ""
                        self?.firstName = userInfo["firstName"] as? String ?? ""
                        self?.lastName = userInfo["lastName"] as? String ?? ""
                        self?.birthYear = userInfo["birthYear"] as? Int ?? 0
                        self?.zipCode = userInfo["zipCode"] as? Int ?? 0
                        self?.gender = userInfo["gender"] as? String ?? ""

                        completion(.success(()))
                    }
                }
            }
        }
    }

    /// Save User Information in Firebase
    func sendUserInfo(competion: @escaping ((Result<Void, Error>) -> Void)) {
        isRequesting = true
        userInfo["firstName"] = firstName
        userInfo["lastName"] = lastName
        userInfo["gender"] = gender
        userInfo["birthYear"] = birthYear
        userInfo["zipCode"] = zipCode

        userInfo["projectId"] = availableGroupIdByName[project]

        FirebaseManager.sharedInstance.updateUserInfo(attributes: userInfo) { [weak self] result in

            switch result {
            case let .failure(error):
                competion(.failure(error))

            case .success:

                let user = User(firstName: self?.firstName ?? "",
                                lastName: self?.lastName ?? "",
                                email: self?.email ?? "",
                                birthYear: self?.birthYear ?? 0,
                                gender: self?.gender ?? "",
                                projectId: self?.project ?? "",
                                zipCode: self?.zipCode ?? 0)
                self?.userSession.setNewUserInfo(newUserInfo: user)

                competion(.success(()))
            }
            self?.isRequesting = false
        }
    }

    /// Set itself properties
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
