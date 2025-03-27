//
//  CanvasScene.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import Foundation
import SpriteKit

class CanvasScene: SKScene {
    private var panGesture: UIPanGestureRecognizer!
    private var lastTranslation = CGPoint.zero
    private var cameraNode = SKCameraNode()

    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Create an array of vectors with random colors
        let vectors: [Vector] = [
            Vector(start: CGPoint(x: 100, y: 100), end: CGPoint(x: 300, y: 300)),
            Vector(start: CGPoint(x: 150, y: 150), end: CGPoint(x: 400, y: 100)),
            Vector(start: CGPoint(x: 200, y: 200), end: CGPoint(x: 500, y: 500))
        ]
        
        // Loop through the vector array and add each vector
        for vector in vectors {
            addVector(vector)
        }

        camera = cameraNode
        addChild(cameraNode)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
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
}
