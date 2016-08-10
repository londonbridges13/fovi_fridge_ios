//
//  SettingsVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet var tableview : UITableView!
    
    var options = [1] // the number of cells to display in tableview
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    
    //TableView
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : EmailCell  = tableview.dequeueReusableCellWithIdentifier("scell1", forIndexPath: indexPath) as! EmailCell
        tableview.rowHeight = 65
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            // Send Email
            self.sendEmail()
        }
    }
    
    
    
    
    
    
    
    //Email in Cell 1
    
    func sendEmail(){
        var space = "                                                                                                "
        var systemVersion = UIDevice.currentDevice().systemVersion
        let version =
            NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
                as? String
        var device = UIDevice.currentDevice().deviceType

        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Fovi Feedback")
            mailComposer.setMessageBody("I love the app, but... \n \n\n\n_____________________   \nPhone Version: \(systemVersion),\n App Version: \(version!),\n \(device)", isHTML: false)
            mailComposer.setToRecipients(["fovifridge@gmail.com"])

            self.presentViewController(mailComposer, animated: true, completion: nil)
        }

    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
