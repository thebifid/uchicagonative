//
//  User.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 05.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var email: String
    var birthYear: Int
    var gender: String
    var projectId: String
    var zipCode: Int

    init() {
        firstName = ""
        lastName = ""
        email = ""
        birthYear = 0
        gender = ""
        projectId = ""
        zipCode = 0
    }

    init(email: String, projectId: String) {
        firstName = ""
        lastName = ""
        self.email = email
        birthYear = 0
        gender = ""
        self.projectId = projectId
        zipCode = 0
    }

    init(firstName: String, lastName: String, email: String, birthYear: Int, gender: String, projectId: String, zipCode: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthYear = birthYear
        self.gender = gender
        self.projectId = projectId
        self.zipCode = zipCode
    }
}
