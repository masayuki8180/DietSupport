//
//  AppDelegate.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SKStoreProductViewControllerDelegate {
    
    enum CameraMode {
        case menuCamera
        case dayWorkout
    }
    
    var window: UIWindow?
    var dbService: DBService = DBService()
    var menuT: MenuT = MenuT()
    var selectedMenuT: MenuT = MenuT()
    var selectedDayWorkOutT: DayWorkOutT = DayWorkOutT()
    var selectedDay: String = String()
    var menuList = NSMutableArray(array: [])
    var viewC: ViewController!
    var calviewController: CalViewController!
    var workoutKekkaSenimoto: Int = 0
    var cloudmenuList = NSMutableArray(array: [])
    var workoutKekkaVC: WorkoutKekkaViewController!
    var menuSelectVC: MenuSelectViewController!
    var cameraMode: CameraMode = .menuCamera
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dbService.initDatabase()
        CloudSync.chkVersion()
        CloudSync.getCategory()
        UINavigationBar.appearance().tintColor = UIColor(red:ConstStruct.main_title_color_red , green:ConstStruct.main_title_color_green, blue:ConstStruct.main_title_color_blue,alpha:1.0)
        //ナビゲーションバーの背景を変更
        UINavigationBar.appearance().barTintColor = UIColor(red:ConstStruct.main_color_red , green:ConstStruct.main_color_green, blue:ConstStruct.main_color_blue,alpha:1.0)
        //ナビゲーションのタイトル文字列の色を変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:ConstStruct.main_title_color_red , green:ConstStruct.main_title_color_green, blue:ConstStruct.main_title_color_blue,alpha:1.0)]
        
        
        //現在のノーティフケーションを削除
        UIApplication.shared.cancelAllLocalNotifications()
        
        //Notification設定
        let type : UIUserNotificationType = [.alert, .badge, .sound]
        let setting = UIUserNotificationSettings(types: type, categories: nil)
        application.registerUserNotificationSettings(setting)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        CloudSync.chkVersion()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

