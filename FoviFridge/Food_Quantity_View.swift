//
//  Food_Quantity_View.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/30/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift

class Food_Quantity_View: UIView {

   
    var view: UIView!
    
    @IBOutlet var food_image: UIImageView!
    
    @IBOutlet var food_label: UILabel!
    
    @IBOutlet var stepper: GMStepper!
    
    
    @IBOutlet var add_food_buttom: UIButton!
    
    
    @IBOutlet var remove_button: UIButton!
    
    
    var fooditem = FoodItem()
    var all_food_titles = [String]()
    var stepper_displays_current = false // by default
    var same_food : FoodItem?
    
    
    func pre_query(){
        let realm = try! Realm()
        print("Searching Realm for \(fooditem.title!)")
        let predicate = NSPredicate(format: "title = '\(fooditem.title!)'")
        self.same_food = realm.objects(FoodItem).filter(predicate).first
        print("We have this item \(same_food?.title)")
        if same_food != nil{
            current_amount()
            if same_food?.mylist_amount.value == 0{
                remove_button.setTitle("Cancel", forState: .Normal)
                add_food_buttom.setTitle("Add \(fooditem.title!)", forState: .Normal)
                
            }
        }
    }
    
    //Add Food Item
    func add_food_item(){
        print("Beginning to add \(food_label.text)")
        
        let realm = try! Realm()
//        let predicate = NSPredicate(format: "title = '\(self.fooditem.title)'")
//        var same_food = realm.objects(FoodItem).filter(predicate).first
        
        let quantity = Int(self.stepper.value)

        if self.same_food != nil && same_food!.title == fooditem.title && same_food!.is_basic == fooditem.is_basic{
            // If there is an object like this already saved
            print("Updating \(fooditem.title!) in Realm")
            print("GMStepper value = \(self.stepper.value)")
            print("GMStepper as an Int: \(quantity)")
            if same_food?.mylist_amount != nil{
                // Add quantity to the number
                var add_quantity : Int?
                if stepper_displays_current == false{
                    add_quantity = (same_food?.mylist_amount.value)! + quantity
                }else{
                    add_quantity = quantity
                }
                try! realm.write {
                    same_food!.mylist_amount.value = quantity
                    print("Added \(quantity) to \(fooditem.title!), it now = \(add_quantity)")
                    if same_food!.food_category == nil && fooditem.food_category != nil{
                        same_food!.food_category = fooditem.food_category!
                    }
                    print("This is the Category: \(same_food!.food_category)")
                    // Making sure that the fooditem saved has this new food_category
                    let food_category = Category() //fooditem.food_category
                    if fooditem.food_category != nil{
                        food_category.category = fooditem.food_category!
                    }
                    var i = false
                    for cat in same_food!.category{
                        if cat.category == food_category.category{
                            i = true
                        }else{print("Has This FoodCategory already")}
                    }
                    
                    if i == false{
                        self.same_food!.category.append(food_category)
                        print("Added NEW Food Category: \(food_category.category)")
                    }else{
                        //Has This FoodCategory already
                        print("Has This FoodCategory already")
                    }

                }
            }else{
                // Set quatity as the number
                try! realm.write {
                    same_food!.mylist_amount.value = quantity
                    print("Added \(quantity) to \(fooditem.title!), it now = \(fooditem.mylist_amount.value!)")
                }
            }
        }else{
            // If there is no object like this already saved
            print("Creating new Food Item Called: \(fooditem.title!)")
            fooditem.mylist_amount.value = quantity
            try! realm.write {
                var food_category = Category() //fooditem.food_category
                food_category.category = fooditem.food_category!
                self.fooditem.category.append(food_category)
                print("Added NEW Food Category: \(food_category.category)")

                realm.add(self.fooditem)
                print("Created \(fooditem), and the quantity = \(fooditem.mylist_amount.value)")
                print("This is the Category: \(fooditem.food_category)")
            }
        }
        // Fade Out
        fadeAway()
    }
    
    
    
    // Remove Food Item
    func remove_food_item(){
        print("Beginning to remove \(food_label.text)")
        if same_food != nil{
            let realm = try! Realm()
            try! realm.write {
                same_food?.mylist_amount.value = 0
                print("Removed item from mylist")
            }
        }
        
        
        // Fade Out
        fadeAway()
    }
    
    
    
    func fadeAway(duration duration: NSTimeInterval = 0.3) {
        view
            .animate(0.5)
            .frame(CGRect(x: 0, y: 150, width: 250, height: 400))
            .scale(0.8)
            .alpha(0)
    }
    
    
    func current_amount(){
        // Displays the current amount in holding aka in Groceries, not everywhere
        if same_food!.mylist_amount.value != nil{
            let mylist_amount = Double(same_food!.mylist_amount.value!)
            self.stepper.value = mylist_amount
            self.stepper_displays_current = true
            self.add_food_buttom.setTitle("Done", forState: .Normal)
        }else{
            // Do nothing, stepper = 0
        }
    }
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        add_food_buttom.layer.cornerRadius = 6
        remove_button.layer.cornerRadius = 6
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
        add_food_buttom.addTarget(self, action: "add_food_item", forControlEvents: .TouchUpInside)
        remove_button.addTarget(self, action: "remove_food_item", forControlEvents: .TouchUpInside)
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.pre_query()
        }

        
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Food_Quantity_View", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    

}
