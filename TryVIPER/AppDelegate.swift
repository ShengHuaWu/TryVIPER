//
//  AppDelegate.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 11/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    let router = Router()
    
    // MARK: Application Delegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ImageProvider.setUp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        router.configure(window)
        
        return true
    }
}
