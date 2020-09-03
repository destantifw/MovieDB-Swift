//
//  AppDelegate.swift
//  MovieDB
//
//  Created by destanti on 01/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        if let window = window {
            let viewModel = MovieCategoryGenreViewModel(networkingService: MovieGenreApi())
            let viewController = MovieCategoryGenreViewController(viewModel: viewModel, tableView: nil)
            
            window.rootViewController = UINavigationController(rootViewController: viewController)
            window.makeKeyAndVisible()
        }
        UINavigationBar.appearance().barTintColor = .black
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        UIApplication.shared.canOpenURL(url)
        
        return true
    }
}
