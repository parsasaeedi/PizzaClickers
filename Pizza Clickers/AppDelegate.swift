//
//  AppDelegate.swift
//  Pizza Clickers
//
//  Created by Parsa Saeedi on 2021-07-02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var myViewController: ViewController!
//    var vc = ViewController()
//    let vc = UIApplication.shared.windows[0].rootViewController!
    

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
//        print("Saved")
//        print(vc.pizzaBrain.numOfPizzas)
//        vc.pizzaBrain.saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        let viewController = self.window?.rootViewController as! ViewController
//                viewController.grabData()
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(pizzaBrain.saveData),
//            name: NSNotification.Name.UIApplicationDidBecomeActive,
//            object: nil)
//        print("Saved")
//        print(vc.pizzaBrain.numOfPizzas)
//        vc.pizzaBrain.saveData()
    }

}

