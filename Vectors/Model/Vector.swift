//
//  Vector.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import Foundation

import Foundation
import UIKit

struct Vector {
    let start: CGPoint
    let end: CGPoint
    let color: UIColor

    var length: CGFloat {
        return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }

    var angle: CGFloat {
        return atan2(end.y - start.y, end.x - start.x)
    }

    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
        self.color = .random 
    }
}
