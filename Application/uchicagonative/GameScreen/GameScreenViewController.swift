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

    private let playButton = PrimaryButton()

    private var cellImageViews: [SvgImageView] = []
    private var testCellImageView = SvgImageView(frame: .zero)

    // MARK: - Init

    init(viewModel model: GameScreenViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let viewModel: GameScreenViewModel

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHandlers()
        fetchSessionConfiguration()

        setupUI()
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    }

    // MARK: - Private Methods

    private func setupHandlers() {
        viewModel.didFetchSessionConfiguration = { [weak self] in
            self?.scrollView.backgroundColor = self?.viewModel.backgroundColor
            self?.playButton.isEnabled = true
        }
    }

    @objc private func handlePlay() {
        readyLabel.isHidden = true
        playButton.isHidden = true

        // will be loop for trials
        playRound()
    }

    private func playRound() {
        let insets = UIEdgeInsets(top: view.safeAreaInsets.top + 20.0, left: 10.0, bottom: view.safeAreaInsets.bottom + 20.0, right: 10.0)
        viewModel.generateCells(viewBounds: view.bounds.inset(by: insets))

        // show icons
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(viewModel.interTrialInterval)) {
            self.layoutCellImageViews()

            // hide icons
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.viewModel.sampleExposureDuration)) {
                self.cellImageViews.forEach { $0.isHidden = true }

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.viewModel.delayPeriod)) {
                    self.layoutTestCellImageView()
                    self.testCellImageView.isHidden = false
                }
            }
        }
    }

    private func layoutTestCellImageView() {
        testCellImageView.configure(svgImageName: viewModel.svgImageName, colorHex: viewModel.testCell.color)
        testCellImageView.frame = viewModel.testCell.frame
        testCellImageView.isHidden = true
    }

    private func layoutCellImageViews() {
        cellImageViews.forEach { $0.isHidden = true }
        for (i, cell) in viewModel.cells.enumerated() {
            // Reuse or create new image views.
            let view: SvgImageView
            if i >= cellImageViews.count {
                view = SvgImageView(frame: .zero)
                scrollView.addSubview(view)
                cellImageViews.append(view)
            } else {
                view = cellImageViews[i]
                view.isHidden = false
            }
            view.frame = cell.frame
            view.configure(svgImageName: viewModel.svgImageName, colorHex: cell.color)
        }
    }

    private func fetchSessionConfiguration() {
        viewModel.fetchSessionConfigurations { [weak self] result in
            switch result {
            case let .failure(error):
                let alert = AlertAssist.showErrorAlertWithCancelAndOption(error, optionName: "Try Again") { _ in
                    self?.fetchSessionConfiguration()
                }
                self?.present(alert, animated: true)
            case .success:
                break
            }
        }
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(testCellImageView) // !!!
        scrollView.fillSuperView()
        scrollView.backgroundColor = R.color.appBackgroundColor()

        let stackView = VerticalStackView(arrangedSubviews: [readyLabel, playButton], spacing: 20)
        playButton.configure(title: "Start Game!", font: R.font.karlaBold(size: Constants.buttonFontSize)!, isEnabled: false)

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
