//
//  RateApp_AlertView.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/16/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class RateApp_AlertView: UIView {

    
    var view: UIView!
    
    @IBOutlet var rateButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    
    
    func rate_fovi(){
        let appID = "1148349113" // Your AppID
        if let checkURL = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("url successfully opened")
            }
        }else {
            print("invalid url")
        }
        fadeaway()
        
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            if let current_app_version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                try! realm.write({
                    print("Saving Rating to Realm")
                    user!.rated_version = current_app_version
                })
            }
        }
    }
    
    
    
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
        
        
        rateButton.layer.cornerRadius = 3
        cancelButton.layer.cornerRadius = 3

        
        
        rateButton.addTarget(self, action: "rate_fovi", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "fadeaway", forControlEvents: .TouchUpInside)

        

        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RateApp_AlertView", bundle: bundle)
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
