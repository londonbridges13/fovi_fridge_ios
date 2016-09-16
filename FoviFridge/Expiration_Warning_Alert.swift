//
//  Expiration_Warning_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/16/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

class Expiration_Warning_Alert: UIView, UITextFieldDelegate {

    var view: UIView!
    
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var daysTX : UITextField!
    
    
    
    
    
    func fadeAway(){
        view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.view.alpha = 0
            self.removeFromSuperview()
            self.view.removeFromSuperview()
        }
    }
    
    func setCustomInput(){
        if self.daysTX.text?.characters.count > 0{
            let realm = try! Realm()
            var user = realm.objects(UserDetails).first
            if user != nil{
                try! realm.write{
                    print(user)
                    user!.expiration_warning = Int(daysTX.text!)!
                    print(user)
                }
            }
           
            let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 50 * Int64(NSEC_PER_MSEC))
            dispatch_after(timer, dispatch_get_main_queue()) {
                
                self.doneButton.sendActionsForControlEvents(.TouchUpInside)
            }
        }else{
            print("Type something buddy")
            
            let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 600 * Int64(NSEC_PER_MSEC))
            dispatch_after(timer, dispatch_get_main_queue()) {
                self.daysTX.becomeFirstResponder()
            }
        }
    }
    
    
  
    
    
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            self.setCustomInput()
        }
        
    }
    
    
    
    
    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        self.daysTX.delegate = self
        self.doneButton.addTarget(self, action: "fadeAway", forControlEvents: .TouchUpInside)
        
        doneButton.layer.cornerRadius = 3
        
        addDoneButtonOnNumpad(self.daysTX)
        
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            self.daysTX.text = "\(user!.expiration_warning)"
        }
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {
            self.daysTX.becomeFirstResponder()
        }
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Expiration_Warning_Alert", bundle: bundle)
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
