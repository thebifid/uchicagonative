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
            createNavController(viewController: editProfileController, title: "Edit Your Profile",
                                tabbarTitle: "Profile", imageName: ""),

            createNavController(viewController: TermsOfServiceViewController(), title: "Terms Of Service",
                                tabbarTitle: "ToS", imageName: ""),

            createNavController(viewController: gameController, title: "Game",
                                tabbarTitle: "Play", imageName: ""),

            createNavController(viewController: getHelpController, title: "Get Help",
                                tabbarTitle: "Help", imageName: ""),

            createNavController(viewController: AboutUsViewController(), title: "About Us",
                                tabbarTitle: "About", imageName: "")
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 2
    }

    // MARK: - Private Methods

    private func createNavController(viewController: UIViewController, title: String,
                                     tabbarTitle: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = tabbarTitle
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
