//
//  CategoryFoodItemCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/7/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class CategoryFoodItemCell: UITableViewCell {

    
    @IBOutlet var foodLabel : UILabel!
    
    @IBOutlet var foodImage : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
