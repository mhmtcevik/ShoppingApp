//
//  UIView+Extensions.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 29.09.2023.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
    }
    
    func roundCorners(
        radius: CGFloat,
        corners: CACornerMask = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
        ]
    ) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
}
