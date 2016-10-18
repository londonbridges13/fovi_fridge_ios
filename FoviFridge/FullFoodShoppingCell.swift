//
//  FullFoodShoppingCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/17/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class FullFoodShoppingCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var amountleftLabel : UILabel!
//    @IBOutlet var amountTX : UITextField!
    
    var delegate : ChangeFoodValue?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        amountTX.delegate = self

//        addDoneButtonOnNumpad(amountTX)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        if amountTX.text?.characters.count > 0{
//            // Run Delegate
//            if let delegate = delegate{
//                let shop_amount = Int(self.amountTX.text!)
//                
//                delegate.change_Shopping_Amount(shop_amount!)
//            }
//        }
//    }
//
//    
//    
//    
//    
//    func addDoneButtonOnNumpad(textField: UITextField) {
//        
//        let keypadToolbar: UIToolbar = UIToolbar()
//        
//        // add a done button to the numberpad
//        keypadToolbar.items=[
//            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: textField, action: #selector(UITextField.resignFirstResponder)),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
//        ]
//        keypadToolbar.sizeToFit()
//        // add a toolbar with a done button above the number pad
//        textField.inputAccessoryView = keypadToolbar
//    }
    


}
