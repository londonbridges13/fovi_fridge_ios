//
//  ShopList_FoodView.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/10/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift


class ShopList_FoodView: UIView {

  
    var view: UIView!
    
    @IBOutlet var food_image: UIImageView!
    
    @IBOutlet var food_label: UILabel!
    
    @IBOutlet var stepper: GMStepper!
    
    
    @IBOutlet var move_food_button: UIButton!
    
    
    @IBOutlet var remove_button: UIButton!

    
    @IBOutlet var done_button: UIButton!

    
    var fooditem = FoodItem()
    
    
    
    
    
    
    func save_amount(){
        let realm = try! Realm()
        print("Saving as \(Int(stepper.value)) \(fooditem.title!)")
        
        try! realm.write {
            fooditem.shoppingList_amount.value = Int(stepper.value)
        }
        fadeAway()
    }
    
    
    
    
    
    
    func remove_item(){
        let realm = try! Realm()
        
        try! realm.write {
            print("ShoppingList was = \(fooditem.shoppingList_amount.value)")
            
            fooditem.shoppingList_amount.value = 0
            
            print("ShoppingList now = \(fooditem.shoppingList_amount.value)")
        }
        print(fooditem)
        fadeAway()
    }
    
    
    
    
    func move_to_fridge(){
        let realm = try! Realm()
        
        
        try! realm.write {
            print("Fridge was = \(fooditem.fridge_amount.value)")
            
            if fooditem.fridge_amount.value != nil{
                let value = Int(stepper.value)
                let quantity = value + fooditem.fridge_amount.value!
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

        fadeAway()
    }
    
    
    
    
    func fadeAway(duration duration: NSTimeInterval = 0.3) {
        view
            .animate(0.5)
            .frame(CGRect(x: 0, y: 150, width: 250, height: 400))
            .scale(0.8)
            .alpha(0)
    }

    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        move_food_button.layer.cornerRadius = 6
        remove_button.layer.cornerRadius = 6
        done_button.layer.cornerRadius = 4
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
        
        done_button.addTarget(self, action: "save_amount", forControlEvents: .TouchUpInside)
        
        remove_button.addTarget(self, action: "remove_item", forControlEvents: .TouchUpInside)
        move_food_button.addTarget(self, action: "move_to_fridge", forControlEvents: .TouchUpInside)
        

        

        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ShopList_FoodView", bundle: bundle)
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
