//
//  Get_Title_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift
import Material

protocol UseFood {
    // Check Availibilty
    func add_Title(title: String) // This adds the title to a variable in the CreateFoodTVC
    func add_Image(image : UIImage) // This adds the image to a variable in the CreateFoodTVC
    func add_Expiration(expires : Int) // This adds the expiration to a variable in the CreateFoodTVC
    func add_Measurement(measurement_type : String, full_amount : Float, current_amount : Float) // This adds the measurement to a variable in the CreateFoodTVC
    func add_MyListAmount(amount : Int)
    func use_Library()
    func takePic()
}

class Get_Title_Cell: UITableViewCell, UITextFieldDelegate {

    
    var delegate : UseFood?
    
    private var titleField : TextField?

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareTitleField()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepareTitleField() {
        var xp = self.frame.width / 2 - ((self.bounds.width - 20) / 2)
        titleField = TextField()
        titleField!.frame =  CGRect(x: xp, y: 75, width: self.bounds.width - 20, height: 32)
        titleField!.placeholder = "Enter Food"
        titleField!.detail = ""//"Error, this title already exists."
        self.titleField?.detailLabel.alpha = 0
        titleField!.enableClearIconButton = true
        titleField!.delegate = self
        titleField!.returnKeyType = .Done
        titleField!.tintColor = MaterialColor.amber.darken4
        titleField!.placeholderColor = MaterialColor.amber.darken4
        titleField!.placeholderActiveColor = MaterialColor.amber.darken4
        titleField!.dividerColor = MaterialColor.cyan.base
        titleField!.detailColor = MaterialColor.red.accent1
        
        self.addSubview(titleField!)
        
    }

    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        while self.titleField?.text!.characters.last == " "{
            print("remove")
            print("/\(self.titleField!.text)/")
            var toko = self.titleField!.text!.substringToIndex(self.titleField!.text!.endIndex.predecessor())
            self.titleField!.text = toko
            print("/\(self.titleField!.text)/")
        }
        while self.titleField?.text!.characters.first == " "{
            print("remove")
            print("/\(self.titleField!.text)/")
            self.titleField?.text?.removeAtIndex(self.titleField!.text!.startIndex)
            print("/\(self.titleField!.text)/")
        }
        

        if textField.text?.characters.count > 0{
            self.check_availibilty(textField.text!)
        }else{
            self.titleField?.detail = "Type Something!"
            self.titleField?.detailLabel.fadeIn()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    // Check Availibilty
    func check_availibilty(foodTX : String){
        var move_on = true
        
        let realm = try! Realm()
        let all_food = realm.objects(FoodItem).filter("is_basic = \(false)")
        for each in all_food{
            if each.title != foodTX{
                // Do nothing
            }else{
                // Tell user, it already exists
                print("Already have \(each.title)")
                self.titleField?.detail = "Error, this Food already exists."
                self.titleField?.detailLabel.fadeIn()
                move_on = false
            }
            
        }
        print("Done Checking")
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 600 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            if move_on == false{
                
                self.titleField?.becomeFirstResponder()
            }else{
                print("Usable Title")
                if let delegate = self.delegate{
                    print("Delegation in use")
                    delegate.add_Title(foodTX)
                }
            }
        }
        
    }
    
    
    

}
