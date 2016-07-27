//
//  ThankYou_SurveyView.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/18/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ThankYou_SurveyView: UIView {

    var view: UIView!
    
    @IBOutlet var anotherButton: UIButton!

    @IBOutlet var noButton: UIButton!

    var red = UIColor(red: 228/255, green: 81/255, blue: 99/255, alpha: 1)
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        noButton.layer.cornerRadius = 6
        anotherButton.layer.cornerRadius = 6
        noButton.layer.borderWidth = 1
        noButton.layer.borderColor = red.CGColor
        
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
        let nib = UINib(nibName: "ThankYou_SurveyView", bundle: bundle)
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
