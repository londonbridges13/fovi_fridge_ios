//
//  Full_Food_VC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.

import UIKit
import RealmSwift
import Foundation


class Full_Food_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeFoodValue, SetExpirationDelegate {

    
    var fooditem = FoodItem()
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var doneView: UIView!
    
    var cells = [1,2,3,4]
    var dtint : UIView?
    var set_expire_view : Set_Expiration_Alert?
    
    
    // Color Options
    var use_color : UIColor?
    
    var color_array = [UIColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.roundCorners([.BottomRight, .BottomLeft], radius: 18)
        self.doneView.roundCorners([.BottomRight, .BottomLeft], radius: 18)
        self.view.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self

        self.random_Color()
        
        check_for_walkthrough()
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
//            let realm = try! Realm()
//            var useer = realm.objects(UserDetails).first
//            print(useer)
//            var today = NSDate()
//            var exipartion = Double(useer!.expiration_warning) * 86400
//            var warning_date = today.dateByAddingTimeInterval(-1 * exipartion)
//            print(warning_date)
//            
//            self.display_set_expiration()
//            self.display_daysleft()
//            self.display_expiration_walkthrough()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
        // Going to make a func that determines how many cells are used
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell : FullFoodCell1 = tableView.dequeueReusableCellWithIdentifier("fvcell1", forIndexPath: indexPath) as! FullFoodCell1
            
            cell.foodBackGroungView.layer.shadowOpacity = 0.7
            cell.foodBackGroungView.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            cell.expireButton.addTarget(self, action: "display_set_expiration", forControlEvents: .TouchUpInside)
            
            if self.use_color != nil{
                cell.backgroundColor = use_color!
                cell.setBackGroundColor(use_color!)
            }else{
                print("No Tableview")
            }
            if self.fooditem.image != nil{
                cell.food_image = UIImage(data: self.fooditem.image!)!
                cell.foodImageView.image = UIImage(data: self.fooditem.image!)!
            }else{
                print("NO PICTURE OF FOOD")
            }
            
            if self.fooditem.title != nil{
                cell.food_title = self.fooditem.title!
                cell.foodLabel.text = self.fooditem.title!
            }
            
            
            return cell
        }else if indexPath.row == 1{
            //DaysLeft_Cell
            let cell : DaysLeft_Cell = tableView.dequeueReusableCellWithIdentifier("DaysLeft_Cell", forIndexPath: indexPath) as! DaysLeft_Cell
            
            tableView.rowHeight = 225.0
            
            if fooditem.expiration_date != nil{
                print("Expiration Date is not nil")
                let today = NSDate()
                let daysleft = fooditem.expiration_date!.timeIntervalSinceDate(today)
                print(daysleft)
                
                var daycount = (daysleft / 86400)
                daycount = round(daycount)
                let displaycount = Int(daycount)
                
                cell.daysleftLabel.text = "\(displaycount)"
                
                if Double(daycount) < 2 && Double(daycount) > 0{
                    cell.detailLabel.text = "Day Left"
                }else{
                    cell.detailLabel.text = "Days Left"
                }
            }
            
            cell.daysleftLabel.textColor = self.use_color!
            cell.detailLabel.textColor = self.use_color!
            
            return cell
        }else if indexPath.row == 2{
            let cell : FullFoodFridgeCell = tableView.dequeueReusableCellWithIdentifier("FullFoodFridgeCell", forIndexPath: indexPath) as! FullFoodFridgeCell
            
            cell.delegate = self

            if self.fooditem.fridge_amount.value != nil{
                cell.amountTX.text = "\(self.fooditem.fridge_amount.value!)"
            }
            
            return cell

        }else {//if indexPath.row == 2{
            let cell : FullFoodShoppingCell = tableView.dequeueReusableCellWithIdentifier("FullFoodShoppingCell", forIndexPath: indexPath) as! FullFoodShoppingCell
            
            cell.delegate = self

            if self.fooditem.shoppingList_amount.value != nil{
                cell.amountTX.text = "\(self.fooditem.shoppingList_amount.value!)"
            }
            
            return cell
            
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Depends on the cell
        if indexPath.row == 1{
            display_daysleft()
        }
    }
    
    
    
    
    
    
    // Change Value Delegate
    
    func change_Fridge_Amount(amount : Int){
        print("Running Fridge Delegate")
        let realm = try! Realm()
        try! realm.write{
            self.fooditem.fridge_amount.value = amount
//            self.fooditem.previously_purchased = true
        }
    }
    
    func change_Shopping_Amount(amount : Int){
        print("Running Shopping Delegate")
        let realm = try! Realm()
        try! realm.write{
            self.fooditem.shoppingList_amount.value = amount
        }
    }
    
    
    
    
    
    
    // Choose Random Color
    func random_Color(){
        
        
        let color_1 = UIColor(red: 212/255, green: 235/255, blue: 159/255, alpha: 1)
        let color_2 = UIColor(red: 170/255, green: 99/255, blue: 170/255, alpha: 1)
        let color_3 = UIColor(red: 0/255, green: 99/255, blue: 170/255, alpha: 1)
        let color_4 = UIColor(red: 206/255, green: 99/255, blue: 51/255, alpha: 1)
        let color_5 = UIColor(red: 206/255, green: 192/255, blue: 242/255, alpha: 1)
        let color_6 = UIColor(red: 255/255, green: 184/255, blue: 0/255, alpha: 1)
        let color_7 = UIColor(red: 90/255, green: 155/255, blue: 178/255, alpha: 1)
        let color_8 = UIColor(red: 237/255, green: 90/255, blue: 80/255, alpha: 1)
        let color_9 = UIColor(red: 255/255, green: 90/255, blue: 63/255, alpha: 1)
        let color_10 = UIColor(red: 51/255, green: 173/255, blue: 83/255, alpha: 1)
        let color_11 = UIColor(red: 162/255, green: 217/255, blue: 255/255, alpha: 1)
        let color_12 = UIColor(red: 0/255, green: 153/255, blue: 241/255, alpha: 1)
        let color_13 = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)
        //        let color_one = UIColor(red: /255, green: /255, blue: /255, alpha: 1)
        
        self.color_array.append(color_1)
        self.color_array.append(color_2)
        self.color_array.append(color_3)
        self.color_array.append(color_4)
        self.color_array.append(color_5)
        self.color_array.append(color_6)
        self.color_array.append(color_7)
        self.color_array.append(color_8)
        self.color_array.append(color_9)
        self.color_array.append(color_10)
        self.color_array.append(color_11)
        self.color_array.append(color_12)
        self.color_array.append(color_13)
        
        
        print(self.color_array.count)
        
        let randomFruit = color_array[Int(arc4random_uniform(UInt32(color_array.count)) + 0)]
        
        self.use_color = randomFruit
        
//        self.view.backgroundColor = use_color
        self.doneButton.backgroundColor = use_color
        tableView.backgroundColor = use_color
        
        self.tableView.reloadData()
    }
    
    
    
    
    // SET EXPIRATION ALERT
    func display_set_expiration(){
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)
        
        self.set_expire_view = storyboard?.instantiateViewControllerWithIdentifier("Set_Expiration_Alert") as! Set_Expiration_Alert
        
        set_expire_view!.fooditem = self.fooditem
        set_expire_view!.delegate = self

        let yp = self.view.frame.height / 2 - (250 / 2) - 30
        set_expire_view!.view.frame = CGRect(x: 0, y: yp, width: self.view.frame.width, height: 250)
        set_expire_view!.view.alpha = 0
        self.view.addSubview(set_expire_view!.view)
        
        set_expire_view!.view.fadeIn(duration: 0.5)
    }
    
    
    func get_fooditem(fooditem : FoodItem){
        // This is to refresh the fooditem when you update it's values from another ViewController
        let realm = try! Realm()
        
    }
    
    
    func remove_dtint(){
        self.tableView.reloadData()
        // We need to Grab the fooditem's new expiration_date because the fooditem may have changed (from the Set_Expiration_Alert), query for new fooditem and then set it for old one (self.fooditem).
        
        self.dtint?.fadeOut(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.dtint?.removeFromSuperview()
        }
    }

    // Delegate
    func remove_set_Expiration_Alert(){
        print("Delegate in Action")
        self.set_expire_view?.view.fadeOut(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.set_expire_view?.view.removeFromSuperview()
        }
        self.remove_dtint()
        
    }
    
    func displayEnterInputAlert(){
        self.set_expire_view?.view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.set_expire_view?.view.removeFromSuperview()
        }

        
        let alert = EnterInput_Alert()
        let yp = self.view.frame.height / 2 - (261 / 2) - 30
        let xp = self.view.frame.width / 2 - (187 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 187, height: 261)
        alert.fooditem = self.fooditem
        if fooditem.set_expiration.value != nil{
            alert.daysTX.text = "\(fooditem.set_expiration.value!)"
        }
        alert.doneButton.addTarget(self, action: "remove_dtint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.45)
        
        
    }
    
    
    
    // Days Left Alert
    //   DISPLAY WHEN CELL IS SELECTED
    func display_daysleft(){
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)
        
        print(fooditem)

        let alert = DaysLeft_Alert()
        let yp = self.view.frame.height / 2 - (185 / 2) - 30
        let xp = self.view.frame.width / 2 - (250 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 250, height: 185)
        alert.fooditem = self.fooditem
        if fooditem.expiration_date != nil{
            print("Expiration Date is not nil")
            let today = NSDate()
            let daysleft = fooditem.expiration_date!.timeIntervalSinceDate(today)
            print(daysleft)
            
            var daycount = (daysleft / 86400)
            daycount = round(daycount)
            alert.stepper.value = Double(daycount)
            
        }
        alert.doneButton.addTarget(self, action: "remove_dtint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.45)
    }
    
    
    
    // Expiration Walkthrough
    func check_for_walkthrough(){
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            if user!.expiration_walkthrough != true{
                display_expiration_walkthrough()
                try! realm.write({
                    user!.expiration_walkthrough = true
                })
            }
        }
    }
    
    
    func display_expiration_walkthrough(){
        // dtint
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)

        
        var alert = Food_Expiration_Walk_Alert()
        let yp = self.view.frame.height / 2 - (320 / 2) - 30
        let xp = self.view.frame.width / 2 - (230 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 230, height: 320)
        
        alert.doneButton.addTarget(self, action: "walkthrough_part2", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.45)

        
        
    }
    
    
    func walkthrough_part2(){
        var alert = Expiration_Settings_Walk_Alert()
        let yp = self.view.frame.height / 2 - (250 / 2) - 30
        let xp = self.view.frame.width / 2 - (200 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 200, height: 250)
        
//        alert.imageview.image =

        alert.doneButton.addTarget(self, action: "walkthrough_part3", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.5)

    }
    
    
    
    func walkthrough_part3(){
        // dtint
        
        var alert = Food_Expiration_Walk_Alert()
        let yp = self.view.frame.height / 2 - (320 / 2) - 30
        let xp = self.view.frame.width / 2 - (230 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 230, height: 320)
        
        alert.detailLabel.text = "We would like to notify you of expiring food when you're not using the app."
        alert.topLabel.text = "Last Thing"
        alert.imageview.image = UIImage(named: "noti_img-1")
//        alert.imageview.image = 
        
        alert.doneButton.addTarget(self, action: "ask_notification_permission", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.56)
        
    }

    
    func ask_notification_permission(){
        remove_dtint()
        
        let notiTypes : UIUserNotificationType = [UIUserNotificationType.Alert , UIUserNotificationType.Badge , UIUserNotificationType.Sound]
        
        let notiSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notiTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notiSettings)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
