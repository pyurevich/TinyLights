//
//  AppDelegate.swift
//  TinyLights
//
//  Created by Pavel Yurevich on 3/4/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 73.0/255.0, green: 177.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let prefs = NSUserDefaults.standardUserDefaults()
//        let rem = prefs.boolForKey("remember")
//        let viewCtrl = self.window?.rootViewController as! ViewController
//        let current = viewCtrl.storyAudio.currentTime
//        if rem {
//            print(1)
//            prefs.setValue(current, forKey: "lastPos")
//        } else {
//            print(2)
//            prefs.removeObjectForKey("lasPos")
//        }
//        prefs.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let prefs = UserDefaults.standard
        //let rem = prefs.boolForKey("remember")
        let viewCtrl = self.window?.rootViewController as! MainViewController
        let current = viewCtrl.storyAudio.currentTime
        let currentStory = viewCtrl.currentStory
        //print(rem)
        //if rem {
        prefs.setValue(current, forKey: "lastPos")
        prefs.set(currentStory, forKey: "lastStory")
        //print("Saved!")
        //} else {
        //    prefs.removeObjectForKey("lasPos")
        //}
        prefs.synchronize()
        
        
    }


}

