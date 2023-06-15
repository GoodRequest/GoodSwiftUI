//
//  AppDelegate.swift
//  GoodUIKit-Sample
//
//  Created by Andrej Jasso on 02/03/2023.
//

import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        window.backgroundColor = .white
        
        let controller = UIHostingController(rootView: SamplesListView())
    
        window.rootViewController = controller
        window.makeKeyAndVisible()

        return true
    }

}
