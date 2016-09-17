//
//  FridgeFoodsCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/22/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

protocol SettingCategory {
    func set_cat(cat : String, color : UIColor)
}
protocol DisplayFullFoodView {
    func show_full_foodview(fooditem : FoodItem)
}

class FridgeFoodsCell: UITableViewCell, UICollectionViewDataSource,UICollectionViewDelegate {

    
    var food = [FoodItem]()
    
    // Create the Colors
    var red = UIColor(red: 228/255, green: 81/255, blue: 99/255, alpha: 1)
    var green = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    var blue = UIColor(red: 61/255, green: 175/255, blue: 241/255, alpha: 1)
    
    //More Color Options
    var purple = UIColor(red: 170/255, green: 99/255, blue: 170/255, alpha: 1)
    
    var delegate : SettingCategory?
    
    var fullfoodview_delegate : DisplayFullFoodView?
    var catColor : UIColor?
    
    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var categoryButton : UIButton!
//    var the_category : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return food.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FridgeFoodItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("FridgeFoodItem", forIndexPath: indexPath) as! FridgeFoodItemCell
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true

//        cell.quantityLabel.alpha = 0
        cell.quantityLabel.layer.cornerRadius = 11
        cell.quantityLabel.layer.masksToBounds = true

//        let lred = UIColor(red: 255/255, green: 235/255, blue: 242/255, alpha: 1)
        
        if self.food[indexPath.row].fridge_amount.value != nil{
            cell.quantityLabel.text = "\(self.food[indexPath.row].fridge_amount.value!)"
        }else{
            cell.quantityLabel.text = "0"
        }
        
        
        if self.food[indexPath.row].image != nil{
            cell.foodImage.image = UIImage(data: self.food[indexPath.row].image!)
        }
        
        if self.food[indexPath.row].title != nil{
            cell.foodLabel.text = self.food[indexPath.row].title!
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell")
        
        if let fullfoodview_delegate = fullfoodview_delegate{
            fullfoodview_delegate.show_full_foodview(self.food[indexPath.row])
        }
    }
    
    
    
    
    
    // Find FoodItems
    func get_fooditems(category : String){
        let realm = try! Realm()
//        let predicate = NSPredicate(format: "category CONTAINS '\(category)'")
        var foods = realm.objects(FoodItem).filter("ANY category.category = '\(category)'")// AND previously_purchased = \(true)")

        if foods.count != 0{
            print("Found Some FoodItems")
            for each in foods{
                self.food.append(each)
                self.collectionView.reloadData()
                print("Appended \(each.title)")
            }
        }
    }
    
    
    // Find MISSING Fooditems
    func get_missing_food(){
        let realm = try! Realm()
        var missing_foods = realm.objects(FoodItem).filter(" previously_purchased = \(true) AND fridge_amount = 0")
        
        for each in missing_foods{
            self.food.append(each)
            self.collectionView.reloadData()
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
                self.collectionView.reloadData()
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
                self.collectionView.reloadData()
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
