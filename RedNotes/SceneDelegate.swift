//
//  SceneDelegate.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import SnapKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
                
        window.rootViewController = UINavigationController(rootViewController: MainController())
                
        self.window = window
        window.makeKeyAndVisible()
    }
}

