//
//  ShowAgain_AlertView.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/5/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ShowAgain_AlertView: UIView {


    
    
    
    var view: UIView!

    
    @IBOutlet var i_understand: UIButton!
    @IBOutlet var dont_understand: UIButton!

    
    
    
    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        i_understand.layer.cornerRadius = 6
        dont_understand.layer.cornerRadius = 6
        
        
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        
//        i_understand.addTarget(self, action: "add_food_item", forControlEvents: .TouchUpInside)
//        dont_understand.addTarget(self, action: "remove_food_item", forControlEvents: .TouchUpInside)
        
        
        
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ShowAgain_AlertView", bundle: bundle)
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
