//
//  BasicFoodItem.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/29/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import Foundation
import UIKit



class Searchable{
    var is_category : Bool?
    var category = Category()
    var fooditem = FoodItem()
    var num_of_food = 0 // number of food that the category holds
}



class BasicFoodItem{
    
    //Basics
    var title : String?
    var image : UIImage?
    var image_url : NSURL?
    var is_basic = true
    
    //Measurements
    var measurement_type : String?
    var full_amount : Float?
    var current_amount : Float?
    
    //Groups
    var categories = [String]()
    var food_category : String? // Vegatables, Fruits, etc
    
    //Quatity
    var fridge_amount : Int?
    var shoppingList_amount : Int?
    var mylist_amount : Int?
    
    // Expiration
    var usually_expires : Int?  // Number of days until expiration //DAYS
    var fridge_usually_expires : Int?  // Number of days until expiration //DAYS
    var expiration_date : NSDate?
    var modified_date : NSDate?
    
    // Nutrition
    var food_desc : String?
    
    // Calories
    var calories : Float?
    
    //Fat
    var total_fat : Float?
    var unsaturated_fat : Float?
    var saturated_fat : Float?
    
    // Important
    var carbohydrate : Float?
    var fiber : Float?
    var protien : Float?
    
    // Vitamins & Minerals
    var vitamin_a : Float?
    var vitamin_b6 : Float?
    var vitamin_b12: Float?
    var vitamin_c : Float?
    var vitamin_d : Float?
    var vitamin_e : Float?
    var vitamin_k : Float?
    var potassium : Float?
    var sodium : Float?
    var niacin : Float?
    var folate : Float?
    var zinc : Float?
    var thiamin : Float?
    var riboflavin : Float?
    var calcium : Float?
    var magnesium : Float?
    
    // Others
    var cholesterol : Float?
    var caffeine : Float?
    var five_recipes = [String]()
    var diets = [String]()
    
    
    
    
    
    


}

