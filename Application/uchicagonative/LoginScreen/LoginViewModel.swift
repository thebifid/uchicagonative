//
//  LoginViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 24.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class LoginViewModel {
    private var email: String?
    private var password: String?
    
    var didUpdateState: (() -> Void)?

    func setEmail(_ email: String) {}

    func setPassword(_ password: String) {}

    func isLoginButtonEnabled() -> Bool {
        return false
    }

    func login(completion: @escaping (Result<Any, Error>) -> Void) {
    }

    
    
    
}
