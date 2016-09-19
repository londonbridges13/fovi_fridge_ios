//
//  ShoppingListTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


class ShoppingListTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SetExpirationDelegate {

    var food = [FoodItem]()
    var tint : UIView?
    var slfv : ShopList_FoodView?

    var cUser = UserDetails()
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addToListButton: UIButton!
    
    
    var selected_fooditem = FoodItem()
    
    var set_expire_view : Set_Expiration_Alert?
    
    var dtint : UIView?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        addToListButton.layer.cornerRadius = 3
        

//        tableView.layer.cornerRadius = 9.0
//        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        tableView.layer.borderWidth = 0.78
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.get_errands()
        
        let realm = try! Realm()
        let user = realm.objects(UserDetails).first
        
        self.cUser = user!
        
        if user?.visit_shopping_list_walkthrough == false{
            // Run Visit Shopping List Walkthrough
            self.shopping_list_walkthrough()
        }else{
            print("Already Ran Walkthrough")
        }

    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return food.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShoppingCell = tableView.dequeueReusableCellWithIdentifier("ShoppingCell", forIndexPath: indexPath) as! ShoppingCell

        var fooditem = self.food[indexPath.row]
        if fooditem.image != nil{
            cell.foodImage.image = UIImage(data: fooditem.image!)
        }
        cell.foodImage.layer.cornerRadius = 4

        cell.foodLabel.text = fooditem.title!
        
        if fooditem.shoppingList_amount.value != nil{
            cell.quantityLabel.text = "\(fooditem.shoppingList_amount.value!)"
        }else{
            cell.quantityLabel.text = ""
        }
        
        cell.quantityLabel.layer.cornerRadius = 22
        cell.quantityLabel.layer.masksToBounds = true
        
        tableView.rowHeight = 60
        // Configure the cell...

        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformWave, andDuration: 0.21)
    }

// Swipe Funtionality
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let addToFridge = UITableViewRowAction(style: .Normal, title: "Move to Fridge") { action, index in
            print("Move button tapped")
            self.move_to_fridge(self.food[indexPath.row])
//            self.update_fooditem_expiration_date(self.food[indexPath.row])
            self.tableView.beginUpdates()
            self.food.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
        var blue = UIColor(red: 0/255, green: 153/255, blue: 241/255, alpha: 1)
        addToFridge.backgroundColor = blue
        
        let remove = UITableViewRowAction(style: .Destructive, title: "Remove") { action, index in
            print("Remove button tapped")
            self.remove_item(self.food[indexPath.row])
            self.tableView.beginUpdates()
            self.food.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
        }
        remove.backgroundColor = UIColor.redColor()

        
        return [remove, addToFridge]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        // Delete Food Object from Realm
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        display_fooditem(self.food[indexPath.row])
    }
    
    
    
    
    
    
    // Get Shoppinglist
    func get_errands(){
        food.removeAll()
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "shoppingList_amount > 0")

        let s_list = realm.objects(FoodItem).filter(predicate)
        
        for each in s_list{
            print(each.title!)
            print(each)
            self.food.append(each)
        }
        tableView.reloadData()
    }
    
    
    
    
    
    // FoodView
    func display_fooditem(fooditem : FoodItem){
        add_tint()
        
        self.selected_fooditem = fooditem
        
        slfv = ShopList_FoodView()
        var xp = self.view.frame.width / 2 - (250 / 2)
        
        slfv!.frame = CGRect(x: xp, y: 50, width: 250, height: 400)
        
        slfv!.fooditem = fooditem
        slfv!.food_label.text = fooditem.title!

        let slist_amount = Double(fooditem.shoppingList_amount.value!)
        slfv!.stepper.value = slist_amount
        
        if fooditem.image != nil{
            slfv!.food_image.image = UIImage(data: fooditem.image!)
        }
        slfv!.remove_button.addTarget(self, action: "get_errands", forControlEvents: .TouchUpInside)
        slfv!.move_food_button.addTarget(self, action: "get_errands", forControlEvents: .TouchUpInside)
        slfv!.done_button.addTarget(self, action: "get_errands", forControlEvents: .TouchUpInside)

        // Remove tint 
        slfv!.remove_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        slfv!.move_food_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        slfv!.done_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        slfv!.move_food_button.addTarget(self, action: "pre_set_food_expiration", forControlEvents: .TouchUpInside)
        slfv!.expireButton.addTarget(self, action: "pre_display_set_expiration", forControlEvents: .TouchUpInside)
        
        slfv!.alpha = 0
        slfv!.fadeIn(duration: 0.3)

        view.addSubview(slfv!)
    }
    
    
    
    // Tint
    func add_tint(){
        self.tint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tint!.backgroundColor = UIColor.blackColor()
        self.tint!.alpha = 0.4
        view.addSubview(self.tint!)
    }
    func remove_tint(){
        print("Removing Tint")
        self.tint!.fadeOut()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tint!.alpha = 0
            if self.slfv?.alpha == 1{
                self.slfv!.removeFromSuperview()
            }
        }
    }
    
    
    
    func remove_item(fooditem : FoodItem){
        let realm = try! Realm()
        
        try! realm.write {
            print("ShoppingList was = \(fooditem.shoppingList_amount.value)")

            fooditem.shoppingList_amount.value = 0
            
            print("ShoppingList now = \(fooditem.shoppingList_amount.value)")
        }
        print(fooditem)
    }
    
    func move_to_fridge(fooditem : FoodItem){
        let realm = try! Realm()
        
        self.selected_fooditem = fooditem
        
        try! realm.write {
            print("Fridge was = \(fooditem.fridge_amount.value)")

            fooditem.previously_purchased = true
            
            if fooditem.fridge_amount.value != nil{
                let quantity = fooditem.shoppingList_amount.value! + fooditem.fridge_amount.value!
                fooditem.fridge_amount.value = quantity
                print("Fridge now = \(fooditem.fridge_amount.value)")
            }else{
                fooditem.fridge_amount.value = fooditem.shoppingList_amount.value
                print("Fridge now = \(fooditem.fridge_amount.value)")
            }
            print("ShoppingList was = \(fooditem.shoppingList_amount.value)")

            fooditem.shoppingList_amount.value = 0
            print("ShoppingList now = \(fooditem.shoppingList_amount.value)")
        }
        print(fooditem)
        check_oldnew_fooditem_date(fooditem)
    }
    
    
    
    
    
    // Walkthrough
    func shopping_list_walkthrough(){
        // Display Alert 1 with Grocery Bag_ Alert1
        
        self.add_tint()
        UIView.animateWithDuration(0.3) {
            self.tint?.backgroundColor = UIColor.blackColor()
        }
        
        var alert = GroceryBagWalk_1()
        alert.bodyLabel.text = "Here you can: \n • Review your Shopping List \n •  Add/Remove food items from your list \n • And Move food items to your Fridge "
        alert.headLabel.text = "Welcome to your Shopping List"
        let xpp = self.view.frame.width / 2 - (200 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 200, height: 250)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "walkthrough_part2", forControlEvents: .TouchUpInside)
    }

    
    func walkthrough_part2(){
        UIView.animateWithDuration(0.3) {
            self.tint?.backgroundColor = UIColor.blackColor()
        }
        // Display Alert 2
        var alert = GroceryStore_Alert4()
        alert.justLabel.alpha = 0
        alert.bodyLabel.text = "To Add Food to your shopping list, Tap:"
        alert.finishButton.alpha = 0
        alert.createButton.alpha = 0
        let xpp = self.view.frame.width / 2 - (300 / 2)
        alert.frame = CGRect(x: xpp, y: 100, width: 300, height: 200)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.groceriesButton.alpha = 1
        alert.groceriesButton.layer.cornerRadius = 3
        alert.fadeIn(duration: 0.3)
        alert.okayButton.addTarget(self, action: "done_walkthrough", forControlEvents: .TouchUpInside)
        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
    }
    
    
    func done_walkthrough(){
        print("Done with Visit Shopping List Walkthrough")
        
        let realm = try! Realm()
        try! realm.write({ 
            self.cUser.visit_shopping_list_walkthrough = true
        })
    }
    
    
    
    
    // Updating Fooditem Expiration
    
    func update_fooditem_expiration_date(each : FoodItem){
        print("running update expiration")
        var today = NSDate()
        var setvalue = Double(each.set_expiration.value!)
        let added_days = setvalue * 86400
        let new_date = today.dateByAddingTimeInterval(added_days)
        print("\(each.title!) expiration date was updated from \(each.expiration_date)")
        print("to \(new_date)")
        let realm = try! Realm()
        try! realm.write({
            each.expiration_date = new_date
        })
    }
    
    // run the other update out of this one, should be smooth
    func check_oldnew_fooditem_date(each : FoodItem){
        let realm = try! Realm()
        try! realm.write({
            if each.set_expiration.value == nil{
                print("nil set expiration")
                self.set_food_expiration(each)
            }else{
                // just run other update
                print("not nil set expiration")
                self.update_fooditem_expiration_date(each)
            }
        })
        //update_fooditem_expiration_date(each)
    }
    

    
    
    // Set Expiration Alert
    
    func pre_set_food_expiration(){
        var fooditem = self.selected_fooditem
        if fooditem.set_expiration.value == nil{
            set_food_expiration(fooditem)
        }else{
            update_fooditem_expiration_date(fooditem)
        }
    }
    func set_food_expiration(fooditem : FoodItem){
        //display set_expiration Alert
        //send fooditem over
        
        let realm = try! Realm()
        print("Searching Realm for \(fooditem.title!)")
        let predicate = NSPredicate(format: "title = '\(fooditem.title!)' AND is_basic = \(fooditem.is_basic)")
        var same_food = realm.objects(FoodItem).filter(predicate).first
        print("We have this item \(same_food?.title)")
        
        if same_food?.set_expiration.value == nil{
            // No fooditem, display set ex_alert
            
            display_set_expiration(same_food!)
        }else if same_food == nil{
            display_set_expiration(fooditem)
        }else{
            update_fooditem_expiration_date(fooditem)
        }
        
        if same_food?.expiration_date == nil && same_food?.set_expiration.value != nil{
            update_fooditem_expiration_date(same_food!)
        }
        if fooditem.expiration_date == nil && fooditem.set_expiration.value != nil{
            update_fooditem_expiration_date(fooditem)
        }
    }

    
    
    // SET EXPIRATION ALERT
    func pre_display_set_expiration(){
        // For the expireButton in the ShopList_FoodView
        display_set_expiration(self.selected_fooditem)
    }
    func display_set_expiration(fooditem : FoodItem){
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)
        
        self.set_expire_view = storyboard?.instantiateViewControllerWithIdentifier("Set_Expiration_Alert") as! Set_Expiration_Alert
        
        set_expire_view!.fooditem = fooditem
        set_expire_view!.delegate = self
        
        let yp = self.view.frame.height / 2 - (250 / 2) - 30
        set_expire_view!.view.frame = CGRect(x: 0, y: yp, width: self.view.frame.width, height: 250)
        set_expire_view!.view.alpha = 0
        self.view.addSubview(set_expire_view!.view)
        
        set_expire_view!.view.fadeIn(duration: 0.5)
    }
    
    
    func remove_dtint(){

        self.dtint?.fadeOut(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.dtint?.removeFromSuperview()
//            let realm = try! Realm()
//            let predicate = NSPredicate(format: "title = '\(self.selected_fooditem.title!)' AND is_basic = \(self.selected_fooditem.is_basic)")
//            var same_food = realm.objects(FoodItem).filter(predicate).first
//            self.update_fooditem_expiration_date(same_food!)
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
        var fooditem = self.selected_fooditem
        
        self.set_expire_view?.view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.set_expire_view?.view.removeFromSuperview()
        }
        
        
        let alert = EnterInput_Alert()
        let yp = self.view.frame.height / 2 - (261 / 2) - 30
        let xp = self.view.frame.width / 2 - (187 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 187, height: 261)
        alert.fooditem = fooditem
        if fooditem.set_expiration.value != nil{
            alert.daysTX.text = "\(fooditem.set_expiration.value!)"
        }
        alert.doneButton.addTarget(self, action: "remove_dtint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.45)
        
        
    }
    
    
    

    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc: ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
        vc.segueStick = "shopping"
    }
    
    
    
    
    
    
    
    @IBAction func unwindToShopList(segue: UIStoryboardSegue){
        print("Unwind to ShoppingListVC")
        // Add mylist groceries to shoppingList, mylist = 0
        
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "mylist_amount > 0")
        let all_items = realm.objects(FoodItem).filter(predicate)
        
        try! realm.write{
            for each in all_items{
                // add value to slist_amount, set mylist = 0
                print("Adding \(each.mylist_amount.value) \(each.title) to Shopping list")
                if each.shoppingList_amount.value == nil{
                    each.shoppingList_amount.value = each.mylist_amount.value
                }else{
                    var quantity = each.shoppingList_amount.value! + each.mylist_amount.value!
                    each.shoppingList_amount.value = quantity
                }
                each.mylist_amount.value = 0
            }
        }
        
        self.get_errands()
        
        
    }


}
