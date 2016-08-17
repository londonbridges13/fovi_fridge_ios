//
//  FullFoodCell1.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/17/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class FullFoodCell1: UITableViewCell {

    @IBOutlet var foodImageView : UIImageView!
    @IBOutlet var foodBackGroungView : UIView!
    @IBOutlet var foodLabel : UILabel!
    
    var food_image : UIImage?
    var food_title : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        foodBackGroungView.layer.cornerRadius = 12
        foodBackGroungView.backgroundColor = UIColor.whiteColor()
        
        if food_title != nil{
            self.foodLabel.text = food_title!
        }
        
        if food_image != nil{
            self.foodImageView.image = food_image!
        }else{
            print("No Image")
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setBackGroundColor(color : UIColor){
        self.contentView.backgroundColor = color
    }
}
