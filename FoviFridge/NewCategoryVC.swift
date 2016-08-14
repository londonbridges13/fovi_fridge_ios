//
//  NewCategoryVCViewController.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/6/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Material
import RealmSwift

class NewCategoryVC: UIViewController, UITextFieldDelegate {

    
    var category : String?
    var already_have = [String]()

    private var categoryField : TextField?
    
    @IBOutlet var nextButton : UIButton!
    @IBOutlet var cancelButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCatField()
        
        nextButton.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func unwindToNewCat(segue: UIStoryboardSegue){
        print("Back to New Category")
        self.labeling_food()
    }
    
    
    
    
    func check_availibilty(categoryTX : String){
        var move_on = true
        
        let realm = try! Realm()
        let all_categories = realm.objects(Category)
        for each in all_categories{
            if each.category != categoryTX{
                // Do nothing
            }else{
                // Tell user, it already exists
                print("Already have \(each.category)")
                self.categoryField?.detail = "Error, this Category already exists."
                self.categoryField?.detailLabel.fadeIn()
                move_on = false
            }

        }
        print("Done Checking")
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 600 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            if move_on == true{
                // Continue with Segue
                self.performSegueWithIdentifier("catfood", sender: self)
            }
        }

        
    }
    
    
    
    
    
    private func prepareCatField() {
        var xp = view.frame.width / 2 - ((view.bounds.width - 20) / 2)
        categoryField = TextField()
        categoryField!.frame =  CGRect(x: xp, y: 255, width: view.bounds.width - 20, height: 32)
        categoryField!.placeholder = "Enter Category"
        categoryField!.detail = ""//"Error, this Category already exists."
        self.categoryField?.detailLabel.alpha = 0
        categoryField!.enableClearIconButton = true
        categoryField!.delegate = self
        categoryField!.returnKeyType = .Done
        categoryField!.tintColor = MaterialColor.amber.darken4
        categoryField!.placeholderColor = MaterialColor.amber.darken4
        categoryField!.placeholderActiveColor = MaterialColor.amber.darken4
        categoryField!.dividerColor = MaterialColor.cyan.base
        categoryField!.detailColor = MaterialColor.red.accent1

        view.addSubview(categoryField!)
        
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2500 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            if self.categoryField?.text?.characters.count == 0 && self.categoryField?.isFirstResponder() == false{
                self.categoryField?.becomeFirstResponder()
            }
        }
    }
    
    
    
    
    // TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Run check_availibility
        textField.endEditing(true)
        
        while self.categoryField?.text!.characters.last == " "{
            print("remove")
            print("/\(self.categoryField!.text)/")
            var toko = self.categoryField!.text!.substringToIndex(self.categoryField!.text!.endIndex.predecessor())
            self.categoryField!.text = toko
            print("/\(self.categoryField!.text)/")
        }
        while self.categoryField?.text!.characters.first == " "{
            print("remove")
            print("/\(self.categoryField!.text)/")
            self.categoryField?.text?.removeAtIndex(self.categoryField!.text!.startIndex)
//            var toko = self.categoryField!.text!.substringToIndex(self.categoryField!.text!.characters.startIndex.predecessor())
//            self.categoryField!.text = toko
            print("/\(self.categoryField!.text)/")
        }
        self.category = self.categoryField!.text

        if category?.characters.count >= 1{
            check_availibilty(self.category!)
        }else{
            self.categoryField?.detail = "Type Something!"
            self.categoryField?.detailLabel.fadeIn()
        }
        
        
        return true
    }
    
    
    
    
    
    
    func labeling_food(){
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "mylist_amount > 0")
        let cat_food = realm.objects(FoodItem).filter(predicate)
        
        var cat = Category()
        cat.category = self.category!
        
        try! realm.write {
            for each in cat_food{
                // add category to categories
                each.mylist_amount.value = 0
                each.category.append(cat)
                print("-Added \(cat.category) to \(each.title!)")
                print(each)
            }
        }
        
        // Segue to View New Category in CategoryItemsVC
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 600 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("viewNewCat", sender: self)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != nil{
            print("this is segue id \(segue.identifier!)")
            if segue.identifier == "catfood"{
                var vc : ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
                vc.segueStick = "NewCategory"
            }else if segue.identifier == "viewNewCat"{
                var vc : CategoryItemsVC = segue.destinationViewController as! CategoryItemsVC
                vc.category = "\(self.category!)"
                
            }else{
                //            var vc : CategoryItemsVC = segue.destinationViewController as! CategoryItemsVC
                //            vc.categoryLabel.text = "\(self.category!)"
            }
        }else{
            // Canceled, Unwinding back to CategoryItemsVC
        }
    }

}
