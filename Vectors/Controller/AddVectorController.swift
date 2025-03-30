//
//  AddVectorController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

protocol AddVectorViewControllerDelegate: AnyObject {
    func didAddVector(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat)
}

class AddVectorViewController: UIViewController {
    
    weak var delegate: AddVectorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

