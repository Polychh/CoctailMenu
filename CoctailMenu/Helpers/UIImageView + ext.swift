//
//  UIImageView + ext.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit

extension UIImageView {
    func applyGradientMask(colors: [UIColor], locations: [NSNumber]?) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor } //converts the array of UIColor objects into an array of CGColor objects. This is because CAGradientLayer uses CGColor objects for its colors.
        gradientLayer.locations = locations
        gradientLayer.backgroundColor = UIColor.black.withAlphaComponent(0.1).cgColor//Next, it sets the background color of the gradient layer to a semi-transparent black color. This ensures that the view below the gradient layer will still be visible
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer) //Finally, it adds the gradient layer as a sublayer of the view's layer. This means that the gradient layer will be drawn over the content of the view.
    }
}
