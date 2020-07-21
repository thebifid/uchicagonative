//
//  EditProfileViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 21.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class EditProfileViewController: UIViewController, UIScrollViewDelegate {
    let scrollView = UIScrollView()

    let emailLabel = UILabel(title: "Email: example@mail.ru")
    let firstNameLabel = UILabel(title: "Firstname")
    let secondNameLabel = UILabel(title: "Secondname")
    let birhdayYearLabel = UILabel(title: "1990")
    let numberLabel = UILabel(title: "90005")
    let selectGenderLabel = UILabel(title: "Select Your Gender")

    let pickGenderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Male", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        return button
    }()

    let selectProjectLabel = UILabel(title: "Select Project")

    let pickProjectButton: UIButton = {
        let button = UIButton()
        button.setTitle("uchicago_student_group", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        scrollView.delegate = self
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let navBarFrameY = navigationController?.navigationBar.frame.origin.y ?? 0
        let statusBarHeight = navBarHeight + navBarFrameY

        // ScrollView
        scrollView.backgroundColor = Constants.appBackgroundColor
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - statusBarHeight)

        view.addSubview(scrollView)

        // StackView

        let stackView = VerticalStackVIew(arrangedSubviews:
            [
                emailLabel,
                firstNameLabel,
                secondNameLabel,
                birhdayYearLabel,
                numberLabel,
                selectGenderLabel,
                pickGenderButton,
                selectProjectLabel,
                pickProjectButton
            ], spacing: 12)

        scrollView.addSubview(stackView)

        constrain(scrollView, stackView) { scrollView, stackView in

            // scrollView
            scrollView.top == scrollView.superview!.top
            scrollView.left == scrollView.superview!.left
            scrollView.right == scrollView.superview!.right
            scrollView.bottom == scrollView.superview!.bottom

            // stackView
            stackView.top == stackView.superview!.top + Constants.defaultInsets
            stackView.left == stackView.superview!.left + Constants.defaultInsets
        }
    }
}
