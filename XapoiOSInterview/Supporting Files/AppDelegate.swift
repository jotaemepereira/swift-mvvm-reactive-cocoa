//
//  AppDelegate.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupInitialScreen()
        return true
    }
    
    private func setupInitialScreen() {
        let trendingReposVC = TrendingReposViewController()
        window!.rootViewController = trendingReposVC
        window!.makeKeyAndVisible()
    }
}

