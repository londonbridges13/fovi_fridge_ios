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
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        window?.makeKeyAndVisible()
        window?.layer.cornerRadius = 9
        window?.layer.masksToBounds = true
        
        setupSiren()
        
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
                red: 90.0/255.0, //81
                green: 155.0/255.0, //183
                blue: 178.0/255.0, //228
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
            schemaVersion: 13,
            
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
                    if oldSchemaVersion < 7{
                        var empty_fridge_walkthrough = false
                        newObject!["empty_fridge_walkthrough"] = empty_fridge_walkthrough
                    }
                    if oldSchemaVersion < 8{
                        var visit_shopping_list_walkthrough = false
                        newObject!["visit_shopping_list_walkthrough"] = visit_shopping_list_walkthrough
                    }
                    if oldSchemaVersion < 9{
                        var grocery_bag_walkthrough = false
                        newObject!["grocery_bag_walkthrough"] = grocery_bag_walkthrough
                    }
                    if oldSchemaVersion < 10{
                        var grocery_store_walkthrough = false
                        newObject!["grocery_store_walkthrough"] = grocery_store_walkthrough
                    }
                    if oldSchemaVersion < 12{
                        var launch_count = 0
                        newObject!["launch_count"] = launch_count
                        var user_invited = false
                        newObject!["user_invited"] = user_invited
                    }
                }
                //FoodItem
                migration.enumerate(FoodItem.className()) { oldObject, newObject in
                    if oldSchemaVersion < 6{
                        var is_basic = false
                        newObject!["is_basic"] = is_basic
                    }
                    if oldSchemaVersion < 11{
                        var previously_purchased = false
                        newObject!["previously_purchased"] = previously_purchased
                    }
                    if oldSchemaVersion < 13{
                        let set_expiration = RealmOptional<Int>()
                        newObject!["set_expiration"] = set_expiration
                    }
                }
            }
            
        )
        
         //Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()

        //End Realm
        
        update_launch_count()

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
        Siren.sharedInstance.checkVersion(.Immediately)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.sharedInstance.checkVersion(.Daily)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("terminated")
        let realm = try! Realm()
        let predicate = NSPredicate(format: "mylist_amount > 0")
        var all_mylist = realm.objects(FoodItem).filter(predicate)
        try! realm.write{
            for each in all_mylist{
                each.mylist_amount.value = 0
            }
        }
    }


    
    func update_launch_count(){
        let realm = try! Realm()
        var cUser = realm.objects(UserDetails).first
        if cUser != nil{
            try! realm.write({
                print("Launch Count was \(cUser!.launch_count)")
                cUser!.launch_count += 1
                print("Launch Count is now \(cUser!.launch_count)")
            })
        }
    }
    
    
    
    //Siren
    func setupSiren() {
        
        let siren = Siren.sharedInstance
        
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true
        
        // Optional - Defaults to .Option
        //        siren.alertType = .Option // or .Force, .Skip, .None
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .Option
        siren.minorUpdateAlertType = .Option
        siren.patchUpdateAlertType = .Option
        siren.revisionUpdateAlertType = .Option
        
        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
        //        siren.forceLanguageLocalization = .Russian
        
        // Required
        siren.checkVersion(.Immediately)
    }
    

}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: SirenAlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: NSError) {
        print(#function, error)
    }
    
    /**
     This delegate method is only hit when alertType is initialized to .None
     */
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print(#function, "\(message)")
    }
}

