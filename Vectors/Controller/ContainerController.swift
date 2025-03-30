//
//  ContainerController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

class ContainerController: UIViewController {
    // MARK: - Properties
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpanded = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
    }
    
//    override var prefferedStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
    
    // MARK: - Handlers
    
    func configureHomeViewController() {
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("did add menucontroller")
        }
    }
    
    func showMenuController(shouldExpand: Bool) {
        if shouldExpand {
            // Show menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width / 3
            }, completion: nil)

        } else {
            // Hide menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
    


    
    // MARK: - SetupUI
    
    // MARK: - Methods
    
    // MARK: - Selectors

}

extension ContainerController: HomeControllerDeledate {
    func toggleMenu() {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded)
    }
    
    
}
