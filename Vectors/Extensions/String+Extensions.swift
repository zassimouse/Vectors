//
//  String+Extensions.swift
//  Vectors
//
//  Created by Denis Haritonenko on 31.03.25.
//

import Foundation

extension String {
    var trailingZeroesRemoved: String {
        if let doubleValue = Double(self) {
            return String(format: "%g", doubleValue).replacingOccurrences(of: ".", with: ",")
        }
        return self
    }
}
