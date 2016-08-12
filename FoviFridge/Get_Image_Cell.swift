//
//  Get_Image_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Get_Image_Cell: UITableViewCell, SettingImage {

    var delegate : UseFood?

    
    @IBOutlet var camera_button : UIButton!
    @IBOutlet var library_button : UIButton!
    @IBOutlet var ourImages_button : UIButton!
    @IBOutlet var food_image : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        camera_button.addTarget(self, action: "takePic", forControlEvents: .TouchUpInside)
        library_button.addTarget(self, action: "use_Library", forControlEvents: .TouchUpInside)
        ourImages_button.addTarget(self, action: "", forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func use_Library(){

        if let delegate = delegate{
            delegate.use_Library()
        }
    }
    
    func takePic(){
    
        if let delegate = delegate{
            delegate.takePic()
        }
    }

    func displayImage(image : UIImage){
        print("Setting Image")
        self.food_image.image = image
    }

}
