//
//  Get_Expire_Cell.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Get_Expire_Cell: UITableViewCell {

    var delegate : UseFood?

    @IBOutlet var few_day_button : DOFavoriteButton!
    @IBOutlet var week_button : DOFavoriteButton!
    @IBOutlet var two_week_button : DOFavoriteButton!
    @IBOutlet var month_button : DOFavoriteButton!
    @IBOutlet var longTime_button : DOFavoriteButton!

    var expires : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        few_day_button.addTarget(self, action: "fewDays", forControlEvents: .TouchUpInside)
        week_button.addTarget(self, action: "aWeek", forControlEvents: .TouchUpInside)
        two_week_button.addTarget(self, action: "twoWeeks", forControlEvents: .TouchUpInside)
        month_button.addTarget(self, action: "aMonth", forControlEvents: .TouchUpInside)
        longTime_button.addTarget(self, action: "longTime", forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func fewDays(){
        self.expires = 3
        set_expires()
    }
    func aWeek(){
        self.expires = 7
        set_expires()
    }
    func twoWeeks(){
        self.expires = 14
        set_expires()
    }
    func aMonth(){
        self.expires = 30
        set_expires()
    }
    func longTime(){
        self.expires = 120
        set_expires()
    }
    
    
    
    func set_expires(){
        if let delegate = delegate{
            delegate.add_Expiration(self.expires!)
        }
    }
    
    
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            if let delegate = delegate{
            }
        } else {
            // select with animation
            sender.select()
            if let delegate = delegate{
            }
        }
    }


}
