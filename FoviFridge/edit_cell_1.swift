//
//  edit_cell_1.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Material

class edit_cell_1: UITableViewCell, UITextFieldDelegate {

    
    var categoryField : TextField?

    @IBOutlet var addFood_Button : UIButton!
    
    
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
    
    
    
    
}

