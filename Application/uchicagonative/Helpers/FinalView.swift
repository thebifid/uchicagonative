//
//  FinalView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 26.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class FinalView: UIView {
    private let logo = UIImageView(image: R.image.mainIcon()!)
    private let blockCompleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Block 1 Complete!"
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
        label.text = "-"
        label.textColor = .black
        label.font = R.font.helveticaNeueCyrMedium(size: 20)!
        return label
    }()

    private let historicalAccuracyPercentLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(logo)
        constrain(logo) { logo in
            logo.height == 150
            logo.width == 150
            logo.top == logo.superview!.top + 130
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
            view.top == label.bottom + 100
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
    }
}
