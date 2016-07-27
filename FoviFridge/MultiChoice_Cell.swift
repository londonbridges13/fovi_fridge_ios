//
//  MultiChoice_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/16/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class MultiChoice_Cell: UITableViewCell {

    
    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var circleButton: DOFavoriteButton!
    
    var delegate : otherMC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        circleButton.duration = 0.5
        circleButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            if let delegate = delegate{
                delegate.removeAnswer(self.answerLabel.text!)
            }
        } else {
            // select with animation
            sender.select()
            if let delegate = delegate{
                delegate.addAnswer(self.answerLabel.text!)
            }

        }
    }
    
}
