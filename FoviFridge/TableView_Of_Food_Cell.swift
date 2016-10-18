//
//  TableView_Of_Food_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 10/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class TableView_Of_Food_Cell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
// Display Section Header as well as food cells
    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var categoryButton : UIButton!
    
    // Array of all the food in the category
    var food = [FoodItem]()
    
    // Delegates for FridgeVC
    var delegate : SettingCategory?
    var fullfoodview_delegate : DisplayFullFoodView?

    // Create the Colors
    var red = UIColor(red: 228/255, green: 81/255, blue: 99/255, alpha: 1)
    var green = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    var blue = UIColor(red: 61/255, green: 175/255, blue: 241/255, alpha: 1)
    //More Color Options
    var purple = UIColor(red: 170/255, green: 99/255, blue: 170/255, alpha: 1)
    
    var catColor : UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableview.delegate = self
        tableview.dataSource = self
        categoryButton.layer.cornerRadius = 6
        categoryButton.layer.shadowOpacity = 0.7
        categoryButton.layer.shadowOffset = CGSize(width: 0, height: 2)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : FoodItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("sectionfoodcell", forIndexPath: indexPath) as! FoodItemTableViewCell
        let fooditem = self.food[indexPath.row]
        cell.foodImage.image = UIImage(data: fooditem.image!)
        cell.foodLabel.text = fooditem.title!
        cell.whiteView.layer.shadowOpacity = 0.4
        cell.whiteView.layer.shadowOffset = CGSize(width: 2, height: 2)

        if self.food[indexPath.row].fridge_amount.value != nil{
            cell.quantityLabel.text = "Amount: \(self.food[indexPath.row].fridge_amount.value!)"
        }
        
        tableView.rowHeight = 75
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell")
        if let fullfoodview_delegate = fullfoodview_delegate{
            fullfoodview_delegate.show_full_foodview(self.food[indexPath.row])
        }
    }
    
    
    
    
    // Find FoodItems
    func get_fooditems(category : String){
        let realm = try! Realm()
        //        let predicate = NSPredicate(format: "category CONTAINS '\(category)'")
        let foods = realm.objects(FoodItem).filter("ANY category.category = '\(category)'")// AND previously_purchased = \(true)")
        
        if foods.count > 0{
            print("Found Some FoodItems")
            for each in foods{
                var list = [String]()
                for cat in each.category{
                    print("\(category) ||| ")
                    list.append(cat.category)
                }
                if list.contains(category){
                    self.food.append(each) //Fooditem
                }else{
                    print("THIS LIST CONTAINS NO SUCH CATEGORY")
                }
                //                self.collectionView.reloadData()
                print("Appended \(each.title)")
                print("\(each.title) is apart of ... \(category)")
            }
            self.tableview.reloadData() // should have same effect
        }else{
            self.food.removeAll()
            self.food = []
            self.tableview.reloadData() // should have same effect
        }
    }
    
    
    // Find MISSING Fooditems
    func get_missing_food(){
        let realm = try! Realm()
        var missing_foods = realm.objects(FoodItem).filter(" previously_purchased = \(true) AND fridge_amount = 0 AND shoppingList_amount = 0")
        
        for each in missing_foods{
            self.food.append(each)
            self.tableview.reloadData()
            print("Appended MISSING ITEM: \(each.title)")
        }
    }
    
    // Find Expiring Soon
    func get_expiring_foods(){
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            var today = NSDate()
            var adjusted_days = Double(user!.expiration_warning) * 86400
            var warning_date = today.dateByAddingTimeInterval(adjusted_days)
            var expiring_foods = realm.objects(FoodItem).filter("expiration_date <= %@", warning_date).filter("expiration_date >= %@", today).filter("fridge_amount > 0")
            
            for each in expiring_foods{
                self.food.append(each)
                self.tableview.reloadData()
                print("Appended EXPIRING ITEM: \(each.title)")
            }
        }
    }
    
    
    //Find Expired Foods
    func get_expired_foods(){
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            var today = NSDate()
            var adjusted_days = Double(user!.expiration_warning) * 86400
            var warning_date = today.dateByAddingTimeInterval(adjusted_days)
            var expired_foods = realm.objects(FoodItem).filter("expiration_date <= %@", today).filter("fridge_amount > 0")
            
            for each in expired_foods{
                self.food.append(each)
                self.tableview.reloadData()
                print("Appended EXPIRED ITEM: \(each.title)")
            }
        }
    }
    
    
    
    func design_category_button(indexPath_row : Int){
        var i = indexPath_row
        
        while i > 3{
            i = i - 3
        }
        
        print("This is i : \(i)")
        if i == 0 {
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(red, forState: .Normal)
            //            catColor = red
        }else if i == 1{
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(blue, forState: .Normal)
            //            catColor = blue
        }else if i == 2{
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(green, forState: .Normal)
            //            catColor = green
        }else{
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(red, forState: .Normal)
        }
        
        self.catColor = self.categoryButton.currentTitleColor
        
    }
    
    
    
    @IBAction func selectCategory(sender: AnyObject) {
        if let delegate = self.delegate{
            delegate.set_cat(self.categoryButton.titleLabel!.text!, color: self.catColor!)
        }
    }
    
    
}
