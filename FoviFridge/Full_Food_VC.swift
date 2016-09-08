//
//  Full_Food_VC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class Full_Food_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeFoodValue, SetExpirationDelegate {

    
    var fooditem = FoodItem()
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var doneView: UIView!
    
    var cells = [1,2,3]
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
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.display_set_expiration()
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
        self.set_expire_view = storyboard?.instantiateViewControllerWithIdentifier("Set_Expiration_AlertVC") as! Set_Expiration_Alert
        
        let yp = self.view.frame.height / 2 - (250 / 2) - 30
        set_expire_view!.view.frame = CGRect(x: 0, y: yp, width: self.view.frame.width, height: 250)
        set_expire_view!.view.alpha = 0
        self.view.addSubview(set_expire_view!.view)
        
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)

        set_expire_view!.view.fadeIn(duration: 0.5)
    }
    
    
    func remove_dtint(){
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
