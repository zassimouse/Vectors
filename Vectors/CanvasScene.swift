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
        
        drawGrid()
        drawAxes()
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

    private func drawAxes() {
        let axisLineWidth: CGFloat = 4.0
        
        // Draw X Axis
        let xAxis = SKShapeNode()
        xAxis.path = UIBezierPath(rect: CGRect(x: -frame.size.width / 2, y: 0, width: frame.size.width, height: axisLineWidth)).cgPath
        xAxis.fillColor = .black
        addChild(xAxis)

        // Draw Y Axis
        let yAxis = SKShapeNode()
        yAxis.path = UIBezierPath(rect: CGRect(x: 0, y: -frame.size.height / 2, width: axisLineWidth, height: frame.size.height)).cgPath
        yAxis.fillColor = .black
        addChild(yAxis)
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

        // Draw the arrowhead
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
                } else if distance(from: sceneLocation, to: vector.end) < 20 {
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
                if dragType == .start {
                    vector.start = sceneLocation
                } else if dragType == .end {
                    vector.end = sceneLocation
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
                for v in vectors {
                    addVector(v)
                }
            }

        case .ended:
            if selectedVector != nil {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            dragType = nil
            selectedVector = nil

        default:
            break
        }
    }
    
    // Method to remove a vector by its id
    func removeVectorByID(_ id: Int) {
        if let node = childNode(withName: String(id)) {
            node.removeFromParent()
        }
    }

    
    
    private func isPointNearVector(_ point: CGPoint, _ vector: Vector) -> Bool {
        let lineWidth: CGFloat = 20.0
        let startToEnd = distance(from: vector.start, to: vector.end)
        let startToPoint = distance(from: vector.start, to: point)
        let endToPoint = distance(from: vector.end, to: point)

        return abs(startToPoint + endToPoint - startToEnd) < lineWidth
    }

}


