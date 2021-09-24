//
//  UINavigation+MarvelAppearance.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit.UINavigationController

extension UINavigationController {
    func setupAppearance() {
        let appearance = UINavigationBarAppearance(idiom: .phone)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .blurredRedMarvel
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        navigationBar.prefersLargeTitles = true
    }
}
