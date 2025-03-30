//
//  UIColor+Extensions.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
