//
//  NewCategoryCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class NewCategoryCell: UITableViewCell {

    @IBOutlet var newCatButton : UIButton!
    
    var fireRed = UIColor(red: 237/255, green: 90/255, blue: 80/255, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Category Button
        self.newCatButton.layer.cornerRadius = 3
        self.newCatButton.layer.borderColor = fireRed.CGColor
        self.newCatButton.layer.borderWidth = 1.25
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
