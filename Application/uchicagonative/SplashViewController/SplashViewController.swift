//
//  SplashViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        makeServiceCall()
    }

    private func makeServiceCall() {
        DispatchQueue.main.async {
            if FirebaseAuth.Auth.auth().currentUser != nil {
                FirebaseManager.sharedInstance.fetchUser { user in
                    // navigate to protected page
                    AppDelegate.shared.rootViewController.switchToMainScreen(user: user)
                }

            } else {
                // navigate to login screen
                AppDelegate.shared.rootViewController.switchToLogout()
            }
        }
    }
}
