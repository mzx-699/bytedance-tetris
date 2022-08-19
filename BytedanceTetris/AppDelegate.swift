//
//  AppDelegate.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = TetrisViewController()
        window?.makeKeyAndVisible()
        return true
    }



}

