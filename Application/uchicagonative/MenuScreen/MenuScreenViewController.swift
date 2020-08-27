//
//  MenuScreenViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

/// Main Menu View Controller
class MenuScreenViewController: UITabBarController {
    private let viewModel: MenuScreenViewModel

    // MARK: - Init

    init(viewModel model: MenuScreenViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Controls

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = viewModel.sessionConfiguration
        let userSession = viewModel.userSession

        let gameViewModel = GameScreenViewModel(userSession: userSession, sessionConfiguration: config)
        let gameController = GameScreenViewController(viewModel: gameViewModel)

        let editProfileViewModel = EditProfileViewModel(userSession: userSession)
        let editProfileController = EditProfileViewController(viewModel: editProfileViewModel)

        let getHelpViewModel = GetHelpViewModel(userSession: userSession)
        let getHelpController = GetHelpViewController(viewModel: getHelpViewModel)

        viewControllers = [
            createNavController(viewController: editProfileController, title: "Profile", imageName: ""),
            createNavController(viewController: TermsOfServiceViewController(), title: "ToS", imageName: ""),
            createNavController(viewController: gameController, title: "Play", imageName: ""),
            createNavController(viewController: getHelpController, title: "Help", imageName: ""),
            createNavController(viewController: AboutUsViewController(), title: "About", imageName: "")
        ]

        selectedIndex = 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.selectedIndex = 1
    }

    // MARK: - Private Methods

    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
