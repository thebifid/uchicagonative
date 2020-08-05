//
//  GetHelpViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import MessageUI
import UIKit

/// Shows 'Get Help' info
class GetHelpViewController: UIViewController {
    // MARK: - Init

    init(viewModel model: GetHelpViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Controls

    let scrollView = UIScrollView()

    private let contactEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for using our app. If you have an issue to report, please contact us via email"
        label.font = R.font.karlaRegular(size: Constants.buttonFontSize)!
        label.textColor = R.color.lightBlack()!
        label.numberOfLines = 0
        return label
    }()

    let sendEmailButton = PrimaryButton()

    private let readAboutLabel: UILabel = {
        let label = UILabel()
        label.text = "Read more about our research on our website at AwhVogelLab.com"
        label.font = R.font.karlaRegular(size: Constants.buttonFontSize)!
        label.textColor = R.color.lightBlack()!
        label.numberOfLines = 0
        return label
    }()

    private let visitSiteButton = PrimaryButton()

    // MARK: - Private Properties

    private let viewModel: GetHelpViewModel

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(viewModel.userSession.user)
        sendEmailButton.addTarget(self, action: #selector(handleSendEmail), for: .touchUpInside)
        visitSiteButton.addTarget(self, action: #selector(handleVisitWebsite), for: .touchUpInside)
    }

    // MARK: - Private Methods

    @objc private func handleSendEmail() {
        showMailCompose()
    }

    @objc private func handleVisitWebsite() {
        UIApplication.shared.open(viewModel.websiteUrl)
    }

    private func showMailCompose() {
        guard viewModel.isEmailFetched else {
            let alert = AlertAssist.showCustomAlert("Error!", message: "Can't get your email. Please, try again.", optionHadler: nil)
            present(alert, animated: true)
            return
        }

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([viewModel.emailRecipient])
            mail.setSubject(viewModel.emailSubject)
            mail.setMessageBody("Sender: \(viewModel.userSession.user.email)", isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = AlertAssist.showCustomAlert("Could Not Send Email", message:
                "Your device couldn't send email. Please check email configuration and try again.",
                                                    optionHadler: nil)
            present(alert, animated: true)
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        scrollView.backgroundColor = R.color.appBackgroundColor()
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        scrollView.alwaysBounceVertical = true

        sendEmailButton.configure(title: "Send Email",
                                  font: R.font.karlaBold(size: 18)!, isEnabled: true)

        visitSiteButton.configure(title: "Visit Website",
                                  font: R.font.karlaBold(size: 18)!, isEnabled: true)

        let upStackView = VerticalStackVIew(arrangedSubviews: [contactEmailLabel, sendEmailButton], spacing: 20)
        let downStackView = VerticalStackVIew(arrangedSubviews: [readAboutLabel, visitSiteButton], spacing: 20)

        let stackView = VerticalStackVIew(arrangedSubviews: [upStackView, downStackView], spacing: 35)

        constrain(sendEmailButton, visitSiteButton) { sendEmailButton, visitSiteButton in

            sendEmailButton.height == 50
            visitSiteButton.height == 50
        }

        scrollView.addSubview(stackView)

        constrain(stackView) { stackView in
            stackView.centerX == stackView.superview!.centerX
            stackView.centerY == stackView.superview!.centerY - topbarHeight

            stackView.left == stackView.superview!.left + 2 * Constants.defaultInsets
            stackView.right == stackView.superview!.right - 2 * Constants.defaultInsets
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate Method

extension GetHelpViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            let alert = AlertAssist.showErrorAlert(error)
            present(alert, animated: true)
            return

        } else {
            controller.dismiss(animated: true)
        }
    }
}
