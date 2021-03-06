//
//  FinalView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 26.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class FinishScreenView: UIView {
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        leftActivityIndicator.startAnimating()
        rightActivityIndicator.startAnimating()

        replayButton.addTarget(self, action: #selector(handleReplayButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(handleEndButtonTapped), for: .touchUpInside)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Controls

    private let logo = UIImageView(image: R.image.mainIcon()!)
    private let blockCompleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Block - Complete!"
        label.font = R.font.helveticaNeueCyrMedium(size: 40)!
        label.textColor = R.color.lightBlack()!
        return label
    }()

    private let statisticsView = UIView()

    private let accuracyLabel: UILabel = {
        let label = UILabel()
        label.text = "Accuracy"
        label.textColor = R.color.pink()!
        label.font = R.font.helveticaNeueCyrMedium(size: 22)!
        return label
    }()

    private let historicalAcuracyLabel: UILabel = {
        let label = UILabel()
        label.text = "Historical Total"
        label.textColor = R.color.pink()!
        label.font = R.font.helveticaNeueCyrMedium(size: 22)!
        return label
    }()

    private let accuracyPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.font.helveticaNeueCyrMedium(size: 20)!
        return label
    }()

    private let historicalAccuracyPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.font.helveticaNeueCyrMedium(size: 20)!
        return label
    }()

    private let buttonsView = UIView()
    private let replayButton = RoundedButton()
    private let endButton = RoundedButton()

    private let replayLabel: UILabel = {
        let label = UILabel()
        label.text = "PLAY AGAIN"
        label.font = R.font.helveticaNeueCyrMedium(size: 14)!
        label.textColor = R.color.pink()!
        return label
    }()

    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "END"
        label.font = R.font.helveticaNeueCyrMedium(size: 14)!
        label.textColor = R.color.pink()!
        return label
    }()

    private let leftActivityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .white
        ai.color = .black
        return ai
    }()

    private let rightActivityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .white
        ai.color = .black
        return ai
    }()

    private let separatorView = UIView()

    // MARK: - Handlers

    var didReplayButtonTapped: (() -> Void)?
    var didEndButtonTapped: (() -> Void)?

    // MARK: - Public Methods

    func configure(withBlockNumber number: Int, accuracy: [Int], historicalTotal historicalAccuracy: [Int]) {
        blockCompleteLabel.text = "Block \(number) Complete!"

        leftActivityIndicator.stopAnimating()
        rightActivityIndicator.stopAnimating()
        accuracyPercentLabel.text = percent(array: accuracy)
        historicalAccuracyPercentLabel.text = percent(array: historicalAccuracy)
    }

    // MARK: - Private Methods

    private func percent(array: [Int]) -> String {
        var countOfOnes: Float = 0
        array.forEach { element in
            if element == 1 {
                countOfOnes += 1
            }
        }

        let percent: Float = countOfOnes / Float(array.count)
        let roundedValue = (percent * 100).rounded()
        return String("\(Int(roundedValue))%")
    }

    @objc private func handleReplayButtonTapped() {
        didReplayButtonTapped?()
    }

    @objc private func handleEndButtonTapped() {
        didEndButtonTapped?()
    }

    // MARK: - UI Actions

    private func setupUI() {
        backgroundColor = .white
        addSubview(logo)
        constrain(logo) { logo in
            logo.height == 150
            logo.width == 150
            logo.top == logo.superview!.top + 90
            logo.centerX == logo.superview!.centerX
        }

        addSubview(blockCompleteLabel)
        constrain(blockCompleteLabel, logo) { label, logo in
            label.top == logo.bottom + 25
            label.centerX == label.superview!.centerX
        }

        addSubview(statisticsView)
        constrain(statisticsView, blockCompleteLabel) { view, label in
            view.width == view.superview!.width
            view.height == 100
            view.top == label.bottom + 35
        }

        statisticsView.addSubview(accuracyLabel)
        statisticsView.addSubview(historicalAcuracyLabel)

        constrain(accuracyLabel, historicalAcuracyLabel, statisticsView) { accuracyLabel, historicalAcuracyLabel, statisticsView in
            accuracyLabel.top == statisticsView.top
            accuracyLabel.left == statisticsView.left + 45

            historicalAcuracyLabel.top == accuracyLabel.top
            historicalAcuracyLabel.right == statisticsView.right - 45
        }

        statisticsView.addSubview(accuracyPercentLabel)
        statisticsView.addSubview(historicalAccuracyPercentLabel)

        constrain(accuracyPercentLabel, accuracyLabel) { label, percentLabel in
            label.top == percentLabel.bottom + 20
            label.centerX == percentLabel.centerX
        }

        constrain(historicalAccuracyPercentLabel, historicalAcuracyLabel) { label, percentLabel in
            label.top == percentLabel.bottom + 20
            label.centerX == percentLabel.centerX
        }

        addSubview(buttonsView)

        constrain(buttonsView, statisticsView) { buttonsView, statisticsView in
            buttonsView.width == buttonsView.superview!.width
            buttonsView.top == statisticsView.bottom
            buttonsView.bottom == buttonsView.superview!.bottom
        }

        buttonsView.addSubview(replayButton)
        replayButton.configure(color: R.color.pink()!, image: R.image.playAgain()!, buttonSize: 100)
        constrain(replayButton) { button in
            button.left == button.superview!.left + 45
            button.top == button.superview!.top + 40
        }

        buttonsView.addSubview(endButton)
        endButton.configure(color: R.color.pink()!, image: R.image.xButton()!, buttonSize: 100)
        constrain(endButton) { button in
            button.right == button.superview!.right - 45
            button.top == button.superview!.top + 40
        }

        buttonsView.addSubview(replayLabel)
        constrain(replayLabel, replayButton) { label, button in
            label.top == button.bottom + 10
            label.centerX == button.centerX
        }

        buttonsView.addSubview(endLabel)
        constrain(endLabel, endButton) { label, button in
            label.top == button.bottom + 10
            label.centerX == button.centerX
        }

        statisticsView.addSubview(leftActivityIndicator)
        statisticsView.addSubview(rightActivityIndicator)

        constrain(leftActivityIndicator, accuracyPercentLabel) { ai, label in
            ai.height == 100
            ai.width == 100
            ai.center == label.center
        }

        constrain(rightActivityIndicator, historicalAccuracyPercentLabel) { ai, label in
            ai.height == 100
            ai.width == 100
            ai.center == label.center
        }

        buttonsView.addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        constrain(separatorView) { separatorView in
            separatorView.top == separatorView.superview!.top
            separatorView.height == 2
            separatorView.left == separatorView.superview!.left
            separatorView.right == separatorView.superview!.right
        }
    }
}
