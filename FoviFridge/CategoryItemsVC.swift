//
//  CategoryItemsVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class CategoryItemsVC: UIViewController {

    
    @IBOutlet var editButton : UIButton!
    
    
    
    @IBOutlet var edit_width: NSLayoutConstraint!
    
    var blue = UIColor(red: 0/255, green: 153/255, blue: 241/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Edit Button
        self.editButton.layer.cornerRadius = 3
        self.editButton.layer.borderColor = blue.CGColor
        self.editButton.layer.borderWidth = 1.25
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    @IBAction func edit(sender: AnyObject) {
        progressBarButtonFadeOut()

    }
    
    
    
    
    
    func progressBarButtonFadeOut(){
        
        self.edit_width.constant = 190
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        
        UIView.animateWithDuration(0.9, animations: {
            //timeCapDesign is a UIButton
            
//            self.editButton.alpha = 0
            
//            self.editButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
        })
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
