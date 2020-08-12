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

    private var imagesOnScreen = [SvgImageView]()

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
        fetchSessionConfigurations()
        setupUI()

        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)

        viewModel.didUpdate = { [weak self] in
            self?.imagesOnScreen.forEach { image in
                image.removeFromSuperview()
            }
            self?.imagesOnScreen.removeAll()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(handleRefresh))
    }

    // MARK: - Private Methods

    @objc private func handlePlay() {
        readyLabel.isHidden = true
        playButton.isHidden = true

        scrollView.backgroundColor = UIColor(hexString: viewModel.backgroundColor)
        showImages()
    }

    private func showImages() {
        viewModel.generateNewCellsLocation(forView: view, count: viewModel.setSize)
        print(viewModel.locations)
        for index in 0 ..< viewModel.setSize {
            addImage(colorHex: "color", index: index)
        }
    }

    private func setNewColor(_ index: Int) -> String {
        var newIndex = index
        if newIndex > viewModel.colors.count {
            newIndex = index % viewModel.colors.count
        } else {
            newIndex = index
        }
        let color = viewModel.colors[newIndex]
        return color
    }

    private func addImage(colorHex: String, index: Int) {
        let size: CGFloat = viewModel.stimuliSize
        let location = viewModel.locations[index]
        let xLocation = location[0]
        let yLocation = location[1]
        let svgImage = SvgImageView()

        svgImage.configure(svgImageName: viewModel.iconName,
                           size: .init(width: size, height: size),
                           colorHex: colorHex)
        scrollView.addSubview(svgImage)
        imagesOnScreen.append(svgImage)

        constrain(svgImage) { svgImage in
            svgImage.left == svgImage.superview!.left + CGFloat(xLocation)
            svgImage.top == svgImage.superview!.top + CGFloat(yLocation)
        }
    }

    private func fetchSessionConfigurations() {
        viewModel.fetchSessionConfigurations { [weak self] result in
            switch result {
            case let .failure(error):
                let alert = AlertAssist.showErrorAlert(error)
                self?.present(alert, animated: true)

            case .success:
                break
            }
        }
    }

    @objc private func handleRefresh() {
        showImages()
    }

    // MARK: - UI Actions

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        scrollView.backgroundColor = R.color.appBackgroundColor()!

        let stackView = VerticalStackView(arrangedSubviews: [readyLabel, playButton], spacing: 20)
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
