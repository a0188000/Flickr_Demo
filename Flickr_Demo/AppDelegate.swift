//
//  AppDelegate.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarCtrl = UITabBarController()
    var mainViewCtrl = MainViewController()
    var favPhotoListViewCtrl = FavPhotListViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FlickrHelper.shared.initialize()
        RealmHelper.shared
        
        mainViewCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favPhotoListViewCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        self.tabbarCtrl.viewControllers =
            [
                UINavigationController(rootViewController: mainViewCtrl),
                UINavigationController(rootViewController: favPhotoListViewCtrl)
            ]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = self.tabbarCtrl
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .init("UserAuthCallback"), object: url)
        return true
    }
}

