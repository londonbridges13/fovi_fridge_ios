//
//  ChangeFridge_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 10/12/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift
import GMStepper

class ChangeFridge_Alert: UIView {

   
    
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var stepper : GMStepper!
    
    @IBOutlet var bigLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!
    
    var fooditem = FoodItem()
    
    var view: UIView!

    
    
    
    func fadeAway(){
        view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.view.alpha = 0
            self.removeFromSuperview()
            self.view.removeFromSuperview()
        }
    }
    
    
    func change_fridge_amount_left(){
        let realm = try! Realm()
        try! realm.write({
            let amountLeft = stepper.value // convert to Int if needed
            self.fooditem.fridge_amount.value = Int(amountLeft)
        })
        
        fadeAway()
    }
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
        self.doneButton.addTarget(self, action: "change_fridge_amount_left", forControlEvents: .TouchUpInside)
        
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
        let nib = UINib(nibName: "ChangeFridge_Alert", bundle: bundle)
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
