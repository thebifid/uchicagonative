//
//  GameScreenViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 07.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class GameScreenViewController: UIViewController {
    // MARK: - UI Controls

    private let scrollView = UIScrollView()

    private let readyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Ready to play?"
        label.font = R.font.karlaBold(size: 36)!
        label.textColor = .black
        return label
    }()

    let playButton = PrimaryButton()

    // MARK: - Init

    init(viewModel model: GameScreenViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    // MARK: - Lifecycle

    private let viewModel: GameScreenViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSessionConfigurations()
        setupUI()

        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    }

    // MARK: - Private Methods

    @objc private func handlePlay() {
        readyLabel.isHidden = true
        playButton.isHidden = true

        scrollView.backgroundColor = UIColor(hexString: viewModel.backgroundColor)
    }

    private func fetchSessionConfigurations() {
        viewModel.fetchSessionConfigurations { [weak self] result in
            switch result {
            case let .failure(error):
                let alert = AlertAssist.showErrorAlert(error)
                self?.present(alert, animated: true)

            case .success:
                print(self?.viewModel.backgroundColor ?? "")
            }
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.fillSuperView()
        scrollView.backgroundColor = R.color.appBackgroundColor()!

        let stackView = VerticalStackVIew(arrangedSubviews: [readyLabel, playButton], spacing: 20)
        playButton.configure(title: "Start Game!", font: R.font.karlaBold(size: Constants.buttonFontSize)!)

        scrollView.addSubview(stackView)

        constrain(stackView, playButton, readyLabel) { stackView, playButton, _ in
            stackView.centerX == stackView.superview!.centerX
            stackView.centerY == stackView.superview!.centerY - topbarHeight
            stackView.width == stackView.superview!.width - 4 * Constants.defaultInsets

            playButton.width == stackView.width
            playButton.height == 50
        }
    }
}
