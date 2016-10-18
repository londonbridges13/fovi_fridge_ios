//
//  FoodItemTableViewCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/4/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet var whiteView : UIView!
    
    @IBOutlet var foodLabel : UILabel!
    @IBOutlet var quantityLabel : UILabel!

    @IBOutlet var foodImage : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        whiteView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
