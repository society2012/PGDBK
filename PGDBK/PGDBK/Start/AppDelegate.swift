//
//  AppDelegate.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import DrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    var drawerController:DrawerController?

    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootVC = RootViewController()
        
        let rootNavi = MainNaviController(rootViewController: rootVC)
        
        let leftVC = LeftViewController(nibName: "LeftViewController", bundle: nil)
        
        let leftNavi = MainNaviController(rootViewController: leftVC)
        
        self.drawerController = DrawerController(centerViewController: rootNavi, leftDrawerViewController: leftNavi)
        self.drawerController?.showsShadows = true
        self.drawerController?.maximumLeftDrawerWidth = kScreenW - 100
        self.drawerController?.openDrawerGestureModeMask = .all
        self.drawerController?.closeDrawerGestureModeMask = .all
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.drawerController?.drawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) in
            let block = ExampleDrawerVisualStateManager.sharedManager.drawerVisualStateBlock(for: drawerSide)
            block?(drawerController, drawerSide, percentVisible)
        }
        self.window?.rootViewController = self.drawerController

        
        return true
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

