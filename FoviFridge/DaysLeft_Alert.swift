//
//  DaysLeft_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift


class DaysLeft_Alert: UIView {

    
    
    var view: UIView!
    
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var stepper : GMStepper!

    @IBOutlet var bigLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!

    var fooditem = FoodItem()
    
    
    
    
    
    func fadeAway(){
        view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.view.alpha = 0
            self.removeFromSuperview()
            self.view.removeFromSuperview()
        }
    }

    
    func change_days_left(){
        let realm = try! Realm()
        try! realm.write({ 
            let today = NSDate()
            let daysLeft = stepper.value // convert to Int if needed
            let added_days = daysLeft * 86400
            let new_date = today.dateByAddingTimeInterval(added_days)
            
            print(today)
            print("This is your new date : \(new_date)")
            print("This is your the old date : \(self.fooditem.expiration_date)")

            
            self.fooditem.expiration_date = new_date
        })
        
        fadeAway()
    }
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
        self.doneButton.addTarget(self, action: "change_days_left", forControlEvents: .TouchUpInside)
        
        doneButton.layer.cornerRadius = 3
        
        
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DaysLeft_Alert", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }


}
