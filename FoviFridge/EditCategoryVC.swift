//
//  EditCategoryVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/10/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class EditCategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, RemoveFoodItem, UITextFieldDelegate, ChangeTitleCategory {

    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var doneView : UIView!
    @IBOutlet var deleteButton : UIButton!
    @IBOutlet var catLabel : UILabel! 
    
    @IBOutlet var segueButton : UIButton!
    @IBOutlet var changeTitleButton : UIButton!
    @IBOutlet var unwindToFridgeButton : UIButton!

    
    var dtint : UIView?
    
    var cells = [1,2,3,4,5]
    
    var red = UIColor(red: 237, green: 90, blue: 80, alpha: 1)
    
    var food = [FoodItem]()
    
    var category : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(category)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        self.deleteButton.addTarget(self, action: "delete_whole_category", forControlEvents: .TouchUpInside)

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
        return 1 + food.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell : edit_cell_1 = tableView.dequeueReusableCellWithIdentifier("edit1", forIndexPath: indexPath) as! edit_cell_1
            cell.addFood_Button.addTarget(self, action: "from_cellHere", forControlEvents: .TouchUpInside)
            if self.category != nil{
                cell.categoryField!.text = self.category!
            }
            cell.delegate = self
            tableView.rowHeight = 246
            
            return cell
        }else{
            let cell : EditFoodItemCell = tableView.dequeueReusableCellWithIdentifier("EditFoodItemCell", forIndexPath: indexPath) as! EditFoodItemCell
            
            var fooditem = self.food[indexPath.row - 1]
            
            cell.foodImage.image = UIImage(data: fooditem.image!)
            cell.foodLabel.text = fooditem.title!
            cell.fooditem = fooditem
            cell.indexpath = indexPath.row
            cell.remove_delegate = self
            tableView.rowHeight = 65
            
            return cell
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        // Delete Food Object from Realm
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 246
        }else{
            return 65
        }
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//
//    }
    
    
    
    
    
    
    
    func get_cat_food(cat : String){
        self.food.removeAll()
        
        self.category = cat
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "ANY category.category CONTAINS[c] %@", cat)
        var all_cat_food = realm.objects(FoodItem).filter(predicate)
        if all_cat_food.count > 0{
            for each in all_cat_food{
                
                var list = [String]()
                for a_cat in each.category{
                    print("\(category) ||| ")
                    list.append(a_cat.category)
                }
                if list.contains(cat){
                    self.food.append(each) //Fooditem
                }else{
                    print("THIS LIST CONTAINS NO SUCH CATEGORY")
                }
                
            }
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.tableview.reloadData()
            }
        }else{
            self.food.removeAll()
            self.food = []
        }
    }
    
    
    
    
    
    // Remove Fooditem from Category
    func delete_fooditem(fooditem : FoodItem, indexRow : Int){
        print("Removing \(fooditem.title!)")
        print("From \(category!)")
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "category = '\(category!)'")
        let it = fooditem.category.filter(predicate).first
        
        print(it)
        
        try! realm.write {
            print("Removed \(it!.category)")
            print(fooditem.category.indexOf(it!))
            
            var op1 = indexRow - 1
            var op2 = indexRow
            print("OPTION 1 : \(food[op1])")
//            print("OPTION 2 : \(food[op2])")
            
            self.food.removeAtIndex(op1)
            fooditem.category.removeAtIndex(fooditem.category.indexOf(it!)!)
            
            let index = NSIndexPath(forRow: indexRow, inSection: 0)
            tableview.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Fade)

            tableview.reloadData()
        }

        
    }
    
    
    
    
    
    // Delete Category
    func delete_whole_category(){
        print("Presenting AlertView")
        add_darktint()
        
        var alert = DeleteCategory_AlertView()
        
        let xp = self.view.frame.width / 2 - (250 / 2)
        alert.frame = CGRect(x: xp, y: 75, width: 250, height: 300)
        alert.yesButton.addTarget(self, action: "yes_delete_whole_category", forControlEvents: .TouchUpInside)
//        alert.yesButton.addTarget(self, action: "remove_darktint", forControlEvents: .TouchUpInside)
        alert.noButton.addTarget(self, action: "remove_darktint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.3)
        
        
    }
    
    
    func yes_delete_whole_category(){
        print("Deleting Category")
        
        self.view.fadeOut(duration: 0.4)
        
        actually_delete_category()
        
    }
    
    
    func actually_delete_category(){
        let realm = try! Realm()
        var all_gone = realm.objects(Category).filter(NSPredicate(format:"category = '\(self.category!)'"))
        print("This is all food labeled with this : \(all_gone.count)")
        
        try! realm.write({ 
            for each in all_gone{
                print("Deleting \(each.category)")
                realm.delete(each)
            }
        })
        self.unwindToFridgeButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    
    func add_darktint(){
        dtint = UIView()
        
        if dtint?.alpha != 0.3{
            dtint?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height)
            dtint?.backgroundColor = UIColor.blackColor()
            dtint?.alpha = 0.3
            self.view.addSubview(dtint!)
        }else{
            dtint?.fadeOut()
        }
    }
    
    func remove_darktint(){
        dtint?.fadeOut(duration: 0.2)
    }
    
    // ChangeCategoryTilte Delegate
    
    func change_cat_title(newCategory : String){
        // relabel fooditems
        
        let realm = try! Realm()
        var all_cat_food = realm.objects(Category).filter(NSPredicate(format: "category = '\(self.category!)'"))
        print("WE FOUND \(all_cat_food.count) OBJECTS")
        
        try! realm.write{
//            var new_cat = Category()
//            new_cat.category = newCategory
            for each in all_cat_food{
                print("Before: \(each.category)")
                each.category = newCategory
                print("After: \(each.category)")
            }
        }
        
        self.category = newCategory
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            // Change CategoryVC label
            self.changeTitleButton.sendActionsForControlEvents(.TouchUpInside)
            
        }
    }
    

    
    
    
    
    
    
    
    
    // Add Food Segue
    
    func from_cellHere(){
        self.segueButton.sendActionsForControlEvents(.TouchUpInside)
    }
    

    

}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}