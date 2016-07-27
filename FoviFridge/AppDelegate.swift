//
//  AppDelegate.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/22/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import FoldingTabBar
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.layer.cornerRadius = 9
        window?.layer.masksToBounds = true
        // TabBar
        if let tabBarController = window?.rootViewController as? YALFoldingTabBarController {
            
            tabBarController.centerButtonImage = UIImage(named: "plus_icon")
            tabBarController.tabBarView.frame = CGRect(x: 0, y: 0, width: 18, height: 50)
            tabBarController.tabBar.frame = CGRect(x: 0, y: 0, width: 18, height: 50)
            tabBarController.tabBar.frame.size = CGSize(width: 180, height: 50)
            tabBarController.tabBarView.frame.size = CGSize(width: 180, height: 50)
            tabBarController.tabBarView.tabBarViewEdgeInsets = UIEdgeInsets(top: 10, left: 72, bottom: 10, right: 72)
            
            tabBarController.tabBarViewHeight = 450
            tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
            tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
            
            tabBarController.tabBarView.backgroundColor = UIColor(
                red: 94.0/255.0,
                green: 91.0/255.0,
                blue: 149.0/255.0,
                alpha: 0
            )
            
            tabBarController.tabBarView.tabBarColor = UIColor(
                red: 81.0/255.0,
                green: 183.0/255.0,
                blue: 228.0/255.0,
                alpha: 1
            )
            
            tabBarController.tabBarView.dotColor = UIColor(
                red: 1,//0/255.0,
                green: 1,//0/255.0,
                blue: 1,//0/255.0,
                alpha: 1
            )
            
            tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
            
            let firstItem = YALTabBarItem(
                itemImage: UIImage(named: "Fridge-52")!,
                leftItemImage: nil,//UIImage(named: "grocery_icon")!,
                rightItemImage: nil//UIImage(named: "settings_icon")!
            )
            
            let secondItem = YALTabBarItem(
                itemImage: UIImage(named: "Ingredients List-52")!,
                leftItemImage: nil,
                rightItemImage: nil//UIImage(named: "settings_icon")!
            )
            
            tabBarController.leftBarItems = [firstItem]
            tabBarController.rightBarItems = [secondItem]
        }
        // End TabBar
        
        
        //Realm
        
        let config =     Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 5,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                migration.enumerate(UserDetails.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        var last_time_answered : NSDate?
                        newObject!["last_time_answered"] = last_time_answered
                    }
                    // Added newer versions here
                    if oldSchemaVersion < 2 {
                        var value = false
                        newObject!["paid_for_removeSurvey"] = value
                        newObject!["paid_for_customBFI"] = value
                        newObject!["paid_for_organizeFridge"] = value
                        newObject!["paid_for_nutrition"] = value
                    }
                    if oldSchemaVersion < 3{
                        var last_answered = NSDate()
                        newObject!["last_answered"] = last_answered
                    }
                    if oldSchemaVersion < 4{
                        var old_last_answered = oldObject!["last_answered"] as! NSDate
                        var last_answered : NSDate? = nil
                        newObject!["the_last_answered"] = last_answered
                    }
                    if oldSchemaVersion < 5{
                        var last_checked : NSDate? = nil
                        newObject!["last_checked"] = last_checked
                    }
                    
//                    migration.enumerate(FoodItem.className()) { oldObject, newObject in
//                    }
                }
            }
            
        )
        
         //Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()

        //End Realm

        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

