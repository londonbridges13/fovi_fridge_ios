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
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var expiration_warning : Int?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        window?.makeKeyAndVisible()
        window?.layer.cornerRadius = 9
        window?.layer.masksToBounds = true
        
        setupSiren()
        wake_up_server()
        
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
            schemaVersion: 17,
            
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
                    if oldSchemaVersion < 15{
                        var expiration_warning = 6
                        newObject!["expiration_warning"] = expiration_warning
                    }
                    if oldSchemaVersion < 16{
                        var rated_version = ""
                        newObject!["rated_version"] = rated_version
                    }
                    if oldSchemaVersion < 17{
                        var expiration_walkthrough = false
                        newObject!["expiration_walkthrough"] = expiration_walkthrough
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
                    if oldSchemaVersion < 14{
                        var expiration_warning = 6
                        newObject!["expiration_warning"] = expiration_warning
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
        expiring_food_notifications()
        
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


    
    
    
    
    func expiring_food_notifications(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        print("Removing all Local Notifications")
        
        let realm = try! Realm()
        var today = NSDate()
        var user = realm.objects(UserDetails).first
        if user != nil{
            var adjusted_days = Double(user!.expiration_warning) * 86400
            var warning_date = today.dateByAddingTimeInterval(adjusted_days)
            print("This is expiring warning date: \(warning_date)")
            
            var foods = realm.objects(FoodItem).filter("expiration_date >= %@", warning_date).filter("fridge_amount > 0")
            // setting a notification for all foods in fridge
            for each in foods{
                if each.expiration_date != nil{
                    quirkie_Notification(each)
                }
            }
        }
    }
    
    func quirkie_Notification(each : FoodItem){
        var usable_array = [String]()
        let vowels = ["a","e","i","o","u","A","E","I","O","U"]
        let bread = "Bread"
        
        // Arrays for Phrases
        let ends_with_es_array = ["Your \(each.title!) are close to expiration.", "Don't \(each.title!) sound good right about now? Hope so, they won't be good for much longer"]
        let doesnt_end_with_es_array = ["Your \(each.title!) is close to expiration.", "Doesn't \(each.title!) sound good right about now? Hope so, they won't be good for much longer.","How is your \(each.title!) looking?"]
        let ends_with_only_s_array = ["How are your \(each.title!) looking?"]
        let starts_with_vowel_array = [""]
        let contains_bread_array = ["Your \(each.title!) is starting to go stale."]
        let apple_array = ["Apple for your thoughts. Think fast, these apples are going bad."]
        let peach_array = ["Your Peaches aren't looking so Peachy. Use em' before ya lose em'"]
        let all_array = [""]
        
        // all foods
//        for phrase in all_array{
//            usable_array.append(phrase)
//        }
        
        //starts with a vowel
//        let vowel : String = "\(each.title!.characters.first)"
//        if vowels.contains(vowel){
//            for phrase in starts_with_vowel_array{
//                usable_array.append(phrase)
//            }
//        }
        
        //contains the word bread
        if each.title!.containsString(bread){
            for phrase in contains_bread_array{
                usable_array.append(phrase)
            }
        }
        
        // Apple phrases
        if each.title == "Apples"{
            for phrase in apple_array{
                usable_array.append(phrase)
            }
        }
        
        // Peach phrases
        if each.title == "Peaches"{
            for phrase in peach_array{
                usable_array.append(phrase)
            }
        }
        
        
        //ends with es
        if each.title!.hasSuffix("es"){
            for phrase in ends_with_es_array{
                usable_array.append(phrase)
            }
        }else if each.title!.hasSuffix("s"){
            for phrase in ends_with_only_s_array{
                usable_array.append(phrase)
            }
        }else{
            // doesn't end with es
            for phrase in doesnt_end_with_es_array{
                usable_array.append(phrase)
            }
        }
        
        
        // Randomly choose a Phrase
        let randomPhrase = usable_array[Int(arc4random_uniform(UInt32(usable_array.count)) + 0)]
        // Set Notification
        set_notification(randomPhrase, expiration: each.expiration_date!)
    }
    
    
    func set_notification(message: String, expiration: NSDate){
        
        //
        
        if self.expiration_warning != nil{
            // Go ahead, set the date
            let adjusted_time = Double(self.expiration_warning!) * 86400
            let warning_date = expiration.dateByAddingTimeInterval(-1 * adjusted_time)
            fire_local_notification(warning_date, message: message)
        }else{
            // Get UserDetails.expiration_warning, set it to self
            let realm = try! Realm()
            var user = realm.objects(UserDetails).first
            if user != nil {
                self.expiration_warning = user?.expiration_warning
                let adjusted_time = Double(self.expiration_warning!) * 86400
                let warning_date = expiration.dateByAddingTimeInterval(-1 * adjusted_time)
                fire_local_notification(warning_date, message: message)
            }
        }
    }
    
    
    func fire_local_notification(fire_date: NSDate, message: String){
        
        var notification : UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        var today = NSDate()
        
        notification.fireDate = fire_date//firedate//fire_date
        notification.timeZone = NSTimeZone.localTimeZone()

        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print("\(fire_date) \n \(message) \n\n")
    }
    
    
    
    
    
    
    func wake_up_server() {//https://beautiful-grand-canyon-88320.herokuapp.com/api/v1/users
        var queue = NSOperationQueue()
        
        queue.addOperationWithBlock { () -> Void in
            // Background Here
            
            Alamofire.request(.GET, "https://rocky-fjord-88249.herokuapp.com/api/v1/basic_food_items").responseJSON { (response) in
                print("Waking Up Server")
                print(response.result.value)
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

