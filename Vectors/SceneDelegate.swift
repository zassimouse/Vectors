//
//  SceneDelegate.swift
//  Vectors
//
//  Created by Denis Haritonenko on 27.03.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ContainerController()
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

