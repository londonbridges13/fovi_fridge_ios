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

    @IBOutlet var few_day_button : UIButton!
    @IBOutlet var week_button : UIButton!
    @IBOutlet var two_week_button : UIButton!
    @IBOutlet var month_button : UIButton!
    @IBOutlet var longTime_button : UIButton!
    @IBOutlet var cellLabel : UILabel!

    var expires : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        few_day_button.addTarget(self, action: "fewDays", forControlEvents: .TouchUpInside)
        week_button.addTarget(self, action: "aWeek", forControlEvents: .TouchUpInside)
        two_week_button.addTarget(self, action: "twoWeeks", forControlEvents: .TouchUpInside)
        month_button.addTarget(self, action: "aMonth", forControlEvents: .TouchUpInside)
        longTime_button.addTarget(self, action: "longTime", forControlEvents: .TouchUpInside)
        
        remove_all_tints()
        
        self.cellLabel.roundCorners([.TopRight, .BottomRight], radius: 6)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func fewDays(){
        self.expires = 3
        set_expires()
        remove_all_tints()

        UIView.animateWithDuration(0.3) {
            var color = UIColor(red: 255/255, green: 235/255, blue: 242/255, alpha: 1)
            self.few_day_button.backgroundColor = color
        }
    }
    func aWeek(){
        self.expires = 7
        set_expires()
        remove_all_tints()

        UIView.animateWithDuration(0.3) {
            var color = UIColor(red: 255/255, green: 247/255, blue: 219/255, alpha: 1)
            self.week_button.backgroundColor = color
        }
    }
    func twoWeeks(){
        self.expires = 14
        set_expires()
        remove_all_tints()

        UIView.animateWithDuration(0.3) {
            var color = UIColor(red: 212/255, green: 233/255, blue: 255/255, alpha: 1)
            self.two_week_button.backgroundColor = color
        }
    }
    func aMonth(){
        self.expires = 30
        set_expires()
        remove_all_tints()

        UIView.animateWithDuration(0.3) {
            var color = UIColor(red: 212/255, green: 235/255, blue: 159/255, alpha: 1)
            self.month_button.backgroundColor = color
        }
    }
    func longTime(){
        self.expires = 120
        set_expires()
        remove_all_tints()
        UIView.animateWithDuration(0.3) {
            var color = UIColor(red: 212/255, green: 235/255, blue: 242/255, alpha: 1)
            self.longTime_button.backgroundColor = color
        }
    }
    
    
    func remove_all_tints(){
        UIView.animateWithDuration(0.15) { 
            self.few_day_button.backgroundColor = UIColor.clearColor()
            self.week_button.backgroundColor = UIColor.clearColor()
            self.two_week_button.backgroundColor = UIColor.clearColor()
            self.month_button.backgroundColor = UIColor.clearColor()
            self.longTime_button.backgroundColor = UIColor.clearColor()
            
            self.few_day_button.layer.cornerRadius = 3
            self.week_button.layer.cornerRadius = 3
            self.two_week_button.layer.cornerRadius = 3
            self.month_button.layer.cornerRadius = 3
            self.longTime_button.layer.cornerRadius = 3
        }
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
