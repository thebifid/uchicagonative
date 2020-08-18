//
//  MenuScreenViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import FirebaseAuth
import UIKit

/// Main Menu View Controller
class MenuScreenViewController: UIViewController {
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

    private let scrollView = UIScrollView()

    private let playButton = UIButton(titleColor: .lightGray, title: "Play Again!")
    private let editProfileButton = UIButton(titleColor: .black, title: "Edit Profile")
    private let termsOfServiceButton = UIButton(titleColor: .black, title: "Terms Of Service")
    private let getHelpButton = UIButton(titleColor: .black, title: "Get Help")
    private let sendFeedbackButton = UIButton(titleColor: .black, title: "Send Feedback")
    private let aboutUsButton = UIButton(titleColor: .black, title: "About Us")
    private let logoutButton = UIButton(titleColor: .red, title: "Logout")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = R.color.appBackgroundColor()!
        playButton.setTitleColor(.green, for: .normal)
        playButton.isEnabled = true

        setupUI()

        // setting button actions
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        termsOfServiceButton.addTarget(self, action: #selector(handleTermsOfService), for: .touchUpInside)
        getHelpButton.addTarget(self, action: #selector(handleGetHelp), for: .touchUpInside)
        aboutUsButton.addTarget(self, action: #selector(handleAboutUs), for: .touchUpInside)
        sendFeedbackButton.addTarget(self, action: #selector(handleSendFeedback), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Private Methods

    @objc private func handlePlay() {
        let dvc = GameScreenViewController(viewModel: GameScreenViewModel(userSession: viewModel.userSession,
                                                                          sessionConfiguration: viewModel.sessionConfiguration))
        dvc.navigationItem.title = "Game"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleEditProfile() {
        let dvc = EditProfileViewController(viewModel: EditProfileViewModel(userSession: viewModel.userSession))
        dvc.navigationItem.title = "Edit Your Profile"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleAboutUs() {
        let dvc = AboutUsViewController()
        dvc.navigationItem.title = "About Us"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleGetHelp() {
        let dvc = GetHelpViewController(viewModel: GetHelpViewModel(userSession: viewModel.userSession))
        dvc.navigationItem.title = "Get Help"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleTermsOfService() {
        let dvc = TermsOfServiceViewController()
        dvc.navigationItem.title = "Terms Of Service"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleSendFeedback() {
        let dvc = SendFeedbackViewController()
        dvc.navigationItem.title = "Send Feedback"
        navigationController?.pushViewController(dvc, animated: true)
    }

    @objc private func handleLogout() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            AppDelegate.shared.rootViewController.switchToLogout()
        } catch let logOutError {
            let alert = AlertAssist.showErrorAlert(logOutError)
            present(alert, animated: true)
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperView()

        let stackView = VerticalStackView(arrangedSubviews:
            [
                playButton,
                editProfileButton,
                termsOfServiceButton,
                getHelpButton,
                sendFeedbackButton,
                aboutUsButton,
                logoutButton
            ], spacing: 12)

        scrollView.addSubview(stackView)

        constrain(stackView) { stackView in
            stackView.centerY == stackView.superview!.centerY - self.topbarHeight
            stackView.centerX == stackView.superview!.centerX
        }
    }
}
