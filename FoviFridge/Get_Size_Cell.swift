//
//  Get_Size_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Get_Size_Cell: UITableViewCell, UITextFieldDelegate, MeasureToCellDelegate {

    var delegate : UseFood?
    
    @IBOutlet var measure_button : UIButton!
    @IBOutlet var amountTX : UITextField!
    @IBOutlet var cellLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellLabel.roundCorners([.TopLeft, .BottomLeft], radius: 6)

        amountTX.delegate = self
        addDoneButtonOnNumpad(self.amountTX)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Add to new_fooditem
        print("Using \(measure_button.titleLabel!.text!) for MeasureType")
        self.set_measure_type(measure_button.titleLabel!.text!)
        

    }
    
    
    
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar
    }
    
    
    
    
    // MeasureToCellDelegate
    func set_measure_type(measureType: String)
    {
        self.measure_button.setTitle(measureType, forState: .Normal)
        print("About to run UseFood Delegate")
        // transfer to CreateUniqueVC
        
        if let delegate = delegate{
            print("Running UseFood Delegate")
            
            if measureType != "Of Them"{
                delegate.add_Measurement(measureType, full_amount: Float(self.amountTX.text!)!, current_amount: Float(self.amountTX.text!)!)
                delegate.add_MyListAmount(1)

            }else{
                // set the textfield to mylist, in new delegate func
                // also add measurementType, set Value = 1 for full and current amounts
                
                delegate.add_Measurement(measureType, full_amount: 1, current_amount: 1)
                delegate.add_MyListAmount(Int(self.amountTX.text!)!)
                
            }
        }
    }
    
}
