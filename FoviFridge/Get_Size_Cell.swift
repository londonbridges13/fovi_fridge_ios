//
//  Get_Size_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Get_Size_Cell: UITableViewCell, UITextFieldDelegate {

    var delegate : UseFood?
    
    @IBOutlet var measure_button : UIButton!
    @IBOutlet var amountTX : UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        amountTX.delegate = self
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
        if let delegate = delegate{
            delegate.add_Measurement(measure_button.titleLabel!.text!, full_amount: Float(amountTX.text!)!, current_amount: Float(amountTX.text!)!)
        }
    }
    
}
