//
//  ViewController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import UIKit
import SpriteKit

class HomeController: UIViewController {

   // MARK: - Properties
    
    weak var delegate: HomeControllerDeledate?
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        configureNavigationBar()
        
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = CanvasScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    // MARK: - Handlers
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

extension HomeController: AddVectorDelegate {
    func didAddVector(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        print("Добавлен вектор: (\(startX), \(startY)) -> (\(endX), \(endY))")
    }
}
