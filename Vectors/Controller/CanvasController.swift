//
//  ViewController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import UIKit
import SpriteKit

protocol HomeControllerDeledate: AnyObject {
    func toggleMenu()
    func addVector(_ vector: Vector)
    func editVector(_ vector: Vector)
}

class CanvasController: UIViewController {

   // MARK: - Properties
    weak var delegate: HomeControllerDeledate?
    
    private var scene: CanvasScene!
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        configureNavigationBar()
        
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let vectors = CoreDataManager.shared.fetchVectors()
        scene = CanvasScene(size: view.bounds.size)
        scene.canvasDelegate = self
        scene.configure(with: vectors)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    // MARK: - Handlers
    func deleteVector(_ vector: Vector) {
        scene.deleteVector(vector)
    }
    
    func highlightVector(_ vector: Vector) {
        scene.highlightVector(vector)
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white

        navigationItem.title = "Vector Editor"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(toggleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddVectorSheet))
    }
    
    @objc private func presentAddVectorSheet() {
        let addVectorVC = AddVectorController()
        addVectorVC.delegate = self

        if let sheet = addVectorVC.sheetPresentationController {
            sheet.detents = [.custom { context in
                return 240
            }]
        }

        present(addVectorVC, animated: true)


    }
    
    // MARK: - SetupUI

    
    // MARK: - Methods
    
    
    // MARK: - Selectors
    @objc func toggleMenu() {
        delegate?.toggleMenu()
    }

}

extension CanvasController: CanvasSceneDelegate {
    func editVector(_ vector: Vector) {
        CoreDataManager.shared.updateVector(vector)
        delegate?.editVector(vector)
    }
}

extension CanvasController: AddVectorDelegate {
    func didAddVector(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let vector = Vector(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
        scene.addVector(vector)
        CoreDataManager.shared.saveVector(vector)
        delegate?.addVector(vector)
    }
}
