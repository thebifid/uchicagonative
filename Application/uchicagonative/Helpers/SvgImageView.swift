//
//  SvgImageView.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 07.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import SVGKit
import UIKit

class SvgImageView: UIView {
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(svgImageName name: String, size: CGSize, colorHex: String) {
        let imageView = UIImageView()
        imageView.image = SVGKImage.getImage(imageName: name, size: size, fillColor: UIColor(hexString: colorHex))
        addSubview(imageView)
        imageView.fillSuperView()
    }
}

extension SVGKImage {
    // MARK: - Private Method(s)

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

    // MARK: - Public Method(s)

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

    static func getImage(imageName: String, size: CGSize, fillColor color: UIColor?, opacity: Float = 1.0) -> UIImage? {
        let svgImage: SVGKImage = SVGKImage(named: imageName)
        svgImage.size = size
        if let colorToFill = color {
            svgImage.fillColor(color: colorToFill, opacity: opacity)
        }

        return svgImage.uiImage
    }
}
