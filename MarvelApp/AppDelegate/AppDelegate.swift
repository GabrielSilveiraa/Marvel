//
//  AppDelegate.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}

