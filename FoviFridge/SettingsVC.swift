//
//  SettingsVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import MessageUI
import Social

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet var tableview : UITableView!
    
    var options = [1,2] // the number of cells to display in tableview
    var dtint : UIView?
    
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
        if indexPath.row == 0{
            let cell : EmailCell  = tableview.dequeueReusableCellWithIdentifier("scell1", forIndexPath: indexPath) as! EmailCell
            tableview.rowHeight = 65
            
            return cell
        }else{
            let cell : EmailCell  = tableview.dequeueReusableCellWithIdentifier("scell1", forIndexPath: indexPath) as! EmailCell
            tableview.rowHeight = 65
            cell.settingLabel.text = "Invite Friends"
            return cell

        }
        
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            // Send Email
            self.sendEmail()
        }else{
            self.invite_friends()
        }
    }
    
    
    
    
    
    
    
    //Email in Cell 1
    
    func sendEmail(){
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
    
    
    
    
    
    
    
    
    
    func invite_friends(){
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.invite_alert()
        }
    }
    func invite_alert(){
        
        let alert = Invite_View()
        let a_height : CGFloat = 330
        let a_width : CGFloat = 200
        let xpp = self.view.frame.width / 2 - (a_width / 2)
        let ypp = self.view.frame.height / 2 - (a_height / 2)
        alert.frame = CGRect(x: xpp, y: ypp, width: a_width, height: a_height)
        alert.fbButton.addTarget(self, action: "inviteFriend_facebook", forControlEvents: .TouchUpInside)
        alert.textButton.addTarget(self, action: "sendMessage", forControlEvents: .TouchUpInside)
        alert.emailButton.addTarget(self, action: "sendInviteEmail", forControlEvents: .TouchUpInside)
        alert.otherButton.addTarget(self, action: "inviteFriend_other", forControlEvents: .TouchUpInside)
        alert.laterButton.addTarget(self, action: "remove_dark_tint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.6)
        
    }
    
    func inviteFriend_facebook(){
        remove_dark_tint()
        print("inviting...")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Hey Barbara, this app puts your fridge in your pocket! Isn't that amazing!")
            //            vc.addImage(UIImage(named: "myImage.jpg")!) // Icon
            vc.addURL(NSURL(string: "https://itunes.apple.com/us/app/fovi-fridge/id1148349113?ls=1&mt=8"))
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
    }
    
    func inviteFriend_other(){
        remove_dark_tint()
        let textToShare = "Hey Barbara, this app puts your fridge in your pocket! Isn't that amazing!"
        
        if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/fovi-fridge/id1148349113?ls=1&mt=8") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    
    
    // Send Message
    func sendMessage(){
        remove_dark_tint()
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Hey Barbara, this app puts your fridge in your pocket! Isn't that amazing! \n\n https://appsto.re/us/5QMCeb.i"
        messageVC.recipients = [] // Optionally Add Cell Phone Numbers
        messageVC.messageComposeDelegate = self
        
        presentViewController(messageVC, animated: true, completion: nil)
    }
    // Delegate Method
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue:
            print("Cancelled Message")
        case MessageComposeResultFailed.rawValue:
            print("Failed to send Message!")
        case MessageComposeResultSent.rawValue:
            print("Message Sent!")
        default:
            break;
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Email
    func sendInviteEmail(){
        remove_dark_tint()
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Fovi Feedback")
            mailComposer.setMessageBody("Hey Barbara, this app puts your fridge in your pocket! Isn't that amazing! \n\n Check out Fovi: \n https://itunes.apple.com/us/app/fovi-fridge/id1148349113?ls=1&mt=8", isHTML: false)
            mailComposer.setToRecipients([])
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }

    
    
    func remove_dark_tint(){
        print("Removing Tint")
        self.dtint!.fadeOut()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dtint!.alpha = 0
        }
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
