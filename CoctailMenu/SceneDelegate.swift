//
//  SceneDelegate.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let builder = BuilderMainFlow()
        let vc = builder.buildMainVC()
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}

