//
//  ShoppingCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/24/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell {

    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var whiteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
