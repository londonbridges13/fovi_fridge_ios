//
//  Invite_View.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/2/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class Invite_View: UIView {

    
    var view: UIView!
    
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var textButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var otherButton: UIButton!
    @IBOutlet var laterButton: UIButton!
    

    
    
    
    func fadeaway(){
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
        
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        
        fbButton.layer.cornerRadius = 3
        textButton.layer.cornerRadius = 3
        emailButton.layer.cornerRadius = 3
        otherButton.layer.cornerRadius = 3

        
        fbButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)
        textButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)
        emailButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)
        otherButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)
        laterButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)
        
        //        alerter.helloLabel.text = "Bye"
        //        yesButton.layer.cornerRadius = 5
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Invite_View", bundle: bundle)
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
