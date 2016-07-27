//
//  MultiChoice-Other_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/18/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Material

protocol otherMC {
    func addAnswer(cellAnswer : String)
    func removeAnswer(cellAnswer : String)
}

class MultiChoice_Other_Cell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet var sendButton: UIButton!
    
    var delegate : otherMC?
    let textField = TextField()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.delegate = self

        sendButton.layer.cornerRadius = 6
        
        
        textField.placeholder = "Other"
        
        self.layout(textField).top(3).horizontally(left: 45, right: 20)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Return!")
        textField.endEditing(true)
        
        if let delegate = delegate{
            delegate.addAnswer(self.textField.text!)
        }

        return true
    }

   
    
    
    
    
   
    
}
