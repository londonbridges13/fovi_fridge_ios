//
//  FridgeFoodsCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/22/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class FridgeFoodsCell: UITableViewCell, UICollectionViewDataSource,UICollectionViewDelegate {

    
    var food = [FoodItem]()
    
    // Create the Colors
    var red = UIColor(red: 228/255, green: 81/255, blue: 99/255, alpha: 1)
    var green = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    var blue = UIColor(red: 61/255, green: 175/255, blue: 241/255, alpha: 1)
    
    //More Color Options
    var purple = UIColor(red: 170/255, green: 99/255, blue: 170/255, alpha: 1)
    
    
    
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
//        cell.layer.cornerRadius = 12

        if self.food[indexPath.row].image != nil{
            cell.foodImage.image = UIImage(data: self.food[indexPath.row].image!)
        }
        
        if self.food[indexPath.row].title != nil{
            cell.foodLabel.text = self.food[indexPath.row].title!
        }
        
        return cell
    }

    
    
    
    
    
    
    // Find FoodItems
    func get_fooditems(category : String){
        let realm = try! Realm()
//        let predicate = NSPredicate(format: "category CONTAINS '\(category)'")
        var foods = realm.objects(FoodItem).filter("ANY category.category = '\(category)'")

        if foods.count != 0{
            print("Found Some FoodItems")
            for each in foods{
                self.food.append(each)
                self.collectionView.reloadData()
                print("Appended \(each.title)")
            }
        }
    }
    
    
    
    
    func design_category_button(indexPath_row : Int){
        var i = indexPath_row
        
        while i > 3{
            i -= 3
        }
        
        print("This is i : \(i)")
        if i == 0 {
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(red, forState: .Normal)
        }
        if i == 1{
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(blue, forState: .Normal)
        }
        if i == 2{
            print("This is i : \(i)")
            self.categoryButton.setTitleColor(green, forState: .Normal)
        }
    }
    
    
    
    
    
    

}
