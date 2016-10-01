//
//  AddFoodVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift
import Material

class AddFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, SetExpirationDelegate  {

    
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var unwindToFridgeButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addFoodButton: UIButton!
    
    
    var my_groceries = [FoodItem]()
    
    var selected_fooditem = FoodItem()
    
    var cUser = UserDetails()
    
    var tint : UIView?
    
    var foodView : Food_Quantity_View?
//    @IBOutlet var bottomView: UIView!
    
    var searchable_array = [FoodItem]()
    var is_searching = false
    
    var set_expire_view : Set_Expiration_Alert?
    
    var dtint : UIView?

    
    
    private var containerView: UIView!
    
    /// Reference for SearchBar.
    private var searchBar: SearchBar! = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.userInteractionEnabled = true

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addFoodButton.layer.cornerRadius = 2
        self.doneButton.layer.cornerRadius = 2

        self.doneButton.addTarget(self, action: "add_food_to_fridge", forControlEvents: .TouchUpInside)
        self.addFoodButton.addTarget(self, action: "done_grocerybag_walkthrough", forControlEvents: .TouchUpInside)
        
        prepareView()
        prepareContainerView()
        prepareSearchBar()
        
        searchBar.textField.delegate = self
        

        
//        let realm = try! Realm()
//        var user = realm.objects(UserDetails).first
//        
//        if user != nil{
//            self.cUser = user!
//            if user!.grocery_bag_walkthrough == false{
//                // Run GroceryBag Walkthrough
//                print("Run GroceryBag Walkthrough")
//                groceryBag_walkthrough()
//            }else{ //user.grocery_bag_walkthrough == true
//                if user!.visit_shopping_list_walkthrough != true{
//                    // Display ready to update popover
//                    add_to_fridge_button_popover()
//                }
//            }
//        }
        
        // Query Objects
        self.get_groceries()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(450 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let realm = try! Realm()
            var user = realm.objects(UserDetails).first
            if user != nil{
                self.cUser = user!
                if user!.grocery_bag_walkthrough == false{
                    // Run GroceryBag Walkthrough
                    print("Run GroceryBag Walkthrough")
                    self.groceryBag_walkthrough()
                }else{ //user.grocery_bag_walkthrough == true
                    if user!.visit_shopping_list_walkthrough != true{
                        // Display ready to update popover
                        self.add_to_fridge_button_popover()
                    }
                }
            }
        }
        
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
            return my_groceries.count
        }else{
            return self.searchable_array.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if is_searching == false{

            let cell: FoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("boughtItem", forIndexPath: indexPath) as! FoodItemCollectionViewCell
            
            if self.my_groceries[indexPath.row].image != nil{
                cell.foodImage.image = UIImage(data: self.my_groceries[indexPath.row].image!)
            }
            if self.my_groceries[indexPath.row].title != nil{
                cell.foodLabel.text = self.my_groceries[indexPath.row].title!
            }
            
            cell.layer.cornerRadius = 15
            return cell
            
        }else{
            let cell: FoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("boughtItem", forIndexPath: indexPath) as! FoodItemCollectionViewCell
            
            if self.searchable_array[indexPath.row].image != nil{
                cell.foodImage.image = UIImage(data: self.searchable_array[indexPath.row].image!)
            }
            if self.searchable_array[indexPath.row].title != nil{
                cell.foodLabel.text = self.searchable_array[indexPath.row].title!
            }
            
            cell.layer.cornerRadius = 15
            
            return cell
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.is_searching == false{
            show_food_item(my_groceries[indexPath.row])
        }else{
            show_food_item(self.searchable_array[indexPath.row])
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    
    
    
    
    // Get MyGroceries
    func get_groceries(){
        self.my_groceries.removeAll()
        self.is_searching = false
        
        print("Querying Groceries")
        let realm = try! Realm()
        let predicate = NSPredicate(format: "mylist_amount > 0")

        var groceries = realm.objects(FoodItem).filter(predicate)
        
        for each in groceries{
            self.my_groceries.append(each)
            print("Added \(each.title) to My Groceries")
        }
        self.collectionView.reloadData()
        print(self.my_groceries)
        
    }
    
    
    
    
    
    
    
    
    //Display FoodView
    func show_food_item(fooditem : FoodItem){
        add_tint()
        
        selected_fooditem = fooditem
        
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying \(fooditem.title!)")
        
        var xp = self.view.frame.width / 2 - (250 / 2)
        
        self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: 50, width: 250, height: 400))
        foodView!.alpha = 0
        foodView!.fadeIn(duration: 0.3)
        foodView?.fooditem = fooditem
        foodView!.food_label.text = fooditem.title!
        foodView!.add_food_buttom.setTitle("Done", forState: .Normal)
        foodView?.add_food_buttom.addTarget(self, action: "get_groceries", forControlEvents: .TouchUpInside)
        foodView?.remove_button.addTarget(self, action: "get_groceries", forControlEvents: .TouchUpInside)

        if fooditem.image != nil{
            foodView!.food_image.image = UIImage(data: fooditem.image!)
        }
        foodView!.add_food_buttom.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.remove_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.expireButton.addTarget(self, action: "pre_display_set_expiration", forControlEvents: .TouchUpInside)
        view.addSubview(foodView!)
        
    }
    
    
    func add_tint(){
        self.tint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tint!.backgroundColor = UIColor.whiteColor()
        self.tint!.alpha = 0.4
        view.addSubview(self.tint!)
        if searchBar != nil{
            self.searchBar.textField.resignFirstResponder()// remove keyboard
        }
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
    
    
    
    
    // If User doesn't have item add it like this
    // If User does have item add it like this 
    
    func add_food_to_fridge(){
        
        for each in self.my_groceries{
            self.search_for_food_item(each)
        }
    }
    
    // Chain the functions together
    func search_for_food_item(each : FoodItem){
        let realm = try! Realm()
        print("Searcing for \(each.title!)")
        let predicate = NSPredicate(format: "title = '\(each.title!)'")
        var same_food = realm.objects(FoodItem).filter(predicate).first
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
         // Continue Here 
            if same_food != nil && each.is_basic == same_food?.is_basic{
                // User has this item
                print("SAME FOODITEM")
                self.check_oldnew_fooditem_date(each)
                try! realm.write({
                    
                    if each.fridge_usually_expires.value != nil{
                        same_food?.fridge_usually_expires.value = each.fridge_usually_expires.value!
                    }
                    if each.usually_expires.value != nil{
                        same_food?.usually_expires.value = each.usually_expires.value!
                    }
                    
//                    if same_food?.set_expiration.value != nil{
//                        self.check_oldnew_fooditem_date(each)
//                    }else{
//                        print("NO SET Expiration")
//                        self.check_oldnew_fooditem_date(each)
//                    }
                    if same_food?.fridge_amount.value == nil{
                        same_food?.fridge_amount.value = each.mylist_amount.value
                    }else{
                        var quantity = same_food!.fridge_amount.value! + each.mylist_amount.value!
                        same_food?.fridge_amount.value = quantity
                    }
                    same_food?.mylist_amount.value = 0
                    print("Saved, Fridge Amount = \(same_food?.fridge_amount.value)")
                    same_food?.previously_purchased = true
                    // Run Clear All mylist_amount value
                    self.double_clear()
                })
            }else{
                //New FooDitem
                print("NEW FOODITEM")
                self.check_oldnew_fooditem_date(each)
                try! realm.write({
//                    if each.set_expiration.value != nil{
//                    }else{
//                        print("NO SET Expiration")
//                        self.check_oldnew_fooditem_date(each)
//                    }
                    each.fridge_amount.value = each.mylist_amount.value
                    each.mylist_amount.value = 0
                    each.previously_purchased = true
                    print("Saved New Item, Fridge Amount = \(each.fridge_amount.value)")
                    realm.add(each)
                    
                    // Run Clear All mylist_amount value
                    self.double_clear()
                })
            }
        }
    }
    
    
    
    //Double-Clear all mylist_amount
    func double_clear(){
//        let realm = try! Realm()
//        var all_food = realm.objects(FoodItem)
//            try! realm.write {
//                for each in all_food{
//                    each.mylist_amount.value = 0
//                    print("Set \(each.title).mylist_amount = \(each.mylist_amount.value))")
//                }
//            }
        self.my_groceries.removeAll()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(260 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // Send Actions
            print("Sending Actions")
            self.doneButton.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    
    
    
    func update_fooditem_expiration_date(each : FoodItem){
        print("running update expiration")
        var today = NSDate()
        var setvalue = Double(each.set_expiration.value!)
        let added_days = setvalue * 86400
        let new_date = today.dateByAddingTimeInterval(added_days)
        print("\(each.title!) expiration date was updated from \(each.expiration_date)")
        print("to \(new_date)")
        let realm = try! Realm()
        try! realm.write({ 
            each.expiration_date = new_date
        })
        
    }
    
    // run the other update out of this one, should be smooth
    func check_oldnew_fooditem_date(each : FoodItem){
        let realm = try! Realm()
        try! realm.write({
            if each.set_expiration.value == nil{
                print("nil set expiration")
                // not set days left set = fridge usual days
                if each.fridge_usually_expires.value != nil{
                    each.set_expiration.value = each.fridge_usually_expires.value
                }else if each.usually_expires.value != nil{
                    each.set_expiration.value = each.usually_expires.value
                }else{
                    each.set_expiration.value = 12
                }
//                if each.set_expiration.value != nil{
//                    update_fooditem_expiration_date(each)
//                }
            }else{
                // just run other update
                print("not nil set expiration")
            }
        })
        update_fooditem_expiration_date(each)

    }
    
    
    
    
    
    // Search Items
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the containerView.
    private func prepareContainerView() {
        containerView = UIView()
//        view.layout(containerView).edges(top: 50, left: 20, right: 20)
        let wp = self.view.frame.width - 30
        
        containerView.frame = CGRect(x: 10, y: 50, width: wp, height: 40)
        self.view.addSubview(containerView)

    }
    
    /// Prepares the toolbar
    private func prepareSearchBar() {
        searchBar = SearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        searchBar.textField.returnKeyType = .Search
        containerView.addSubview(searchBar)
    }

    
    
    // Textfield
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.searchable_array.removeAll()

        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {

            self.searchable_array.removeAll()
            var already_have = [String]()
            already_have.removeAll()
            
            if textField.text?.characters.count > 0{
                self.is_searching = true
                
                let realm = try! Realm()
                let predicate = NSPredicate(format: "title CONTAINS[c] %@ AND mylist_amount > 0", textField.text!)
                var filtered_categories = realm.objects(FoodItem).filter(predicate)
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
    
    
    
    
    
    
    
    
    
    
    
    // Walkthroughs
    func groceryBag_walkthrough(){
        // Display Alert
        add_tint()
        self.tint?.backgroundColor = UIColor.blackColor()
        
        var alert = GroceryBagWalk_1()
        let xpp = self.view.frame.width / 2 - (200 / 2)
        alert.frame = CGRect(x: xpp, y: 80, width: 200, height: 300)
        alert.alpha = 0
        self.view.addSubview(alert)
        alert.fadeIn()
        alert.okayButton.addTarget(self, action: "walkthrough_part2", forControlEvents: .TouchUpInside)
        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
    }
    
    func walkthrough_part2(){
        //Display GroceryBag_2
        
        func add_food_button_popover(){
            print("Displaying Add Food Button Popover")
            
            let startPoint = CGPoint(x: 65, y: self.view.frame.height - 35)
            var aView = UIView(frame: CGRect(x: 0, y: 0, width: 203, height: 80))
            
            var label = UILabel(frame: CGRect(x: 9, y: 0, width: aView.frame.width - 20, height: aView.frame.height))
            label.numberOfLines = 0
            label.text = "Tap Here\nto add food to your Grocery Bag"
            label.font = UIFont(name: "Helvetica", size: 17)
            label.textColor = UIColor.grayColor()
            aView.addSubview(label)
            //lemon
            var lemon = UILabel(frame: CGRect(x: aView.frame.width - 27, y: 5, width: 30, height: 20))
            lemon.text = "🍐"
            aView.addSubview(lemon)
            
            var popoverOptions: [PopoverOption] = [
                .Type(.Up),
                .AnimationIn(0.3),
                .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.1))
            ]
            let popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
            popover.show(aView, point: startPoint, inView: self.view)
            
        }
        add_food_button_popover()

        // ALERT FOR WALKTHROUGH
//        var alert = GroceryBagWalk_2()
//        let xpp = self.view.frame.width / 2 - (209 / 2)
//        alert.frame = CGRect(x: xpp, y: 80, width: 209, height: 281)
//        alert.alpha = 0
//        self.view.addSubview(alert)
//        alert.fadeIn()
//        alert.okayButton.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
    }
    
    
    //Set Walkthrough to true
    func done_grocerybag_walkthrough(){
        let realm = try! Realm()
        
        try! realm.write {
            self.cUser.grocery_bag_walkthrough = true
            print("Set grocery_bag_walkthrough = \(self.cUser.grocery_bag_walkthrough)")
        }
    }
    
    
    
    // Ready to Update Fridge
    
    func add_to_fridge_button_popover(){
        print("Displaying Add Too Fridge Button Popover")
        
        let startPoint = CGPoint(x: self.view.frame.width - 65, y: self.view.frame.height - 36)
        var aView = UIView(frame: CGRect(x: 0, y: 0, width: 263, height: 60))
        
        var label = UILabel(frame: CGRect(x: 9, y: 0, width: aView.frame.width - 20, height: aView.frame.height))
        label.numberOfLines = 0
        label.text = "Ready to update your fridge?\nTap Here"
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textColor = UIColor.grayColor()
        aView.addSubview(label)
        //lemon
        var lemon = UILabel(frame: CGRect(x: aView.frame.width - 27, y: 33, width: 30, height: 20))
        lemon.text = "🍊"
        aView.addSubview(lemon)
        
        var popoverOptions: [PopoverOption] = [
            .Type(.Up),
            .AnimationIn(0.3),
            .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.1))
        ]
        let popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
        popover.show(aView, point: startPoint, inView: self.view)
        
    }
    

    
    
    
    
    
    
    
    
    
    //Set Expiration
    func pre_display_set_expiration(){
        // For the expireButton in the FoodQuantity_View
        display_set_expiration(self.selected_fooditem)
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
        
        let yp = self.view.frame.height / 2 - (250 / 2) - 30
        set_expire_view!.view.frame = CGRect(x: 0, y: yp, width: self.view.frame.width, height: 250)
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
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func doneWithFood(sender: AnyObject) {
        // Save FoodData, Unwind
        
        if self.my_groceries.count != 0{
            add_food_to_fridge()
        }else{

            performSegueWithIdentifier("DoneIt", sender: self)
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        self.collectionView.userInteractionEnabled = false
        if segue.identifier == "addfood"{
            let vc: ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
            vc.segueStick = "addfood"
        }else{
            // Going back to FridgeVC
            // If we have items to add, then display image "+Fridge"(with animation 'growing and fading') and then set realm fooditems.fridge_amount = mylist_amount, and then query all realm objects that have a value in mylist_amount set to = 0, then finally segueback
            
            if self.my_groceries.count != 0{
                //Display image
                var xpp = self.view.frame.width / 2 - (75 / 2)
                var ypp = self.view.frame.width / 2 - (75 / 2) - 20
                var plus_fridge_image = UIImageView(frame: CGRect(x: xpp, y: ypp, width: 75, height: 75))
                plus_fridge_image.alpha = 0
                plus_fridge_image.fadeIn()
                
//                //
//                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2060 * Double(NSEC_PER_MSEC)))
//                dispatch_after(delayTime, dispatch_get_main_queue()) {
//                    // Segue to FridgeVC
//                    if segue is CustomUnwindSegue {
//                        (segue as! CustomUnwindSegue).animationType = .Push
//                    }
//                }
                
            }else{
                // Segue to FridgeVC
                if segue is CustomUnwindSegue {
                    (segue as! CustomUnwindSegue).animationType = .Push
                }
            }
        }

    }
    
    @IBAction func unwindToAddFood(segue: UIStoryboardSegue){
        print("Unwind to AddFoodVC")
        //ReQuery Food
        self.get_groceries()
        
    }

    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
//        segue.animationType = .Push
//        return segue
//    }
    


}



