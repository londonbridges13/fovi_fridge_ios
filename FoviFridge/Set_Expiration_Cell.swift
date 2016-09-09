//
//  Set_Expiration_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/8/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

protocol SetExpireCellDelegate {
    func selectedCell(setDays : Int)
    func selectedCustomInput()
}

class Set_Expiration_Cell: UICollectionViewCell {
    
    @IBOutlet var setLabel : UILabel!
    @IBOutlet var setImageView : UIImageView!
    @IBOutlet var backView : UIView!
    @IBOutlet var descLabel : UILabel!
    @IBOutlet var selectButton : UIButton!
    
    var setDays : Int?
    
    var delegate : SetExpireCellDelegate?
    
    func selected(){
        if let delegate = delegate{
            delegate.selectedCell(setDays!)
        }
    }
    func customInput(){
        if let delegate = delegate{
            print("Running EnterInput_Alert")
            delegate.selectedCustomInput()
        }
    }
    
    @IBAction func pressedSelected(sender: AnyObject) {
        if setDays == nil{
            // Custom Input, Display Alert
            print("Display Custom Alert")
            customInput()
        }else{
            selected()
        }
    }
}
