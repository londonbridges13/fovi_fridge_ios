//
//  SeeYouLater_View.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class SeeYouLater_View: UIView {

    var view: UIView!
    
    @IBOutlet var okayButton : UIButton!
    

    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    func removeSeeYa(){
        view.fadeOut()
    }
    
    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true

        okayButton.layer.cornerRadius = 5
        okayButton.addTarget(self, action: "removeSeeYa", forControlEvents: .TouchUpInside)
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SeeYouLater_View", bundle: bundle)
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
