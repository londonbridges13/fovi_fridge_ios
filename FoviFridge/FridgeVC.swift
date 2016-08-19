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


class FridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YALTabBarDelegate, UITextFieldDelegate, MaterialDelegate, SettingCategory, DisplayFullFoodView {


    
    var categories = [String]()//[String]() // Change later
    var tint : UIView?

    var fullview : Full_Food_VC?
    
    @IBOutlet var fridgeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topBar: UIView!
    
    @IBOutlet var groceryBagButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    @IBOutlet var search_button_width: NSLayoutConstraint!
    
    /// Reference for SearchBar.
    var searchBar: SearchBar! = nil
    var containerView: UIView!

    var is_searching = false
    var searchable_array = [Searchable]()
    
    var category : String?
    var categoryColor : UIColor?
    
    @IBOutlet var cancel_search_button : UIButton!
    
    var today = NSDate()
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSurvey()
//        createDummyUser()
        
        self.view.alpha = 0
        self.view.fadeIn(duration: 0.45)

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
        get_all_categories()
        

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
    
    func set_cat(cat : String, color : UIColor){
        self.category = cat
        self.categoryColor = color
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("view_cat", sender: self)
        }
    }
    
    
    //Tableview Stuff
    
    func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // return categories.count + missingItems.count
        // missingItems = All items peviously bought that fridgeAmount = 0
        // Create a Bool for previouslyBought in FoodItem Object
        
        if self.is_searching == false{
            return categories.count + 1
        }else{
            return self.searchable_array.count
        }
    }
    
    func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.is_searching == false{
           
            var indexpathh = indexPath.row - 1
            var current_category = indexpathh
            
            if indexPath.row == 0{
                let cell : NewCategoryCell = tableView.dequeueReusableCellWithIdentifier("NewCategoryCell", forIndexPath: indexPath) as! NewCategoryCell
                tableView.rowHeight = 45
                return cell
            }
            let cell : FridgeFoodsCell = tableView.dequeueReusableCellWithIdentifier("FridgeFoodsCell",
                                                                                     forIndexPath: indexPath) as! FridgeFoodsCell
            cell.delegate = self
            cell.fullfoodview_delegate = self
            cell.food.removeAll()
            cell.get_fooditems(self.categories[indexPath.row - 1])
            cell.design_category_button(indexPath.row)
            cell.categoryButton.setTitle("\(self.categories[indexPath.row - 1])", forState: .Normal)
            tableView.rowHeight = 148.0
            
            cell.alpha = 0
            cell.fadeIn()
            
            return cell
        }else{
            // display searched items and categories
            
            if self.searchable_array[indexPath.row].is_category == true{
                // display category
                let cell : FridgeFoodsCell = tableView.dequeueReusableCellWithIdentifier("FridgeFoodsCell",forIndexPath: indexPath) as! FridgeFoodsCell
                cell.delegate = self
                cell.food.removeAll()
                cell.get_fooditems(self.searchable_array[indexPath.row].category.category)
                cell.design_category_button(indexPath.row)
                cell.categoryButton.setTitle("\(self.searchable_array[indexPath.row].category.category)", forState: .Normal)
                tableView.rowHeight = 148.0
                
                return cell

            }else{
                // display fooditem
                
                let cell : FoodItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("FoodItemTableViewCell",forIndexPath: indexPath) as! FoodItemTableViewCell
                
                if self.searchable_array[indexPath.row].fooditem.image != nil{
                    cell.foodImage.image = UIImage(data : self.searchable_array[indexPath.row].fooditem.image!)
                }

                if self.searchable_array[indexPath.row].fooditem.title != nil{
                    cell.foodLabel.text = self.searchable_array[indexPath.row].fooditem.title
                }
                tableView.rowHeight = 65
                
                return cell

            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        if is_searching == true{
            let fooditem = self.searchable_array[indexPath.row].fooditem
            searchBar?.textField.endEditing(true)
            self.show_full_foodview(fooditem)

        }
        
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
                self.cancel_search_button.fadeIn()
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
        searchBar.textField.delegate = self
//        self.is_searching = true
        
        searchBar.alpha = 0
        searchBar.frame = CGRect(x: 0, y: 0, width: 300, height: 40)

        containerView.addSubview(searchBar)
        searchBar.fadeIn()
        searchBar.textField.returnKeyType = .Search
        searchBar.textField.becomeFirstResponder()
//        searchBar.clearButton.addTarget(self, action: "displayIcons", forControlEvents: .TouchUpInside)
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
        self.is_searching = false
        self.tableView.reloadData()

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
    
    
    
    // Textfield Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        print("Ended Editing")
        self.tableView.reloadData()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Return Pressed")
        textField.endEditing(true)
        return true 
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(textField.text)
        self.searchable_array.removeAll()
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.searchable_array.removeAll()
            var already_have = [String]()
            already_have.removeAll()
            
            if textField.text?.characters.count > 0{
                self.is_searching = true
                print("We are in")
                // Query for categories and fooditem
                
                let realm = try! Realm()
                let predicate = NSPredicate(format: "category CONTAINS[c] %@", textField.text!)
                var filtered_categories = realm.objects(Category).filter(predicate)
                print(filtered_categories.count)

                
                for each in filtered_categories{
                    if already_have.contains(each.category) == false{
                        print("We have a Category : \(each.category)")
                        var a_cat = Searchable()
                        a_cat.is_category = true
                        a_cat.category = each
                        self.searchable_array.append(a_cat)
                        already_have.append(each.category)
                    }else{
                        print("We have this Category")
                    }
                }
//                self.tableView.reloadData()
                

                // Query for fooditem
                    let f_realm = try! Realm()
                    let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@", textField.text!)

                    var filtered_fooditem = f_realm.objects(FoodItem).filter(searchPredicate)
                    print(filtered_fooditem.count)
                
                    for each in filtered_fooditem{
                        print("We have a FoodItem : \(each.title!)")
                        var a_food = Searchable()
                        a_food.is_category = false
                        a_food.fooditem = each
                        self.searchable_array.append(a_food)
                    }
                
                
            }else{
                // display regular categories
                self.is_searching = false
                self.searchable_array.removeAll()
                self.tableView.reloadData()
            }
            
            let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
            dispatch_after(timer, dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
//        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
//        dispatch_after(timer, dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//        }
        return true
    }
    
    
    

    
    
    
    
    // Categories Query   /    Run this in viewWillLoad
    func get_all_categories(){
        self.categories.removeAll()
        //Create an Array of all Categories
        print("Getting All Categories")
        let realm = try! Realm()
        let all_categories = realm.objects(Category)
        for each in all_categories{
            if self.categories.contains(each.category) == false && each.category != ""{
                self.categories.append(each.category)
                print("Appended : \(each.category)")
                self.tableView.reloadData()
            }else{
                print("self.categories Already Contains : \(each.category)")
            }
        }
    }
    
    
    
    
    
    
    
    
    // Show Fooditem
    func show_full_foodview(fooditem : FoodItem){
        print("Showing \(fooditem.title!)")
        
        self.add_tint()
        self.fullview = storyboard?.instantiateViewControllerWithIdentifier("Full_Food_VC") as! Full_Food_VC
        
        let xp = self.view.frame.width / 2 - (320 / 2)

        fullview!.view.frame = CGRect(x: xp, y: 0, width: 320, height: 512)
        fullview!.fooditem = fooditem
        fullview!.view.alpha = 0
        fullview!.doneButton.layer.cornerRadius = 6
//        fullview!.tableView.layer.cornerRadius = 12
//        fullview!.doneView.roundCorners([.BottomRight, .BottomLeft], radius: 21)
        fullview!.doneView.layer.masksToBounds = true
        fullview!.doneButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        fullview!.doneButton.addTarget(self, action: "get_all_categories", forControlEvents: .TouchUpInside)
        self.view.addSubview(fullview!.view)
        self.addChildViewController(fullview!)
        fullview!.view.fadeIn(duration: 0.3)

        
    }
    
    
    
    func add_tint(){
        self.tint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tint!.backgroundColor = UIColor.whiteColor()
        self.tint!.alpha = 0.4
        view.addSubview(self.tint!)
    }
    
    func remove_tint(){
        print("Removing Tint")
        self.tint!.fadeOut()
        self.tint!.alpha = 0
        self.fullview?.view.fadeOut()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fullview?.view.removeFromSuperview()
        }
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
        if segue.identifier == "view_cat"{
            var vc : CategoryItemsVC = segue.destinationViewController as! CategoryItemsVC
            vc.category = self.category
            if self.categoryColor != nil{
                vc.categoryColor = self.categoryColor
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
