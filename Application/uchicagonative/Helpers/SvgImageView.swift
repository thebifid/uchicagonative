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
        let svgImage = SVGKImage(named: name)
        svgImage?.size = size

        let imageView = SVGKFastImageView(svgkImage: svgImage!)
        imageView?.image = svgImage
        imageView?.fillTintColor(colorImage: UIColor(hexString: colorHex))
        addSubview(imageView!)

        imageView?.fillSuperView()
    }
}

// SVGKImageView - color SVG
extension SVGKImageView {
    func fillTintColor(colorImage: UIColor) {
        if image != nil, image.caLayerTree != nil {
            guard let sublayers = image.caLayerTree.sublayers else { return }
            fillRecursively(sublayers: sublayers, color: colorImage)
        }
    }

    private func fillRecursively(sublayers: [CALayer], color: UIColor) {
        for layer in sublayers {
            if let l = layer as? CAShapeLayer {
                colorThatImageWIthColor(color: color, layer: l)
            }
        }
    }

    func colorThatImageWIthColor(color: UIColor, layer: CAShapeLayer) {
        if layer.strokeColor != nil {
            layer.strokeColor = color.cgColor
        }
        if layer.fillColor != nil {
            layer.fillColor = color.cgColor
        }
    }
}
