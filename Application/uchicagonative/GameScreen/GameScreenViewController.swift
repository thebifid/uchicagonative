//
//  GameScreenViewController.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 07.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import AVFoundation
import Cartography
import os.log
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

    private lazy var notification = NotificationView(to: self)

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

    private lazy var handleEndRound: ((Bool) -> Void) = { _ in
        self.viewModel.roundEnded()
    }

    private var player: AVAudioPlayer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHandlers()
        fetchSessionConfiguration()
        setupUI()
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Private Methods

    private func vibrate() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

    private func playSound(type: NotificationView.TypeNotification) {
        let url: URL!

        switch type {
        case .success:
            url = Bundle.main.url(forResource: R.file.correctMp3.name, withExtension: "mp3")

        case .failure:
            url = Bundle.main.url(forResource: R.file.incorrectMp3.name, withExtension: "mp3")
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            os_log("Failed to play sound. %{public}@", type: .error, error.localizedDescription)
        }
    }

    private func setupHandlers() {
        viewModel.didFetchSessionConfiguration = { [weak self] in
            self?.scrollView.backgroundColor = self?.viewModel.backgroundColor
            self?.playButton.isEnabled = true
        }

        viewModel.didRoundEnd = { [weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.playRound()
        }

        viewModel.showNotificationToUser = { [weak self] in
            guard let self = self else { return }
            let type = self.viewModel.roundResult.accuracy == 0 ? NotificationView.TypeNotification.failure : .success
            let timeToShowNotification = Float(self.viewModel.interTrialInterval) * 0.6
            self.notification.show(type: type, withDelay: Int(timeToShowNotification))

            switch type {
            case .success:
                if self.viewModel.feedbackVibration == .onsuccess || self.viewModel.feedbackVibration == .both {
                    self.vibrate()
                }

                if self.viewModel.feedbackTone == .onsuccess || self.viewModel.feedbackTone == .both {
                    self.playSound(type: .success)
                }

            case .failure:
                if self.viewModel.feedbackVibration == .onfailure || self.viewModel.feedbackVibration == .both {
                    self.vibrate()
                }

                if self.viewModel.feedbackTone == .onfailure || self.viewModel.feedbackTone == .both {
                    self.playSound(type: .failure)
                }
            }
        }

        viewModel.didGameEnd = { [weak self] in
            guard let self = self else { return }
            self.viewModel.sendDataToFirebase { result in
                switch result {
                case let .failure(error):
                    let alert = AlertAssist.showErrorAlert(error)
                    self.present(alert, animated: true)
                case .success:
                    break
                }
            }
            self.showFinalScreen()
            self.view.gestureRecognizers?.forEach { recognizer in
                self.view.removeGestureRecognizer(recognizer)
            }
        }
    }

    private func showFinalScreen() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let finalScreen = FinishScreenView()
        view.addSubview(finalScreen)
        finalScreen.fillSuperView()

        viewModel.fetchUserHistoricalAccuracy { [weak self] in
            guard let self = self else { return }
            finalScreen.configure(withBlockNumber: self.viewModel.blockNumber,
                                  accuracy: self.viewModel.accuracy,
                                  historicalTotal: self.viewModel.historicalAccuracy)
        }

        finalScreen.didReplayButtonTapped = { [weak self] in
            finalScreen.removeFromSuperview()
            self?.readyLabel.isHidden = false
            self?.playButton.isHidden = false
        }

        finalScreen.didEndButtonTapped = { [weak self] in
            finalScreen.removeFromSuperview()
            self?.viewModel.blockNumber = 0
            self?.readyLabel.isHidden = false
            self?.playButton.isHidden = false
        }
    }

    @objc private func handlePlay() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        readyLabel.isHidden = true
        playButton.isHidden = true
        viewModel.startGame()
    }

    private func playRound() {
        let insets = UIEdgeInsets(top: view.safeAreaInsets.top + 20.0, left: 10.0, bottom: view.safeAreaInsets.bottom + 20.0, right: 10.0)
        viewModel.generateCells(viewBounds: view.bounds.inset(by: insets))

        // show icons
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(viewModel.interTrialInterval)) { [weak self] in
            guard let self = self else { return }
            self.layoutCellImageViews()
            self.viewModel.setStartedAt()

            // hide icons
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.viewModel.sampleExposureDuration)) { [weak self] in
                guard let self = self else { return }
                self.cellImageViews.forEach { $0.isHidden = true }

                // show test element
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.viewModel.delayPeriod)) { [weak self] in
                    guard let self = self else { return }
                    self.layoutTestCellImageView()
                    self.viewModel.setTestPresentationTime()
                    self.testCellImageView.isHidden = false
                    self.view.isUserInteractionEnabled = true

                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView))
                    self.view.addGestureRecognizer(panGesture)
                }
            }
        }
    }

    @objc private func draggedView(gesture: UIPanGestureRecognizer) {
        view.bringSubviewToFront(testCellImageView)
        let translation = gesture.translation(in: view)
        testCellImageView.center = CGPoint(x: testCellImageView.center.x + translation.x, y: testCellImageView.center.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        let originalFrame = viewModel.testCell.frame

        if gesture.state == .began {
            viewModel.setStartPoint(startPoint: gesture.location(in: view))
            viewModel.setResponseStartTime()
        }

        if gesture.state == .ended {
            viewModel.setResponseEndTime()
            viewModel.setEndPoint(endPoint: gesture.location(in: view))

            if viewModel.swipeDistanceX > 60 || abs(gesture.velocity(in: testCellImageView).x) > 500 {
                let swipeDirection = gesture.velocity(in: testCellImageView).x < 0 ? GameScreenViewModel.SwipeDirection.left : .right
                var offsetDistance = 400
                if swipeDirection == .left {
                    offsetDistance = -offsetDistance
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.testCellImageView.frame = .init(origin: .init(x: originalFrame.minX + CGFloat(offsetDistance),
                                                                       y: originalFrame.minY),
                                                         size: self.viewModel.testCell.frame.size)
                }, completion: handleEndRound)
                viewModel.setGestureDirection(direction: swipeDirection)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.testCellImageView.frame = .init(origin: originalFrame.origin,
                                                         size: originalFrame.size)
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
        scrollView.addSubview(testCellImageView)
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
