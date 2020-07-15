//
//  AppDelegate.swift
//  Download
//
//  Created by 王智刚 on 2020/7/14.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

fileprivate let backgroundTaskIdentifier = "com.nshipster.example.task.refresh"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var backgroundURLSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.nshipster.url-session.background")
        configuration.isDiscretionary = true
        configuration.timeoutIntervalForRequest = 30

        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue())
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        <#code#>
    }


}

