//
//  edit_cell_1.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Material
import RealmSwift

protocol ChangeTitleCategory {
    func change_cat_title(newCategory : String)
}
class edit_cell_1: UITableViewCell, UITextFieldDelegate {

    
    var categoryField : TextField?

    @IBOutlet var addFood_Button : UIButton!
    
    var category : String?
    
    var delegate : ChangeTitleCategory?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addFood_Button.layer.cornerRadius = 6
        prepareCatField()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
    
    
    
    func prepareCatField() {
        print("running")
        var xp = self.frame.width / 2 - ((self.frame.width - 100) / 2)
        categoryField = TextField()
        categoryField!.frame =  CGRect(x: xp, y: 75, width: self.frame.width - 100, height: 32)
//        categoryField!.placeholder = "Change Title"
        categoryField!.detail = "Change Title"//"Error, this Category already exists."
        categoryField!.textAlignment = NSTextAlignment.Center
        self.categoryField?.detailLabel.alpha = 1
        categoryField!.font = UIFont(name: categoryField!.font!.fontName, size: 18)
        categoryField!.enableClearIconButton = true
        categoryField!.delegate = self
        categoryField!.returnKeyType = .Done
        categoryField!.tintColor = MaterialColor.amber.darken4
        categoryField!.placeholderColor = MaterialColor.amber.darken4
        categoryField!.placeholderActiveColor = MaterialColor.amber.darken4
        categoryField!.dividerColor = MaterialColor.cyan.base
        categoryField!.detailColor = MaterialColor.amber.darken4
        
        self.addSubview(categoryField!)
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
//                self.categoryField?.detail = "Error, this Category already exists."
//                self.categoryField?.detailLabel.fadeIn()
                move_on = false
            }
        }
        print("Done Checking")
            if move_on == true{
                // Continue with Change
                if let delegate = self.delegate{
                    delegate.change_cat_title(self.category!)
                }
            }
    }

    
    
    
    
    
    
    
    // TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
    
    
    
}

