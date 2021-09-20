//
//  SceneDelegate.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var appCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard
            let windowScene = scene as? UIWindowScene,
            NSClassFromString("XCTest") == nil
        else {
            return
        }


        let window = UIWindow(windowScene: windowScene)

        appCoordinator = CharactersCoordinator(window: window)
        appCoordinator?.start()
    }
}

