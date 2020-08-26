//
//  SessionConfiguration.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 11.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

struct SessionConfiguration {
    let active: Bool
    let backgroundColor: String
    let changeProbability: Float
    let colorPaletteId: String
    let colorPaletteName: String
    let colors: [String]
    let createdAt: Any
    let delayPeriod: Int
    let feedbackDuration: Int
    let feedbackTone: FeedbackType
    let feedbackVibration: FeedbackType
    let iconName: String
    let interTrialInterval: Int
    let name: String
    let numberOfTrials: Int
    let sampleExposureDuration: Int
    let setSize: Int
    let stimuliSize: CGFloat
    let updatedAt: Any

    enum FeedbackType: String {
        case none = "None"
        case onsuccess = "On success"
        case onfailure = "On failure"
        case both = "Both"
    }

    init() {
        active = false
        backgroundColor = ""
        changeProbability = 0
        colorPaletteId = ""
        colorPaletteName = ""
        colors = []
        createdAt = ""
        delayPeriod = 0
        feedbackDuration = 0
        feedbackTone = .none
        feedbackVibration = .none
        iconName = ""
        interTrialInterval = 0
        name = ""
        numberOfTrials = 0
        sampleExposureDuration = 0
        setSize = 0
        stimuliSize = 0
        updatedAt = ""
    }

    init?(rawDict: [String: Any]) {
        active = rawDict["active"] as? Bool ?? false
        backgroundColor = rawDict["backgroundColor"] as? String ?? ""
        let change = rawDict["changeProbability"] as? Double ?? 0
        changeProbability = Float(change)
        colorPaletteId = rawDict["colorPaletteId"] as? String ?? ""
        colorPaletteName = rawDict["colorPaletteName"] as? String ?? ""
        colors = rawDict["colors"] as? [String] ?? []
        createdAt = rawDict["createdAt"] ?? ""
        delayPeriod = rawDict["delayPeriod"] as? Int ?? 0
        feedbackDuration = rawDict["feedbackDuration"] as? Int ?? 0

        let toneType = rawDict["feedbackTone"] as? String ?? ""
        switch toneType.lowercased() {
        case FeedbackType.onsuccess.rawValue.lowercased():
            feedbackTone = .onsuccess
        case FeedbackType.onfailure.rawValue.lowercased():
            feedbackTone = .onfailure
        case FeedbackType.both.rawValue.lowercased():
            feedbackTone = .both
        case FeedbackType.none.rawValue.lowercased():
            feedbackTone = .none
        default:
            feedbackTone = .none
        }

        let vibrationType = rawDict["feedbackVibration"] as? String ?? ""
        switch vibrationType.lowercased() {
        case FeedbackType.onsuccess.rawValue.lowercased():
            feedbackVibration = .onsuccess
        case FeedbackType.onfailure.rawValue.lowercased():
            feedbackVibration = .onfailure
        case FeedbackType.both.rawValue.lowercased():
            feedbackVibration = .both
        case FeedbackType.none.rawValue.lowercased():
            feedbackVibration = .none
        default:
            feedbackVibration = .none
        }

        iconName = rawDict["iconName"] as? String ?? ""
        interTrialInterval = rawDict["interTrialInterval"] as? Int ?? 0
        name = rawDict["name"] as? String ?? ""
        numberOfTrials = rawDict["numberOfTrials"] as? Int ?? 0
        sampleExposureDuration = rawDict["sampleExposureDuration"] as? Int ?? 0
        setSize = rawDict["setSize"] as? Int ?? 0
        stimuliSize = rawDict["stimuliSize"] as? CGFloat ?? 0
        updatedAt = rawDict["updatedAt"] ?? ""
    }
}
