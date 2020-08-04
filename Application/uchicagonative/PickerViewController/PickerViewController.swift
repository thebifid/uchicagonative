//
//  PickerViewController.swift
//  alertPickerViewTest
//
//  Created by Vasiliy Matveev on 02.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Cartography
import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - UI Controls

    private let fullView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // R.color.lightGrayCustom()
        return view
    }()

    lazy var topBorder = makeBorder()
    lazy var bottomBorder = makeBorder()

    private let label: UILabel = {
        let label = UILabel()
        return label
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    private let pickerView = UIPickerView()

    // MARK: - Private Properties

    private var items = [String]()
    private var selectedIndex: Int = 0

    // MARK: - Init

    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
        doneButton.addTarget(self, action: #selector(handleDoneButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Handlers

    var didDoneButtonTapped: ((String) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self

        setupUI()
    }

    // MARK: - Public Methods

    func hide() {
        let animation = { self.view.frame = .init(x: 0,
                                                  y: Constants.deviseHeight,
                                                  width: self.view.frame.width,
                                                  height: 300) }

        UIView.animate(withDuration: 0.4, animations: animation) { _ in

            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

    /// Shows pickerView in controller
    func show(in viewController: UIViewController, items: [String],
              selectedItem: String = "", labelText: String = "",
              didDoneButtonTapped: @escaping (String) -> Void) {
        self.items = items
        selectedIndex = items.firstIndex(of: selectedItem) ?? 0
        label.text = labelText
        self.didDoneButtonTapped = didDoneButtonTapped

        viewController.addChild(self)
        viewController.view.addSubview(view)

        view.frame = .init(x: 0, y: viewController.view.frame.height, width: viewController.view.frame.width, height: 300)

        UIView.animate(withDuration: 0.4) {
            self.view.frame = .init(x: 0, y: viewController.view.frame.height - 300, width: viewController.view.frame.width, height: 300)
        }

        DispatchQueue.main.async {
            self.pickerView.selectRow(self.selectedIndex, inComponent: 0, animated: false)
        }
    }

    // MARK: - Private Methods

    @objc private func handleDoneButtonTapped() {
        didDoneButtonTapped?(items[selectedIndex])
    }

    private func makeBorder() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }

    // MARK: - UI Actions

    func setupUI() {
        view.addSubview(fullView)

        constrain(fullView) { fullView in

            fullView.width == fullView.superview!.width
            fullView.height == 300
            fullView.top == fullView.superview!.top
            fullView.centerX == fullView.superview!.centerX
        }

        fullView.addSubview(menuView)
        menuView.addSubview(doneButton)

        constrain(menuView, doneButton) { menuView, doneButton in

            menuView.width == menuView.superview!.width
            menuView.height == 50
            menuView.top == menuView.superview!.top
            menuView.centerX == menuView.superview!.centerX

            doneButton.centerY == doneButton.superview!.centerY
            doneButton.right == doneButton.superview!.right - 20
        }

        menuView.addSubview(label)

        constrain(label) { label in
            label.centerY == label.superview!.centerY
            label.left == label.superview!.left + 20
        }

        menuView.addSubview(topBorder)
        menuView.addSubview(bottomBorder)

        constrain(topBorder, bottomBorder) { topBorder, bottomBorder in
            topBorder.width == topBorder.superview!.width
            topBorder.height == 1
            topBorder.top == topBorder.superview!.top

            bottomBorder.width == bottomBorder.superview!.width
            bottomBorder.height == 1
            bottomBorder.bottom == bottomBorder.superview!.bottom
        }

        fullView.addSubview(pickerView)
        constrain(pickerView, menuView) { pickerView, menuView in

            pickerView.top == menuView.bottom + 5
            pickerView.centerX == pickerView.superview!.centerX
        }
    }

    // MARK: - PickerView Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}
