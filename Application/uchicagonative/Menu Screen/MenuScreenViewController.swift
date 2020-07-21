//
//  MenuScreenViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

let playButton = UIButton(titleColor: .green, title: "Play Again!")
let editProfileButton = UIButton(titleColor: .black, title: "Edit Profile")
let termsOfServiceButton = UIButton(titleColor: .black, title: "Terms Of Service")
let getHelpButton = UIButton(titleColor: .black, title: "Get Help")
let sendFeedbackButton = UIButton(titleColor: .black, title: "Send Feedback")
let aboutUsButton = UIButton(titleColor: .black, title: "About Us")
let logoutButton = UIButton(titleColor: .red, title: "Logout")

class MenuScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = Constants.appBackgroundColor

        setupUI()

        // setting button actions
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        aboutUsButton.addTarget(self, action: #selector(handleAboutUs), for: .touchUpInside)
        getHelpButton.addTarget(self, action: #selector(handleGetHelp), for: .touchUpInside)

        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside) // last
    }

    // MARK: - Play action

    @objc private func handlePlay() {
        let dvc = EmptyViewController()
        dvc.navigationItem.title = "Game"
        navigationController?.pushViewController(dvc, animated: true)
    }

    // MARK: - Edit profile action

    @objc private func handleEditProfile() {
        let dvc = EditProfileViewController()
        dvc.navigationItem.title = "Edit Profile"
        navigationController?.pushViewController(dvc, animated: true)
    }

    // MARK: - About us action

    @objc private func handleAboutUs() {
        let dvc = AboutUsViewController()
        dvc.navigationItem.title = "About Us"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleGetHelp() {
        let dvc = GetHelpViewController()
        dvc.navigationItem.title = "Get Help"
        navigationController?.pushViewController(dvc, animated: true)
    }

    // MARK: - Logout action

    @objc private func handleLogout() {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        let stackView = VerticalStackVIew(arrangedSubviews:
            [playButton,
             editProfileButton,
             termsOfServiceButton,
             getHelpButton,
             sendFeedbackButton,
             aboutUsButton,
             logoutButton], spacing: 12)

        view.addSubview(stackView)

        constrain(stackView) { stackView in
            stackView.centerY == stackView.superview!.centerY
            stackView.centerX == stackView.superview!.centerX
        }
    }
}
