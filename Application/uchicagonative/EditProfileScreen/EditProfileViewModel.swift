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

    // MARK: - Handlers

    var didUpdateState: (() -> Void)?

    // MARK: Public Methods

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
