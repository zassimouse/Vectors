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
    
    private var lastSnappedAngle: CGFloat? = nil
    private var snappedToAxis = false
    private var snappedToRightAngle = false
    
    private let snapThreshold: CGFloat = 10.0


    override func didMove(to view: SKView) {
        backgroundColor = .white
        drawGrid()
        
        let vector = Vector(start: CGPoint(x: 150, y: 150), end: CGPoint(x: 400, y: 100))
        vectors.append(vector)
        let vector2 = Vector(start: CGPoint(x: 100, y: 80), end: CGPoint(x: 40, y: 200))
        vectors.append(vector2)

        
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
    
    private func drawGrid() {
        let gridSize: CGFloat = 50.0
        let gridLineCount: CGFloat = 20.0

        for x in stride(from: -gridLineCount * gridSize, to: gridLineCount * gridSize, by: gridSize) {
            let line = SKShapeNode()
            line.path = UIBezierPath(rect: CGRect(x: x, y: -gridLineCount * gridSize, width: gridSize, height: gridLineCount * 2 * gridSize)).cgPath
            line.strokeColor = .lightGray
            line.lineWidth = 1
            addChild(line)
        }
        
        for y in stride(from: -gridLineCount * gridSize, to: gridLineCount * gridSize, by: gridSize) {
            let line = SKShapeNode()
            line.path = UIBezierPath(rect: CGRect(x: -gridLineCount * gridSize, y: y, width: gridLineCount * 2 * gridSize, height: gridSize)).cgPath
            line.strokeColor = .lightGray
            line.lineWidth = 1
            addChild(line)
        }
    }

    
    func addVector(_ vector: Vector) {
        let path = UIBezierPath()
        
        // Draw the main vector line
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

        path.move(to: vector.end)
        path.addLine(to: arrowPoint1)
        path.addLine(to: arrowPoint2)
        path.close()
        
        let vectorNode = SKShapeNode(path: path.cgPath)
        vectorNode.fillColor = vector.color
        vectorNode.strokeColor = vector.color
        vectorNode.lineWidth = 3
        vectorNode.lineJoin = .miter

        vectorNode.name = String(vector.id)
        
        addChild(vectorNode)
    }
    
    func removeVectorByID(_ id: Int) {
        if let node = childNode(withName: String(id)) {
            node.removeFromParent()
        }
    }
    
    private func shortenVectorEnd(from start: CGPoint, to end: CGPoint, by distance: CGFloat) -> CGPoint {
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        let length = sqrt(dx * dx + dy * dy)
        
        let directionX = dx / length
        let directionY = dy / length
        
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
    
    
    
    private func isConnectedPoint(_ point: CGPoint) -> [Vector] {
        return vectors.filter { $0.start == point || $0.end == point }
    }

    private func angleBetweenVectors(v1: Vector, v2: Vector, commonPoint: CGPoint) -> CGFloat {
        let p1 = (v1.start == commonPoint) ? v1.end : v1.start
        let p2 = (v2.start == commonPoint) ? v2.end : v2.start
        
        let dx1 = p1.x - commonPoint.x
        let dy1 = p1.y - commonPoint.y
        let dx2 = p2.x - commonPoint.x
        let dy2 = p2.y - commonPoint.y
        
        let dotProduct = dx1 * dx2 + dy1 * dy2
        let magnitude1 = sqrt(dx1 * dx1 + dy1 * dy1)
        let magnitude2 = sqrt(dx2 * dx2 + dy2 * dy2)
        
        guard magnitude1 > 0, magnitude2 > 0 else { return 0 }
        
        let cosineAngle = dotProduct / (magnitude1 * magnitude2)
        let angle = acos(cosineAngle) * 180 / .pi
        
        return angle
    }
    
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: view)
        let sceneLocation = convertPoint(fromView: location)

        switch gesture.state {
        case .began:
            for vector in vectors {
                if distance(from: sceneLocation, to: vector.start) < 30 {
                    dragType = .start
                    selectedVector = vector
                } else if distance(from: sceneLocation, to: vector.end) < 30 {
                    dragType = .end
                    selectedVector = vector
                } else if isPointNearVector(sceneLocation, vector) {
                    dragType = .parallel
                    selectedVector = vector
                    lastTranslation = sceneLocation
                }
                
                if selectedVector != nil {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    break
                }
            }

        case .changed:
            if let vector = selectedVector {
                var newPosition = sceneLocation

                for otherVector in vectors where otherVector.id != vector.id {
                    if distance(from: sceneLocation, to: otherVector.start) < snapThreshold {
                        newPosition = otherVector.start
                    } else if distance(from: sceneLocation, to: otherVector.end) < snapThreshold {
                        newPosition = otherVector.end
                    }
                }
                
                let referencePoint = (dragType == .start) ? vector.end : vector.start

                newPosition = snapToAxis(newPosition, relativeTo: referencePoint)
                newPosition = snapToRightAngleFromPoint(newPoint: newPosition, commonPoint: referencePoint, movingVector: vector)
                
                if dragType == .start {
                    vector.start = newPosition
                } else if dragType == .end {
                    vector.end = newPosition
                } else if dragType == .parallel {
                    let dx = sceneLocation.x - lastTranslation.x
                    let dy = sceneLocation.y - lastTranslation.y
                    vector.start.x += dx
                    vector.start.y += dy
                    vector.end.x += dx
                    vector.end.y += dy
                    lastTranslation = sceneLocation
                }

                removeVectorByID(vector.id)
                addVector(vector)
            }
            

        case .ended:
            if selectedVector != nil {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            dragType = nil
            selectedVector = nil
            
            snappedToAxis = false
            snappedToRightAngle = false
            lastSnappedAngle = nil


        default:
            break
        }
    }
    
    private func snapToRightAngleFromPoint(newPoint: CGPoint, commonPoint: CGPoint, movingVector: Vector) -> CGPoint {
        let connectedVectors = isConnectedPoint(commonPoint)
        
        guard connectedVectors.count == 2 else {
            return newPoint
        }
        
        let vector1 = connectedVectors[0]
        let vector2 = connectedVectors[1]
        
        let newVector = Vector(start: commonPoint, end: newPoint)
        
        let staticVector = (movingVector == vector1) ? vector2 : vector1
        let angle = angleBetweenVectors(v1: newVector, v2: staticVector, commonPoint: commonPoint)
        
        if abs(angle - 90) < 10 {
            return correctToRightAnglePosition(vector1: staticVector, vector2: newVector, commonPoint: commonPoint)
        }
        
        return newPoint
    }

    private func correctToRightAnglePosition(vector1: Vector, vector2: Vector, commonPoint: CGPoint) -> CGPoint {
        let staticPoint = (vector1.start == commonPoint) ? vector1.end : vector1.start
        let movingPoint = vector2.end
        
        let dx = movingPoint.x - commonPoint.x
        let dy = movingPoint.y - commonPoint.y
        let sx = staticPoint.x - commonPoint.x
        let sy = staticPoint.y - commonPoint.y
        
        let lengthSquared = sx * sx + sy * sy
        let projectionFactor = (dx * sx + dy * sy) / lengthSquared
        
        let px = dx - projectionFactor * sx
        let py = dy - projectionFactor * sy
        
        return CGPoint(x: commonPoint.x + px, y: commonPoint.y + py)
    }

    private func snapToAxis(_ point: CGPoint, relativeTo otherPoint: CGPoint) -> CGPoint {
        let dx = abs(point.x - otherPoint.x)
        let dy = abs(point.y - otherPoint.y)

        if dx < snapThreshold {
            return CGPoint(x: otherPoint.x, y: point.y)
        } else if dy < snapThreshold {
            return CGPoint(x: point.x, y: otherPoint.y)
        }

        return point
    }

    private func isPointNearVector(_ point: CGPoint, _ vector: Vector) -> Bool {
        let lineWidth: CGFloat = 20.0
        let startToEnd = distance(from: vector.start, to: vector.end)
        let startToPoint = distance(from: vector.start, to: point)
        let endToPoint = distance(from: vector.end, to: point)

        return abs(startToPoint + endToPoint - startToEnd) < lineWidth
    }

}


