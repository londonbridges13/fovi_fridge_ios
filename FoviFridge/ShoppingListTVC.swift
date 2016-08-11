//
//  ShoppingListTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


class ShoppingListTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var food = [FoodItem]()
    var tint : UIView?
    var slfv : ShopList_FoodView?

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addToListButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        addToListButton.layer.cornerRadius = 6
        
        self.get_errands()

//        tableView.layer.cornerRadius = 9.0
//        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        tableView.layer.borderWidth = 0.78
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    

// Swipe Funtionality
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let addToFridge = UITableViewRowAction(style: .Normal, title: "Move to Fridge") { action, index in
            print("Move button tapped")
            self.move_to_fridge(self.food[indexPath.row])
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

        slfv!.alpha = 0
        slfv!.fadeIn(duration: 0.3)

        view.addSubview(slfv!)
    }
    
    
    
    // Tint
    func add_tint(){
        self.tint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tint!.backgroundColor = UIColor.whiteColor()
        self.tint!.alpha = 0.4
        view.addSubview(self.tint!)
    }
    func remove_tint(){
        print("Removing Tint")
        self.tint!.fadeOut()
        self.tint!.alpha = 0
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.slfv!.removeFromSuperview()
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
        
        
        try! realm.write {
            print("Fridge was = \(fooditem.fridge_amount.value)")

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
