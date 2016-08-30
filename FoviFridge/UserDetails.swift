//
//  UserDetails.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/20/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class Allergy: Object {
    dynamic var title: String? // Title of Allergy
}

class SurveyQuestions: Object {
    dynamic var id : String? // This is id of the Survey Question
}

class UserDetails: Object {
    // Basic, Login
    dynamic var name: String?
    dynamic var email: String?
    dynamic var password: String?
    
    // Allergies
    let allergies = List<Allergy>()
    
    
    // Survey Details
    dynamic var last_checked : NSDate? = nil // date when last checked survey in fridgeVC
    let survey_questions_answered = List<SurveyQuestions>()
    dynamic var the_last_answered: NSDate? = nil // Use this date to check if user has asnswered a question today

    dynamic var paid_for_removeSurvey = false // True, remove Survey Questions
    
    
    // Paid
    dynamic var paid_for_customBFI = false // True, user able to change the BFI: expire date, low-warning point, etc
    dynamic var paid_for_organizeFridge = false // True, user is able to customize the order of his fridge
    dynamic var paid_for_nutrition = false // True, connects the Nutrition of the food products to app
    
    
    
    // Walkthrough
    dynamic var empty_fridge_walkthrough = false
    dynamic var visit_shopping_list_walkthrough = false
    dynamic var grocery_bag_walkthrough = false
    dynamic var grocery_store_walkthrough = false
    
    
    
    
    // dont use
    dynamic var last_answered = NSDate()
    var last_time_answered : NSDate?
    var paid_removeSurvey : Bool? // True, remove Survey Questions
    // Paid
    var paid_customBFI : Bool? // True, user able to change the BFI: expire date, low-warning point, etc
    var paid_organizeFridge : Bool? // True, user is able to customize the order of his fridge
    var paid_nutrition : Bool? // True, connects the Nutrition of the food products to app
    // dont use above
    
    
//    dynamic var password: String?
//    dynamic var password: String?
    
}


