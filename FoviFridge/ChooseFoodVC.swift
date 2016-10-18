//
//  ChooseFoodVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Kingfisher
import Material

class ChooseFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, MiniDelegate, SetExpirationDelegate {

    @IBOutlet weak var collViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collViewTopConstraint: NSLayoutConstraint!
    
//    var food = [1,2,3,4,4,5,5,3,3,3,3,3,3,34,4,5,56,6,6,7,7,7,78,8,89,8,7,67,6,6,5,5,4,4,4,54,6,7,8,9,9,90,9,8,7,6,5,4,43,3,2,2,2,1,1]//[String]()
    
    var i = 0
    
    var all_fooditems = [FoodItem]()
    
    var actIndi : NVActivityIndicatorView?
    
    var segueStick: String?

    var selected_fooditem = FoodItem()
    
    var set_expire_view : Set_Expiration_Alert?

    var dtint : UIView?

    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var uniqueButton: UIButton!
    @IBOutlet var finishedButton: UIButton!
    
    @IBOutlet var myFoodColl: UIView!
    
    @IBOutlet var unwindAddFoodButton: UIButton!
    @IBOutlet var unwindShopListButton: UIButton!
    @IBOutlet var unwindNewCatButton: UIButton!
    @IBOutlet var unwindEditCatButton: UIButton!

    @IBOutlet var uniqueBackground: UIView!
    
    var tint : UIView?
    var foodView : Food_Quantity_View?
    
    var mini : MyFoodMiniCVC?

    var is_searching = false
    
    var cUser = UserDetails()
    
    var searchable_array = [FoodItem]()
    
    private var containerView: UIView!
    /// Reference for SearchBar.
    private var searchBar: SearchBar! = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.layer.cornerRadius = 9//15
        finishedButton.layer.cornerRadius = 4
        uniqueBackground.layer.cornerRadius = 13
        uniqueButton.layer.cornerRadius = 4
        collectionView.delegate = self
        collectionView.dataSource = self

        
        if segueStick != nil{
            print(segueStick)
        }else{
            print("segueStick = nil")
        }

        //Search Bar
        prepareContainerView()
        prepareSearchBar()

        
        // MiniDelegate
        self.mini = childViewControllers.first as! MyFoodMiniCVC
        mini!.delegate = self
        
        //Check Walkthrough
        let realm = try! Realm()
        var user = realm.objects(UserDetails).first
        
        if user != nil{
            self.cUser = user!
            if user!.grocery_store_walkthrough == false{
                // Run GroceryStore Walkthrough
                print("Run Grocery Store Walkthrough")
                groceryStore_walkthrough()
            }
        }

        
        // Run Query for BFI
        query_local_food_items()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if is_searching == false{
            return all_fooditems.count
        }else{
            return self.searchable_array.count
        }

        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if self.is_searching == false{
        let cell: ChooseFoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! ChooseFoodItemCollectionViewCell

        cell.layer.cornerRadius = 12
        if all_fooditems[indexPath.row].title != nil{
            cell.foodLabel.text = all_fooditems[indexPath.row].title!
        }
        if all_fooditems[indexPath.row].image != nil{
            cell.foodImage.image = UIImage(data: all_fooditems[indexPath.row].image!)
        }
        
        return cell
            
        }else{
            let cell: ChooseFoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! ChooseFoodItemCollectionViewCell
            
            cell.layer.cornerRadius = 12
            if all_fooditems[indexPath.row].title != nil{
                cell.foodLabel.text = searchable_array[indexPath.row].title!
            }
            if all_fooditems[indexPath.row].image != nil{
                cell.foodImage.image = UIImage(data: searchable_array[indexPath.row].image!)
            }
            
            return cell
        }
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell: ChooseFoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! ChooseFoodItemCollectionViewCell
        
        print("Selected")
        
        if self.segueStick == "NewCategory"{
            print("Adding it to Category")
            // Search for same_fooditem
            var fooditem = self.all_fooditems[indexPath.row]
            let realm = try! Realm()
            print("Searching Realm for \(fooditem.title!)")
            let predicate = NSPredicate(format: "title = '\(fooditem.title!)' AND is_basic = \(fooditem.is_basic)")
            var same_food = realm.objects(FoodItem).filter(predicate).first
            print("We have this item \(same_food?.title)")
            
            if same_food != nil{
                add_to_category(same_food!)
            }else{
                add_new_fooditem_category(fooditem)
            }

        }else if self.segueStick == "EditCategory"{
            print("Adding to Category")
            
            if self.is_searching == false{
                var fooditem = all_fooditems[indexPath.row]
                let realm = try! Realm()
                try! realm.write({ 
                    fooditem.mylist_amount.value = 1
                })
                mini?.get_groceries()
            }else{
                var fooditem = searchable_array[indexPath.row]
                let realm = try! Realm()
                try! realm.write({
                    fooditem.mylist_amount.value = 1
                })
                mini?.get_groceries()
            }

        }else{
            if self.is_searching == false{
                self.show_food_item(all_fooditems[indexPath.row])
            }else{
                self.show_food_item(searchable_array[indexPath.row])
                searchBar.textField.endEditing(true)
            }
        }
    }
    
  
//    Removing Scroll Animation
    /*
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.collectionView.panGestureRecognizer.translationInView(self.view).y < 0.0 {
            
            if self.i == 0{
                let left = CGAffineTransformMakeTranslation(-300, 0)
                let right = CGAffineTransformMakeTranslation(300, 0)
                let down = CGAffineTransformMakeTranslation(0, 40)
                let minidown = CGAffineTransformMakeTranslation(0, 52)
                let up = CGAffineTransformMakeTranslation(0, -50)
                let search_up = CGAffineTransformMakeTranslation(0, -40)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    // self.container is your view that you want to animate
                    self.finishedButton.transform = down
                    self.myFoodColl.transform = minidown
                    self.uniqueButton.transform = up
                    self.uniqueBackground.transform = up
//                    self.searchBar.transform = search_up
                    self.containerView.transform = search_up
                    self.collViewTopConstraint.constant = 50 // Top Constraint
                    self.collViewConstraint.constant = 89 //Bottom Constraint
                    
                    self.searchBar.height = 36
                    
                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(90, 5, 10, 5)
                    //End
                    
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.0, options: [], animations: {
                    //
                    
                    }, completion: nil)
                self.i = 1
            }
            
            
        }else{
            
            if self.i == 1{
                let left = CGAffineTransformMakeTranslation(-300, 0)
                let right = CGAffineTransformMakeTranslation(300, 0)
                let back = CGAffineTransformMakeTranslation(0, 0)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    // self.container is your view that you want to animate
                    self.finishedButton.transform = back
                    self.myFoodColl.transform = back
                    self.uniqueButton.transform = back
                    self.uniqueBackground.transform = back
                    self.searchBar.transform = back
                    self.containerView.transform = back
                    self.searchBar.height = 30

                    self.view.layoutIfNeeded()

                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5)
                    // End
                    
                    self.collViewTopConstraint.constant = 91 // Top Constraint
                    self.collViewConstraint.constant = 139 //Bottom Constraint
                    self.view.layoutIfNeeded()

                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
                    //
                    
                    }, completion: nil)
                self.i = 0
            }
        }
        
        
    }
*/
    
    
    // Search Bar 
    
    /// Prepares the containerView.
    private func prepareContainerView() {
        containerView = UIView()
        //        view.layout(containerView).edges(top: 50, left: 20, right: 20)
        let wp = self.view.frame.width - 60
        
        containerView.frame = CGRect(x: 10, y: 50, width: wp, height: 30)
        self.view.addSubview(containerView)
        
    }
    
    /// Prepares the toolbar
    private func prepareSearchBar() {
        searchBar = SearchBar()
        let wp = self.view.frame.width - 60

        searchBar.frame = CGRect(x: 0, y: 0, width: wp, height: 30)
        searchBar.textField.returnKeyType = .Search
        searchBar.textField.delegate = self
        searchBar.textField.returnKeyType = .Search
        containerView.addSubview(searchBar)
    }
    

    // TextField
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        self.searchable_array.removeAll()
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            self.searchable_array.removeAll()
            var already_have = [String]()
            already_have.removeAll()
            
            if textField.text?.characters.count > 0{
                self.is_searching = true
                
//                let realm = try! Realm()
//                let predicate = NSPredicate(format: "title CONTAINS[c] %@", textField.text!)
//                var filtered_categories = self.all_fooditems.filter(predicate)
                
                let filtered_categories = self.all_fooditems.filter {
                    $0.title!.rangeOfString(textField.text!, options: .CaseInsensitiveSearch) != nil
                }
                
                print(filtered_categories.count)
                
                
                for each in filtered_categories{
                    //                    if already_have.contains(each.title!) == false{
                    print("We have the Food : \(each.title!)")
                    self.searchable_array.append(each)
                    //                        already_have.append(each.title!)
                    //                    }else{
                    //                        print("We have this Category")
                    //                    }
                }
            }else{
                self.is_searching = false
                self.collectionView.reloadData()
            }
            let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
            dispatch_after(timer, dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }

        
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }


    
    // New Category
    func add_to_category(fooditem : FoodItem){
        let realm = try! Realm()
        try! realm.write({ 
            fooditem.mylist_amount.value = 1
        })
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 200 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.mini?.get_groceries()
        }
    }
    
    
    func add_new_fooditem_category(fooditem : FoodItem){
        // This is for when the user adds a new fooditem to the category . We have to do this because this fooditem doesin't exist in the db, so we can't just tweak it like we did in the function above.
        let realm = try! Realm()
        try! realm.write({ 
            fooditem.mylist_amount.value = 1
            realm.add(fooditem)
        })
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 200 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.mini?.get_groceries()
        }
    }
    
    
    // Query Local Food Items
    func query_local_food_items(){
        loading()
        
        self.all_fooditems.removeAll()
        collectionView.reloadData()
        
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "is_basic = \(false)")
        let local_items = realm.objects(FoodItem).filter(predicate)
        print(local_items.count)
        
        for each in local_items{
            self.all_fooditems.append(each)
            print("Appended \(each.title)")
        }
        
        self.requestit()

        
    }
    
    
    
    // Query Basic Food Items
    //me
    func requestit() {
        Alamofire.request(.GET, "https://rocky-fjord-88249.herokuapp.com/api/v1/basic_food_items").responseJSON { (response) in
            print("prebuild")
//            print(response.result.value)
            if let usersArray = response.result.value as? NSArray {
                print("P1")
                for each in usersArray{
                    if let user = each as? NSDictionary{
                        var bfi = FoodItem()
                        let name = user["title"] as? String
                        print(name)
                        if name != nil{
                            bfi.title = name!
                        }
                        let measurement_type = user["measurement_type"] as? String
                        print(measurement_type)
                        if measurement_type != nil{
                            bfi.measurement_type = measurement_type!
                        }
                        let full_amount = user["full_amount"] as? Float
                        print(full_amount)
                        if full_amount != nil{
                            bfi.full_amount.value = full_amount!
                            bfi.current_amount.value = full_amount! // user just bought
                        }
                        
//                        let current_amount = user["current_amount"] as? Float
//                        print(current_amount)
//                        if current_amount != nil{
//                            bfi.current_amount = current_amount!
//                        }
                        let food_category = user["food_category"] as? String
                        print(food_category)
                        if food_category != nil{
                            bfi.food_category = food_category!
                        }
//                        let fridge_amount = user["fridge_amount"] as? Int
//                        print(fridge_amount)
//                        if fridge_amount != nil{
//                            bfi.fridge_amount = fridge_amount!
//                        }
//                        let shoppingList_amount = user["shoppingList_amount"] as? Int
//                        print(shoppingList_amount)
//                        if shoppingList_amount != nil{
//                            bfi.shoppingList_amount = shoppingList_amount!
//                        }
//                        let mylist_amount = user["mylist_amount"] as? Int
//                        print(mylist_amount)
//                        if mylist_amount != nil{
//                            bfi.mylist_amount = mylist_amount!
//                        }
                        let usually_expires = user["usually_expires"] as? Int
                        print(usually_expires)
                        if usually_expires != nil{
                            bfi.usually_expires.value = usually_expires!
                        }
                        let fridge_usually_expires = user["fridge_usually_expires"] as? Int
                        print(fridge_usually_expires)
                        if fridge_usually_expires != nil{
                            bfi.fridge_usually_expires.value = fridge_usually_expires!
                        }

                        bfi.is_basic = true
//                        let image_url = user["image_url"] as? String
                        
                        var imageu = user["image"] as? String
                        if imageu != nil{
                            
                            //KF
                            // Get range of all characters past the first 6.
                            let range = imageu!.startIndex.advancedBy(4)..<imageu!.endIndex
                            
                            // Access the substring.
                            let sub_url = imageu![range]
                            
                            print("This is the url : https\(sub_url)")
                            var url = NSURL(string: "https\(sub_url)")
//                            bfi.image_url = url!  // Dont have image_url in realm db
                            KingfisherManager.sharedManager.retrieveImageWithURL(url!, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                                print(image)
                                bfi.image = UIImagePNGRepresentation(image!)
                                self.all_fooditems.append(bfi)
                                
                                self.collectionView.reloadData()
                            })
                        }
                        //EndKF

                        print("Added \(bfi.title) to BFIs")
//                        self.collectionView.reloadData()
                    }
                }
            }
            if let JSON = response.result.value{// as? Array<Dictionary<String,AnyObject>> {
                print("Here's JSON")
                print(JSON)
            }
        }
    }

    
    
    
    
    
    
    
    
    
    //Display FoodView
    func show_food_item(fooditem : FoodItem){
        add_tint()
        
        self.selected_fooditem = fooditem
        
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying \(fooditem.title!)")
        
        var xp = self.view.frame.width / 2 - (250 / 2)
        
        self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: 50, width: 250, height: 400))
        foodView!.alpha = 0
        foodView!.fooditem.title = fooditem.title
        foodView!.fooditem.is_basic = fooditem.is_basic
        foodView!.fooditem = fooditem
//        if fooditem.image != nil{
//            foodView!.fooditem.image = UIImagePNGRepresentation(fooditem.image!)
//        }
//        foodView!.fooditem.fridge_usually_expires.value = fooditem.fridge_usually_expires
//        foodView!.fooditem.usually_expires.value = fooditem.usually_expires
//        foodView!.fooditem.measurement_type = fooditem.measurement_type
//        foodView!.fooditem.food_category = fooditem.food_category
//        foodView!.fooditem.full_amount.value = fooditem.full_amount
        foodView!.food_label.text = fooditem.title!
        foodView!.add_food_buttom.setTitle("Add \(fooditem.title!)", forState: .Normal)
        if fooditem.image != nil{
            foodView!.food_image.image = UIImage(data: fooditem.image!)
        }
        foodView!.fadeIn(duration: 0.3)
        foodView!.add_food_buttom.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.remove_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView?.add_food_buttom.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        foodView?.remove_button.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        
        foodView!.add_food_buttom.addTarget(self, action: "pre_set_food_expiration", forControlEvents: .TouchUpInside)
        foodView!.expireButton.addTarget(self, action: "pre_display_set_expiration", forControlEvents: .TouchUpInside)
        view.addSubview(foodView!)
    }
    
    
    func add_tint(){
        self.tint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tint!.backgroundColor = UIColor.blackColor()
        self.tint!.alpha = 0.4
        view.addSubview(self.tint!)
    }
    
    func remove_tint(){
        print("Removing Tint")
        self.tint!.fadeOut()
        self.tint!.alpha = 0
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.foodView?.removeFromSuperview()
        }
    }
    
    func pre_set_food_expiration(){
        // setting selected_fooditem to fooditem for easier use
        var fooditem = self.selected_fooditem
        // Must get updated fooditem from get_fooditem func. This wasn't working before because the mylist is default set to nil, get.
        self.get_fooditem(self.selected_fooditem)
        // a checkpoint
        print("HHH")
        // giving realm a second to set selected_fooditem to updated_fooditem
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            // should be a newer fooditem
            if self.selected_fooditem.mylist_amount.value > 0{
                // second checkpoint
                print("HHH")
                // the case, run it
                self.set_food_expiration(fooditem)
            }
        }
    }
    func set_food_expiration(fooditem : FoodItem){
        //display set_expiration Alert
        //send fooditem over
        
        let realm = try! Realm()
        print("Searching Realm for \(fooditem.title!)")
        let predicate = NSPredicate(format: "title = '\(fooditem.title!)' AND is_basic = \(fooditem.is_basic)")
        var same_food = realm.objects(FoodItem).filter(predicate).first
        print("We have this item \(same_food?.title)")

        if same_food?.set_expiration.value == nil{
            // No fooditem, display set ex_alert
            
            display_set_expiration(same_food!)
        }else if same_food == nil{
            display_set_expiration(fooditem)
        }
    }

    
    
    
    func get_fooditem(oldfooditem : FoodItem){
        // This is to refresh the fooditem when you update it's values from another ViewController
        let realm = try! Realm()
        var new_fooditem = realm.objects(FoodItem).filter("title = '\(oldfooditem.title!)' AND is_basic == \(true)").first
        if new_fooditem != nil{
            print("Found your new \(new_fooditem?.title)")
            self.selected_fooditem = new_fooditem!
        }
    }
    

    
    
    
    
    
    // MiniDelegate
    //Display FoodView
    func show_grocery_item(fooditem : FoodItem){
        
        add_tint()
        
        self.selected_fooditem = fooditem

        
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying \(fooditem.title!)")
        
    
        if self.segueStick == "NewCategory"{
            var yp = self.view.frame.height / 2 - (221 / 2)
            var xp = self.view.frame.width / 2 - (250 / 2)
            self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: yp, width: 250, height: 221))
            foodView!.stepper.alpha = 0
            foodView!.expireButton.alpha = 0
        }else{
            // Regular
            var xp = self.view.frame.width / 2 - (250 / 2)
            var yp = self.view.frame.height / 2 - (400 / 2)
            self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: 50, width: 250, height: 400))
        }
        
        foodView!.alpha = 0
        foodView!.fadeIn(duration: 0.3)
        foodView?.fooditem = fooditem
        foodView!.food_label.text = fooditem.title!
        foodView!.add_food_buttom.setTitle("Done", forState: .Normal)
        foodView?.add_food_buttom.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        foodView?.remove_button.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        
        if fooditem.image != nil{
            foodView!.food_image.image = UIImage(data: fooditem.image!)
        }
        foodView!.add_food_buttom.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.remove_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.expireButton.addTarget(self, action: "pre_display_set_expiration", forControlEvents: .TouchUpInside)

       
        
        view.addSubview(foodView!)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func loading(){
        // show loading indicator
//        var xp = view.frame.width / 2 - ((100) / 2)
        var yp = view.frame.height / 2 - ((view.bounds.width) / 2) - 50
        
        var loadview = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        
        let bluecolor = UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1)
        loadview.backgroundColor = bluecolor
        loadview.layer.cornerRadius = 9
        
        self.view.addSubview(loadview)
        
        let vdelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(vdelayTime, dispatch_get_main_queue()) {
            
            var size : CGFloat = 37
            var xxp = loadview.frame.width / 2 - (size / 2)
            var hp = loadview.frame.height / 2 - (size / 2)
            let frame = CGRect(x: xxp, y: hp, width: size, height: size)
            
            self.actIndi = NVActivityIndicatorView(frame: frame, type: .LineScale, color: UIColor.whiteColor(), padding: 3)
            self.actIndi?.startAnimation()
            self.actIndi?.alpha = 0
            
            loadview.addSubview(self.actIndi!)
            
            self.actIndi?.fadeIn(duration: 0.2)
        }
        
        let ldelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2350 * Double(NSEC_PER_MSEC)))
        dispatch_after(ldelayTime, dispatch_get_main_queue()) {
            loadview.fadeOut(duration: 0.6)
            
        }
    }

    
    
    
    
    
    
    
    
    // Walkthrough
    func groceryStore_walkthrough(){
        // Display Alert 1
        add_tint()
        self.tint?.backgroundColor = UIColor.blackColor()
        
        var alert = GroceryBagWalk_1()
        alert.bodyLabel.text = "Select your food here and they will appear in the Grocery Bag"
        alert.headLabel.text = "This is the Grocery Store"
        let xpp = self.view.frame.width / 2 - (200 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 200, height: 250)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "walkthrough_part2", forControlEvents: .TouchUpInside)
        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
    }
    
//    func walkthrough_part2(){
//        UIView.animateWithDuration(0.3) { 
//            self.tint?.backgroundColor = UIColor.clearColor()
//        }
//        var alert = GroceryStore_Alert2()
//        alert.bodyLabel.text = "Select from the items up here..."
//        let xpp = self.view.frame.width / 2 - (310 / 2)
//        alert.frame = CGRect(x: xpp, y: 0, width: 310, height: 107)
//        alert.alpha = 0
//        self.view.addSubview(alert)
//        alert.fadeIn()
//        alert.okayButton.addTarget(self, action: "walkthrough_part3", forControlEvents: .TouchUpInside)
//    }
//    
//    func walkthrough_part3(){
//        
//        var alert = GroceryStore_Alert2()
//        let xpp = self.view.frame.width / 2 - (310 / 2)
//        let ypp = self.view.frame.height - 115
//        alert.frame = CGRect(x: xpp, y: ypp, width: 310, height: 107)
//        alert.alpha = 0
//        self.view.addSubview(alert)
//        alert.fadeIn()
//        alert.okayButton.addTarget(self, action: "walkthrough_part4", forControlEvents: .TouchUpInside)
//    }
    func walkthrough_part2(){
//        UIView.animateWithDuration(0.3) {
//            self.tint?.backgroundColor = UIColor.blackColor()
//        }
        
        
        func create_button_popover(){
            print("Displaying Create Fooditem Popover")
            
            var secondPopoverOptions: [PopoverOption] = [
                .Type(.Down),
                .AnimationIn(0.3),
                //            .AnimationOut(0.3),
                .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.1))
            ]
            
            let startPoint = CGPoint(x: 45, y: 36)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
            var label = UILabel(frame: CGRect(x: 9, y: 0, width: aView.frame.width - 20, height: aView.frame.height))
            label.numberOfLines = 0
            label.text = "If you don't see your food, create it here"
            label.font = UIFont(name: "Helvetica", size: 18)
            label.textColor = UIColor.grayColor()
            aView.addSubview(label)
            // peach 🍋
            var peach = UILabel(frame: CGRect(x: aView.frame.width - 30, y: 30, width: 30, height: 20))
            peach.text = "🍑"
            aView.addSubview(peach)
            
            let popover = Popover(options: secondPopoverOptions, showHandler: nil, dismissHandler: walkthrough_part3)
            popover.show(aView, point: startPoint, inView: self.view)
            
            
        }
        create_button_popover()
        
        // ALERT FOR WALKTHROUGH
        // Display Alert 4
//        var alert = GroceryStore_Alert4()
//        alert.justLabel.alpha = 0
//        alert.finishButton.alpha = 0
//        let xpp = self.view.frame.width / 2 - (300 / 2)
//        alert.frame = CGRect(x: xpp, y: 100, width: 300, height: 200)
//        alert.alpha = 0
//        self.view.addSubview(alert)
//        alert.fadeIn(duration: 0.3)
//        alert.okayButton.addTarget(self, action: "walkthrough_part3", forControlEvents: .TouchUpInside)
    }
    
    func walkthrough_part3(){

        
        func finished_button_popover(){
            print("Displaying Finished Button Popover")
            
            let startPoint = CGPoint(x: 51, y: self.view.frame.height - 36)
            var aView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 60))
            
            var label = UILabel(frame: CGRect(x: 9, y: 0, width: aView.frame.width - 20, height: aView.frame.height))
            label.numberOfLines = 0
            label.text = "And when you are finished, just let us know"
            label.font = UIFont(name: "Helvetica", size: 18)
            label.textColor = UIColor.grayColor()
            aView.addSubview(label)
            //lemon
            var lemon = UILabel(frame: CGRect(x: aView.frame.width - 27, y: 33, width: 30, height: 20))
            lemon.text = "🍋"
            aView.addSubview(lemon)
            
            var popoverOptions: [PopoverOption] = [
                .Type(.Up),
                .AnimationIn(0.3),
                .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.1))
            ]
            let popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: done_walkthrough)
            popover.show(aView, point: startPoint, inView: self.view)
            
        }
        finished_button_popover()

        
        // ALERT FOR WALKTHROUGH
        // Display Alert 5
//        var alert = GroceryStore_Alert4()
//        alert.bodyLabel.text = "And finally when you're finished..."
//        alert.createButton.alpha = 0
//        let xpp = self.view.frame.width / 2 - (300 / 2)
//        alert.frame = CGRect(x: xpp, y: 100, width: 300, height: 200)
//        alert.alpha = 0
//        self.view.addSubview(alert)
//        alert.fadeIn(duration: 0.3)
//        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
//        alert.okayButton.addTarget(self, action: "done_walkthrough", forControlEvents: .TouchUpInside)
    }
    
    
    func done_walkthrough(){
        print("Done Walkthrough")
        let realm = try! Realm()
        
        try! realm.write({ 
            self.cUser.grocery_bag_walkthrough = true
            self.cUser.empty_fridge_walkthrough = true
            self.cUser.grocery_store_walkthrough = true
        })
    }
    
    
    
    
    
    
    // SET EXPIRATION ALERT
    func pre_display_set_expiration(){
        // For the expireButton in the FoodQuantity_View
        
        let realm = try! Realm()
        print("Searching Realm for \(selected_fooditem.title!)")
        let predicate = NSPredicate(format: "title = '\(selected_fooditem.title!)' AND is_basic = \(selected_fooditem.is_basic)")
        var same_food = realm.objects(FoodItem).filter(predicate).first

        if same_food != nil{
            selected_fooditem = same_food!
        }
        
        let timer = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
        dispatch_after(timer, dispatch_get_main_queue()) {

            if same_food != nil{
                self.display_set_expiration(same_food!)
            }else{
                self.display_set_expiration(self.selected_fooditem)
            }
        }
    }

    func display_set_expiration(fooditem : FoodItem){
        self.dtint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dtint!.backgroundColor = UIColor.blackColor()
        dtint!.tintColor = UIColor.blackColor()
        dtint!.alpha = 0.4
        view.addSubview(self.dtint!)
        
        self.set_expire_view = storyboard?.instantiateViewControllerWithIdentifier("Set_Expiration_Alert") as! Set_Expiration_Alert
        
        set_expire_view!.fooditem = fooditem
        set_expire_view!.delegate = self
        
        let yp = self.view.frame.height / 2 - (320 / 2) - 30
        set_expire_view!.view.frame = CGRect(x: 0, y: yp, width: self.view.frame.width, height: 320)
        set_expire_view!.view.alpha = 0
        self.view.addSubview(set_expire_view!.view)
        
        set_expire_view!.view.fadeIn(duration: 0.5)
    }
    
    
    func remove_dtint(){
        self.dtint?.fadeOut(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.dtint?.removeFromSuperview()
        }
    }
    
    // Delegate
    func remove_set_Expiration_Alert(){
        print("Delegate in Action")
        self.set_expire_view?.view.fadeOut(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.set_expire_view?.view.removeFromSuperview()
        }
        self.remove_dtint()
        
    }
    
    func displayEnterInputAlert(){
        var fooditem = self.selected_fooditem

        self.set_expire_view?.view.fadeOut(duration: 0.3)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 250 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.set_expire_view?.view.removeFromSuperview()
        }
        
        
        let alert = EnterInput_Alert()
        let yp = self.view.frame.height / 2 - (261 / 2) - 30
        let xp = self.view.frame.width / 2 - (187 / 2)
        alert.frame = CGRect(x: xp, y: yp, width: 187, height: 261)
        alert.fooditem = fooditem
        if fooditem.set_expiration.value != nil{
            alert.daysTX.text = "\(fooditem.set_expiration.value!)"
        }
        alert.doneButton.addTarget(self, action: "remove_dtint", forControlEvents: .TouchUpInside)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn(duration: 0.45)
        
        
    }
    

    
    
    
    
    
    
    //Segue Back to AddFoodVC
    @IBAction func pressedFinished(sender: AnyObject) {
        //Save Data to realm, unwind segue
        
        if segueStick == "addfood"{
            unwindAddFoodButton.sendActionsForControlEvents(.TouchUpInside)

        }else if segueStick == "shopping"{
            unwindShopListButton.sendActionsForControlEvents(.TouchUpInside)
        }else if segueStick == "NewCategory"{
            self.unwindNewCatButton.sendActionsForControlEvents(.TouchUpInside)
        }else if segueStick == "EditCategory"{
            self.unwindEditCatButton.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToChooseVC(segue: UIStoryboardSegue){
        print("Unwind to ChooseFoodVC")
        //ReQuery Food
        self.query_local_food_items()
        self.mini?.get_groceries()
    }


}
