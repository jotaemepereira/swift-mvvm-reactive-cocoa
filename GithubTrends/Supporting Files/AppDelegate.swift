//
//  AppDelegate.swift
//  GithubTrends
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
        setupInitialScreen()
        return true
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(hexString: "#657986")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#657986")]
    }
    
    private func setupInitialScreen() {
        let viewModel = TrendingReposViewModel(apiClient: ApiClient())
        let trendingReposVC = TrendingReposViewController(viewModel: viewModel)
        window!.rootViewController = trendingReposVC
        window!.makeKeyAndVisible()
    }
}

