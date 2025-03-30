//
//  ViewController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = CanvasScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }


}

