//
//  FoodItem.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/27/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    dynamic var category = ""
}


// version 1
class FoodItem: Object {

    //Basics
    dynamic var title : String? = nil
    dynamic var image : NSData? = nil
    dynamic var image_url : String? = nil
    dynamic var is_basic = false   // false by default
    dynamic var previously_purchased = false
    
    //Measurements
    dynamic var measurement_type : String? = nil
    let full_amount = RealmOptional<Float>()
    let current_amount = RealmOptional<Float>()
    
    //Groups
    let category = List<Category>() // User created catagories as well as foodcategory
    dynamic var food_category : String? = nil // Vegatables, Fruits, etc
    
    //Quatity
    let fridge_amount = RealmOptional<Int>()
    let shoppingList_amount = RealmOptional<Int>()
    let mylist_amount = RealmOptional<Int>()
    
    // Expiration
    let usually_expires = RealmOptional<Int>()  // Number of days until expiration //DAYS
    let fridge_usually_expires = RealmOptional<Int>()  // Number of days until expiration //DAYS
    dynamic var expiration_date : NSDate? = nil
    dynamic var modified_date : NSDate? = nil
    
    // Nutrition
    dynamic var food_desc : String? = nil
    
}
