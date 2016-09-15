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
import MessageUI


class FridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YALTabBarDelegate, UITextFieldDelegate, MaterialDelegate, SettingCategory, DisplayFullFoodView, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {


    
    var categories = [String]()//[String]() // Change later
    var tint : UIView?
    var dtint : UIView?
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
    
    var cUser = UserDetails()
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDummyUser()
        
//        self.start()
        
        
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
        
        count_launch()
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        check_walkthrough()
        pre_get_all_categories()
//        get_all_categories()
        self.start()

        
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
            if self.categories[indexPath.row - 1] == "Missing"{
                cell.get_missing_food()
            }else{
                cell.get_fooditems(self.categories[indexPath.row - 1])
            }
            cell.design_category_button(indexPath.row)
            cell.categoryButton.setTitle("\(self.categories[indexPath.row - 1])", forState: .Normal)
            tableView.rowHeight = 148.0
            
            cell.alpha = 0
            cell.fadeIn(duration: 0.6)
            
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
    
    
    

    
    // Before Get Categories, Check for Missing/Expiring Fooditems
    func pre_get_all_categories(){
        print("PREPREPREPREPREPREPRE")
        
        self.categories.removeAll()
        
        let realm = try! Realm()
        var foods = realm.objects(FoodItem).filter("previously_purchased = \(true) AND fridge_amount = 0")
        
        if foods.count > 0{
            var missing  = "Missing"
            self.categories.append(missing)
            // Get the other categories
            self.get_all_categories()
        }else{
            print("No misising items here")
            // Get the other categories
            self.get_all_categories()
        }
    }
    
    
    
    // Categories Query   /    Run this in viewWillLoad
    func get_all_categories(){
//        self.categories.removeAll()
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
        fullview!.doneButton.addTarget(self, action: "pre_get_all_categories", forControlEvents: .TouchUpInside)
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
        self.fullview?.view.fadeOut()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tint!.alpha = 0
            self.fullview?.view.removeFromSuperview()
        }
    }
    
    
    func remove_dark_tint(){
        print("Removing Tint")
        self.dtint!.fadeOut()
        self.fullview?.view.fadeOut()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dtint!.alpha = 0
            self.fullview?.view.removeFromSuperview()
        }
    }

    
    
    // Starting Point
    func start(){
        
        //Version 1
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil {
            
            cUser = user!
            
            if user!.empty_fridge_walkthrough == false{
                // Run Walkthrough Alerts
                print("Running Walkthrough Alerts")
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1500 * Int64(NSEC_PER_MSEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.run_empty_fridge_walkthrough()
                }
                
            }else{
                // Check Visit ShoppingList Walkthrough Alerts
                print("Checking Visit ShoppingList Walkthrough Alerts")
                if user!.visit_shopping_list_walkthrough == false{
                    // Run Visit Shopping List Walkthrough Alerts
                    print("Running Visit ShoppingList Walkthrough Alerts")
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.visit_shopping_list()
                    }
                }else{
                    print("All Walkthroughs are Done")
                    // Check Surveys
                    
                    // Run fridge and shopping list walkthrough before surveys
                    // RUN THIS WHEN YOU ARE READY TO LEARN MORE ABOUT THE USER
//                    self.checkSurvey()  // Removing this is only temporary
                }
            }
            
        }else{
            // Create a user
            print("Creating New User")
            createDummyUser()
            
            
        }
        

    }
    
    
    
    // CheckPoint
    func check_walkthrough(){
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        
        if user?.visit_shopping_list_walkthrough == true{
            if self.tint?.alpha > 0{
                self.remove_tint()
            }
        }
    }
    
    
    // Walkthroughs
    
    // Empty Fridge Walkthroughs
    func run_empty_fridge_walkthrough(){
        // Display Alerts
        // Display EmptyFridge1
        
        print("Display Alert")
        
        var alert = EmptyFridge1()
        
        let xp = self.view.frame.width / 2 - (206 / 2)

        alert.frame = CGRect(x: xp, y: 90, width: 206, height: 200)
        alert.yesbutton.addTarget(self, action: "empty_fridge_alert2", forControlEvents: .TouchUpInside)
        
        alert.alpha = 0
        self.add_tint()
        UIView.animateWithDuration(0.3) {
            self.tint?.backgroundColor = UIColor.blackColor()
        }
        self.view.addSubview(alert)
        
        alert.fadeIn()
        
    }
    
    
    func empty_fridge_alert2(){
        // Display EmptyFridge2
        print("Display EmptyFridge2")
        
        var alert = EmptyFridge2()
        
        let xp = self.view.frame.width / 2 - (207 / 2)
        
        alert.frame = CGRect(x: xp, y: 90, width: 207, height: 245)
        alert.g_button1.addTarget(self, action: "go_to_groceries", forControlEvents: .TouchUpInside)
        alert.g_button2.addTarget(self, action: "go_to_groceries", forControlEvents: .TouchUpInside)
        
        alert.alpha = 0
        
        self.view.addSubview(alert)
        
        alert.fadeIn(duration: 0.3)
        
    }
    
    func go_to_groceries(){
        self.groceryBagButton.sendActionsForControlEvents(.TouchUpInside)
        
        self.tint?.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 500 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.tint?.removeFromSuperview()
        }
    }
    
    func visit_shopping_list(){
        // Display Alert 1 with Grocery Bag_ Alert1 
        print("Showing Visit Walkthrough Alerts")
        self.add_tint()
        UIView.animateWithDuration(0.3) {
            self.tint?.backgroundColor = UIColor.blackColor()
        }

        var alert = GroceryBagWalk_1()
        alert.bodyLabel.text = "Your Fridge is looking pretty good!"
        alert.headLabel.text = "Successfully added Groceries"
        let xpp = self.view.frame.width / 2 - (200 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 200, height: 250)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "walkthrough_part2", forControlEvents: .TouchUpInside)
        //        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
    }
    
    func walkthrough_part2(){
        // Display ShoppingList Alert2 (184)
        
        var alert = ShoppingList_Alert2()
        let xpp = self.view.frame.width / 2 - (300 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 300, height: 184)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "walkthrough_part3", forControlEvents: .TouchUpInside)

    }
    
    func walkthrough_part3(){
        // Display Shopping Alert3 (150)
        var alert = ShoppingList_Alert3()
        let xpp = self.view.frame.width / 2 - (300 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 300, height: 150)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "changeTint", forControlEvents: .TouchUpInside)

    }
    func changeTint(){
        UIView.animateWithDuration(0.3) {
            self.tint?.backgroundColor = UIColor.whiteColor()
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
//        let cUser = realm.objects(UserDetails).first
        if cUser != "nil"{
            print("shouldn't")
            if cUser.last_checked != nil{
                if getDayFromDate(cUser.last_checked!) != getDayFromDate(today){
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
    
    
    
    func count_launch(){
        var x_array = [Int]()
        var y_array = [Int]()
        var n = 1
        
        while n < 1000{
            let x = n * 20
            let y = n * 60
            print(x)
            print(y)
            x_array.append(x)
            y_array.append(y)
            n+=1
        }
        
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        if user != nil{
            print("There is a User")
            print("Checking Launch Count ... \(user!.launch_count)")
            print("User_Invited = \(user!.user_invited)")
            if x_array.contains(user!.launch_count) && user!.user_invited == false{
                // Display Invite Alert
                invite_friends()
            }
            if y_array.contains(user!.launch_count) == true && user!.user_invited == true{
                // Display Invite Alert
                invite_friends()
            }
        }else{
            print("There is no User")
        }
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
        alert.emailButton.addTarget(self, action: "sendEmail", forControlEvents: .TouchUpInside)
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
        let realm = try! Realm()
        let user = realm.objects(UserDetails).first
        try! realm.write({ 
            user!.user_invited = true
        })
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
        
        let realm = try! Realm()
        let user = realm.objects(UserDetails).first
        try! realm.write({
            user!.user_invited = true
        })
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
            let realm = try! Realm()
            let user = realm.objects(UserDetails).first
            try! realm.write({
                user!.user_invited = true
            })
        default:
            break;
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Email
    func sendEmail(){
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
            let realm = try! Realm()
            let user = realm.objects(UserDetails).first
            try! realm.write({
                user!.user_invited = true
            })
        }
    }
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.run_empty_fridge_walkthrough()
    }

}
