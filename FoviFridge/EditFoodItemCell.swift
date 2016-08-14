//
//  EditFoodItemCell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit


protocol RemoveFoodItem {
    func delete_fooditem(fooditem : FoodItem, indexRow : Int)
}

class EditFoodItemCell: UITableViewCell {

    
    @IBOutlet var foodLabel : UILabel!
    
    @IBOutlet var foodImage : UIImageView!
    
    @IBOutlet var deleteButton : UIButton!
    
    var indexpath : Int?
    var remove_delegate : RemoveFoodItem?

    var fooditem = FoodItem()
    
    var red = UIColor(red: 228/255, green: 81/255, blue: 99/255, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteButton.layer.cornerRadius = 3
        deleteButton.layer.borderWidth = 0.9
        deleteButton.layer.borderColor = red.CGColor
        deleteButton.layer.masksToBounds = true
        
        deleteButton.addTarget(self, action: "remove_food", forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func remove_food(){
        if let remove_delegate = remove_delegate{
            remove_delegate.delete_fooditem(fooditem, indexRow: indexpath!)
        }
    }

}
