//
//  FridgeVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/22/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import FoldingTabBar
import RealmSwift
import Material
import Social


class FridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YALTabBarDelegate, TextFieldDelegate, MaterialDelegate {


    
    var foods = [1,2,3,4,5,6,7,8,9]//[String]() // Change later
    
    @IBOutlet var fridgeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topBar: UIView!
    
    @IBOutlet var groceryBagButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    @IBOutlet var search_button_width: NSLayoutConstraint!
    
    /// Reference for SearchBar.
    var searchBar: SearchBar!
    var containerView: UIView!

    
    @IBOutlet var cancel_search_button : UIButton!
    
    var today = NSDate()
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSurvey()
//        createDummyUser()
        

        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        // Top Buttons
        groceryBagButton.layer.cornerRadius = 20
        searchButton.layer.cornerRadius = 20
        settingsButton.layer.cornerRadius = 20
        
        
        //Cancel Search
        cancel_search_button.alpha = 0
        cancel_search_button.layer.cornerRadius = 6
        cancel_search_button.addTarget(self, action: "displayIcons", forControlEvents: .TouchUpInside)
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        checkSurvey()
//        tabBarController!.tabBarController?.tabBar.alpha = 1
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    // Segue to AddFoodVC
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        print("Segue to AddFoodVC")
//        // Tab FadeOut
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            tabBar.alpha = 0.0
            
            }, completion: nil)
        //
        performSegueWithIdentifier("CustomSegue", sender: nil)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            tabBar.alpha = 1
        }

        

    }
    
    @IBAction func unwindToFridge(segue: UIStoryboardSegue){
        print("We're Back, and we've brought groceries")
        //ReQuery Food
        
    }
    
    
    
    //Tableview Stuff
    
    func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // return categories.count + missingItems.count
        // missingItems = All items peviously bought that fridgeAmount = 0
        // Create a Bool for previouslyBought in FoodItem Object
        return foods.count
    }
    
    func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : FridgeFoodsCell = tableView.dequeueReusableCellWithIdentifier("FridgeFoodsCell",
                                                               forIndexPath: indexPath) as! FridgeFoodsCell
        tableView.rowHeight = 148.0
        
        return cell
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.tableView.panGestureRecognizer.translationInView(self.view).y < 0.0 {
            
            if self.i == 0{
                let up = CGAffineTransformMakeTranslation(0, -50)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
//                    self.topBar.transform = up

                    
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.0, options: [], animations: {
                    //
//                    self.fridgeViewTopConstraint.constant = 50 // Top Constraint
                    
                    }, completion: nil)
                self.i = 1
            }
            
            if self.searchBar != nil{
                self.searchBar.endEditing(true)
            }

        }else{
            
            if self.i == 1{
                let back = CGAffineTransformMakeTranslation(0, 0)
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    
//                    self.topBar.transform = back
                    self.view.layoutIfNeeded()
                    if self.searchBar != nil{
                        self.searchBar.endEditing(true)
                    }
                    
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.0, options: [], animations: {
                    //
//                    self.fridgeViewTopConstraint.constant = 90 // Top Constraint
                    }, completion: nil)
                self.i = 0
            }
        }
        
        
    }
    
    
    
    // End TableView 
    
    
    
    // Animate SearchBar
    func showSearchBar(){
        self.search_button_width.constant = 450
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
            self.groceryBagButton.alpha = 0
            self.settingsButton.alpha = 0
            UIView.animateWithDuration(0.3) {
                self.searchButton.alpha = 0
                self.cancel_search_button.alpha = 1
            }
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                // SearchBar
                self.prepareView()
                self.prepareContainerView()
                self.prepareSearchBar()
            }
        }
        
    }
    
    // Action: Display SearchBar
    @IBAction func displaySearchBar(sender: AnyObject) {
        showSearchBar()
    }

    // SearchBar Setup
    func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the containerView.
    func prepareContainerView() {
        containerView = UIView()
//        self.view.layout(containerView).edges(top: 40, left: -5, right: -5)
        let wp = self.view.frame.width - 30

        containerView.frame = CGRect(x: 10, y: 40, width: wp, height: 40)
        self.view.addSubview(containerView)
    }
    
    /// Prepares the toolbar
    func prepareSearchBar() {
        searchBar = SearchBar()
        searchBar.delegate = self

        searchBar.alpha = 0
        searchBar.becomeFirstResponder()
        searchBar.frame = CGRect(x: 0, y: 0, width: 300, height: 40)

        containerView.addSubview(searchBar)
        searchBar.fadeIn()
        searchBar.becomeFirstResponder()
        searchBar.clearButton.addTarget(self, action: "displayIcons", forControlEvents: .TouchUpInside)
        let image: UIImage? = MaterialIcon.cm.moreVertical
        
        // More button.
        let moreButton: IconButton = IconButton()
        moreButton.pulseColor = MaterialColor.grey.base
        moreButton.tintColor = MaterialColor.grey.darken4
        moreButton.setImage(image, forState: .Normal)
        moreButton.setImage(image, forState: .Highlighted)
        
        /*
         To lighten the status bar - add the
         "View controller-based status bar appearance = NO"
         to your info.plist file and set the following property.
         */
        
//        searchBar.leftControls = [moreButton]
    }

    
    
    
    func displayIcons(){
        print("displayIcons")
        UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
            self.searchBar.alpha = 0
            self.searchBar.endEditing(true)
            self.cancel_search_button.alpha = 0
            self.containerView.alpha = 0
            self.searchButton.alpha = 1
            
            self.search_button_width.constant = 41
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    self.groceryBagButton.alpha = 1
                    self.settingsButton.alpha = 1
                }, completion: nil)
            }, completion: nil)
        }, completion: nil)
    }
    
    
    

    //Segue to AddFoodVC
    @IBAction func goToGroceries(sender: AnyObject) {
        print("Segue to AddFoodVC")
        //        // Tab FadeOut
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.tabBarController?.tabBar.alpha = 0.0
            
            }, completion: nil)
        //
        performSegueWithIdentifier("CustomSegue", sender: nil)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.tabBarController?.tabBar.alpha = 1.0
        }

    }
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CustomSegue"{
            if segue is CustomSegue {
                (segue as! CustomSegue).animationType = .Push
            }
        }
        
        
    }
    
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .Push
        return segue
    }

    
    func checkSurvey(){
        print("Checking")
        
        let realm = try! Realm()
        let cUser = realm.objects(UserDetails).first
        if cUser != nil{
            if cUser!.last_checked != nil{
                if getDayFromDate(cUser!.last_checked!) != getDayFromDate(today){
                    //   last_checked is date when last checked here
                    print("Segue to SurveyVC")
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("check", sender: self)
                    }
            }else{
                    //Already checked User, Everything is Good
                    print("Already Checked User")
                }
            }else{
                //Found Nil in last_checked, run checkSurvey
                print("Found Nil in last_checked, running Survey")
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("check", sender: self)
                }
            }
        }else{
            // Run Onboard
            print("Run Onboard")
            self.runOnboard()
        }
    }
    
    
    func getDayFromDate(date : NSDate)-> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(day)
        
        return day
    }

    
    func runOnboard(){
        print("Running Onboard")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("runOnboard", sender: self)
        }
    }
    
    
    func inviteFriend_facebook(){
        print("inviting...")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {

            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Hey Barbara, this app helps you know what's in your fridge, isn't that amazing!")
//            vc.addImage(UIImage(named: "myImage.jpg")!) // Icon
            vc.addURL(NSURL(string: "https://www.google.com"))
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    // MARK: - Testing
    func createDummyUser(){
        let realm = try! Realm()
        let dummy = UserDetails()
        dummy.name = "Matt"
        dummy.paid_for_removeSurvey = false // didn;t opt out
        dummy.the_last_answered = nil // new user
        try! realm.write {
            realm.deleteAll()
            realm.add(dummy)
            print("Created User")
        }
    }

}
