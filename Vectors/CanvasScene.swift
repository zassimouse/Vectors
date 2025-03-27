//
//  CanvasScene.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import Foundation
import SpriteKit

class CanvasScene: SKScene {
    
    enum VectorDrag {
        case start
        case end
        case parallel
    }
    
    private var panGesture: UIPanGestureRecognizer!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    private var vectors: [Vector] = []
    private var selectedVector: Vector? = nil
    private var dragType: VectorDrag? = nil

    private var lastTranslation = CGPoint.zero
    private var cameraNode = SKCameraNode()

    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let vector = Vector(start: CGPoint(x: 150, y: 150), end: CGPoint(x: 400, y: 100))
        vectors.append(vector)
        
        for vector in vectors {
            addVector(vector)
        }
        
        camera = cameraNode
        addChild(cameraNode)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        view.addGestureRecognizer(longPressGesture)
    }

    private func addVector(_ vector: Vector) {
        let path = UIBezierPath()
        path.move(to: vector.start)
        let shortenedEnd = shortenVectorEnd(from: vector.start, to: vector.end, by: 5.0)
        path.addLine(to: shortenedEnd)
        
        let arrowWidth: CGFloat = 8.0
        let arrowHeight: CGFloat = 25.0
        let angle = vector.angle
        
        // Calculate arrow points
        let arrowPoint1 = CGPoint(
            x: vector.end.x - arrowHeight * cos(angle) + arrowWidth * sin(angle),
            y: vector.end.y - arrowHeight * sin(angle) - arrowWidth * cos(angle)
        )
        let arrowPoint2 = CGPoint(
            x: vector.end.x - arrowHeight * cos(angle) - arrowWidth * sin(angle),
            y: vector.end.y - arrowHeight * sin(angle) + arrowWidth * cos(angle)
        )
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: vector.end)
        arrowPath.addLine(to: arrowPoint1)
        arrowPath.addLine(to: arrowPoint2)
        arrowPath.close()
        
        let vectorNode = SKShapeNode(path: path.cgPath)
        vectorNode.strokeColor = vector.color
        vectorNode.lineWidth = 3
        
        let arrowNode = SKShapeNode(path: arrowPath.cgPath)
        arrowNode.fillColor = vector.color
        arrowNode.strokeColor = vector.color
        
        addChild(vectorNode)
        addChild(arrowNode)
    }
    
    private func shortenVectorEnd(from start: CGPoint, to end: CGPoint, by distance: CGFloat) -> CGPoint {
        // Calculate the direction vector from start to end
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        // Calculate the length of the vector
        let length = sqrt(dx * dx + dy * dy)
        
        // Normalize the direction vector
        let directionX = dx / length
        let directionY = dy / length
        
        // Calculate the new end point by moving it towards the start point by 'distance' pixels
        let newEndX = end.x - directionX * distance
        let newEndY = end.y - directionY * distance
        
        return CGPoint(x: newEndX, y: newEndY)
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .began {
            lastTranslation = .zero
        }
        
        let deltaX = -(translation.x - lastTranslation.x)
        let deltaY = (translation.y - lastTranslation.y)
        
        cameraNode.position.x += deltaX
        cameraNode.position.y += deltaY
        
        lastTranslation = translation
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: view)
        let sceneLocation = convertPoint(fromView: location)
        
        switch gesture.state {
        case .began:
            for vector in vectors {
                if distance(from: sceneLocation, to: vector.start) < 20 {
                    dragType = .start
                    selectedVector = vector
                    break
                } else if distance(from: sceneLocation, to: vector.end) < 20 {
                    dragType = .end
                    selectedVector = vector
                    break
                }
            }
            
        case .changed:
            if let point = dragType, let vector = selectedVector {
                print(sceneLocation)
                if point == .start {
                    vector.start = sceneLocation
                } else if point == .end {
                    vector.end = sceneLocation
                }
                self.removeAllChildren()
                addVector(vector)
            }
            
        case .ended:
            dragType = nil
            selectedVector = nil
        default:
            break
        }
    }
}
