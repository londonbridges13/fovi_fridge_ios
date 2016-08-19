//
//  FridgeFoodItemCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/2/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class FridgeFoodItemCell: UICollectionViewCell {
    
    @IBOutlet var foodImage: UIImageView!
    
    @IBOutlet var foodLabel: UILabel!
    
    @IBOutlet var quantityLabel: UILabel!
    
    var quantity : Int?
    
    let lred = UIColor(red: 255/255, green: 235/255, blue: 242/255, alpha: 1)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        quantityLabel.text = "\(self.quantity)"
        quantityLabel.layer.cornerRadius = 11
        
        if quantityLabel.text == "0"{
            self.contentView.backgroundColor = lred
        }
        
    }

    
}
