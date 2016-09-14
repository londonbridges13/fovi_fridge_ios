//
//  Food_Expiration_Walk_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/12/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Food_Expiration_Walk_Alert: UIView {

    // We will notify you of expiring food 5 days before expiration.
    // We would like to notify you of expiring food when you're not using the app.
    
    
    var view: UIView!
    
    @IBOutlet var doneButton : UIButton!
    
    @IBOutlet var topLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!

    
    @IBOutlet var imageview : UIImageView!


    
    
    
    
    
    func fadeAway(){
        view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.view.alpha = 0
            self.removeFromSuperview()
            self.view.removeFromSuperview()
        }
    }
    

    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
        self.doneButton.addTarget(self, action: "fadeAway", forControlEvents: .TouchUpInside)
        
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
        let nib = UINib(nibName: "Food_Expiration_Walk_Alert", bundle: bundle)
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
