//
//  AppDelegate.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let attributes = [NSAttributedString.Key.font: R.font.karlaRegular(size: 26)!]
        UINavigationBar.appearance().titleTextAttributes = attributes

        window = UIWindow()
        window!.rootViewController = RootViewController()
        window!.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}
