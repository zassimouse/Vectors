//
//  Vector.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import Foundation
import UIKit

class Vector: Equatable {
    var id: Int
    var start: CGPoint
    var end: CGPoint
    let color: UIColor
    
    static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.id == rhs.id
    }

    var length: CGFloat {
        return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }

    var angle: CGFloat {
        return atan2(end.y - start.y, end.x - start.x)
    }

    init(start: CGPoint, end: CGPoint, color: UIColor = .random) {
        let uuidString = UUID().uuidString
        let id = uuidString.hashValue
        self.id = abs(id)
        self.start = start
        self.end = end
        self.color = color
    }
}
