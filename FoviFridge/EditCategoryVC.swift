//
//  EditCategoryVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/10/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class EditCategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, RemoveFoodItem {

    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var doneView : UIView!
    @IBOutlet var deleteButton : UIButton!
    @IBOutlet var catLabel : UILabel! 
    
    @IBOutlet var segueButton : UIButton!

    
    var cells = [1,2,3,4,5]
    
    var red = UIColor(red: 237, green: 90, blue: 80, alpha: 1)
    
    var food = [FoodItem]()
    
    var category : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(category)
        
        tableview.delegate = self
        tableview.dataSource = self
        

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
        for each in all_cat_food{
            print("\(each.title!)")
            self.food.append(each)
            
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.tableview.reloadData()
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
            fooditem.category.removeAtIndex(fooditem.category.indexOf(it!)!)
            self.food.removeAtIndex(indexRow - 1)
            
            let index = NSIndexPath(forRow: indexRow, inSection: 0)
            tableview.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Fade)

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