//
//  SvgImageView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 07.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import SVGKit
import UIKit

class SvgImageView: UIImageView {
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(svgImageName: String, colorHex: String) {
        image = SVGKImage.makeColoredImage(imageName: svgImageName, fillColor: UIColor(hexString: colorHex))
    }
}

/// Color for SVG images
extension SVGKImage {
    private func fillColorForSubLayer(layer: CALayer, color: UIColor, opacity: Float) {
        if layer is CAShapeLayer {
            let shapeLayer = layer as! CAShapeLayer
            shapeLayer.fillColor = color.cgColor
            shapeLayer.opacity = opacity
        }

        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                fillColorForSubLayer(layer: subLayer, color: color, opacity: opacity)
            }
        }
    }

    private func fillColorForOutter(layer: CALayer, color: UIColor, opacity: Float) {
        if let shapeLayer = layer.sublayers?.first as? CAShapeLayer {
            shapeLayer.fillColor = color.cgColor
            shapeLayer.opacity = opacity
        }
    }

    func fillColor(color: UIColor, opacity: Float) {
        if let layer = caLayerTree {
            fillColorForSubLayer(layer: layer, color: color, opacity: opacity)
        }
    }

    func fillOutterLayerColor(color: UIColor, opacity: Float) {
        if let layer = caLayerTree {
            fillColorForOutter(layer: layer, color: color, opacity: opacity)
        }
    }

    static func makeColoredImage(imageName: String, fillColor color: UIColor?, opacity: Float = 1.0) -> UIImage? {
        let svgImage: SVGKImage = SVGKImage(named: imageName)
        if let colorToFill = color {
            svgImage.fillColor(color: colorToFill, opacity: opacity)
        }

        return svgImage.uiImage
    }
}
