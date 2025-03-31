//
//  ContainerController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

class ContainerController: UIViewController {

    // MARK: - Properties
    var menuController: MenuController!
    var navController: UIViewController!
    var homeController: CanvasController!
    var isExpanded = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
    }
    
    // MARK: - Handlers
    func configureHomeViewController() {
        homeController = CanvasController()
        homeController.delegate = self
        navController = UINavigationController(rootViewController: homeController)
        view.addSubview(navController.view)
        addChild(navController)
        navController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenuController(shouldExpand: Bool) {
        if shouldExpand {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.navController.view.frame.origin.x = self.navController.view.frame.width / 3
            }, completion: nil)

        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.navController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
    
    // MARK: - SetupUI
    
    // MARK: - Methods
    
    // MARK: - Selectors

}

extension ContainerController: MenuControllerDeledate {
    func deleteVector(_ vector: Vector) {
        homeController.deleteVector(vector)
    }
    
    func highlightVector(_ vector: Vector) {
        homeController.highlightVector(vector)
    }
}


extension ContainerController: HomeControllerDeledate {
    func toggleMenu() {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded)
    }
    
    func addVector(_ vector: Vector) {
        if menuController != nil {
            menuController.addVector(vector)
        }
    }
    
    func editVector(_ vector: Vector) {
        if menuController != nil {
            menuController.editVector(vector)
        }
    }
}
