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


class ChooseFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, MiniDelegate {

    @IBOutlet weak var collViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collViewTopConstraint: NSLayoutConstraint!
    
//    var food = [1,2,3,4,4,5,5,3,3,3,3,3,3,34,4,5,56,6,6,7,7,7,78,8,89,8,7,67,6,6,5,5,4,4,4,54,6,7,8,9,9,90,9,8,7,6,5,4,43,3,2,2,2,1,1]//[String]()
    
    var i = 0
    
    var all_basicfooditems = [BasicFoodItem]()
    
    var segueStick: String?

    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var uniqueButton: UIButton!
    @IBOutlet var finishedButton: UIButton!
    
    @IBOutlet var myFoodColl: UIView!
    
    @IBOutlet var unwindAddFoodButton: UIButton!
    @IBOutlet var unwindShopListButton: UIButton!
    @IBOutlet var unwindNewCatButton: UIButton!

    @IBOutlet var uniqueBackground: UIView!
    
    var tint : UIView?
    var foodView : Food_Quantity_View?
    
    var mini : MyFoodMiniCVC?

    
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

        // MiniDelegate
        self.mini = childViewControllers.first as! MyFoodMiniCVC
        mini!.delegate = self
        
        // Run Query for BFI
        requestit()
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
        return all_basicfooditems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ChooseFoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! ChooseFoodItemCollectionViewCell

        cell.layer.cornerRadius = 12
        if all_basicfooditems[indexPath.row].title != nil{
            cell.foodLabel.text = all_basicfooditems[indexPath.row].title!
        }
        if all_basicfooditems[indexPath.row].image != nil{
            cell.foodImage.image = all_basicfooditems[indexPath.row].image!
        }
        
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell: ChooseFoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! ChooseFoodItemCollectionViewCell
        
        print("Selected")
        self.show_food_item(all_basicfooditems[indexPath.row])
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.collectionView.panGestureRecognizer.translationInView(self.view).y < 0.0 {
            
            if self.i == 0{
                let left = CGAffineTransformMakeTranslation(-300, 0)
                let right = CGAffineTransformMakeTranslation(300, 0)
                let down = CGAffineTransformMakeTranslation(0, 40)
                let minidown = CGAffineTransformMakeTranslation(0, 52)
                let up = CGAffineTransformMakeTranslation(0, -50)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    // self.container is your view that you want to animate
                    self.finishedButton.transform = down
                    self.myFoodColl.transform = minidown
                    self.uniqueButton.transform = up
                    self.uniqueBackground.transform = up
                    
                    self.collViewTopConstraint.constant = 50 // Top Constraint
                    self.collViewConstraint.constant = 89 //Bottom Constraint
                    
                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(90, 5, 10, 5)
                    //End
                    
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.0, options: [], animations: {
                    //
//                    self.searchBar.alpha = 1
                    
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

                    self.view.layoutIfNeeded()

                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5)
                    // End
                    
                    self.collViewTopConstraint.constant = 91 // Top Constraint
                    self.collViewConstraint.constant = 139 //Bottom Constraint
                    self.view.layoutIfNeeded()

//                    self.searchBar.endEditing(true)
                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
                    //
//                    self.searchBar.alpha = 0
                    
                    }, completion: nil)
                self.i = 0
            }
        }
        
        
    }

    
    

    // Query BFI
    //me
    func requestit() {
        Alamofire.request(.GET, "https://rocky-fjord-88249.herokuapp.com/api/v1/basic_food_items").responseJSON { (response) in
            print("prebuild")
//            print(response.result.value)
            if let usersArray = response.result.value as? NSArray {
                print("P1")
                for each in usersArray{
                    if let user = each as? NSDictionary{
                        var bfi = BasicFoodItem()
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
                            bfi.full_amount = full_amount!
                            bfi.current_amount = full_amount! // user just bought
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
                            bfi.usually_expires = usually_expires!
                        }
                        let fridge_usually_expires = user["fridge_usually_expires"] as? Int
                        print(fridge_usually_expires)
                        if fridge_usually_expires != nil{
                            bfi.fridge_usually_expires = fridge_usually_expires!
                        }

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
                            bfi.image_url = url!
                            KingfisherManager.sharedManager.retrieveImageWithURL(url!, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                                print(image)
                                bfi.image = image
                                self.all_basicfooditems.append(bfi)
                                
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
    func show_food_item(fooditem : BasicFoodItem){
        add_tint()
        
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying \(fooditem.title!)")
        
        var xp = self.view.frame.width / 2 - (250 / 2)
        
        self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: 50, width: 250, height: 400))
        foodView!.alpha = 0
        foodView!.fooditem.title = fooditem.title
        foodView!.fooditem.is_basic = fooditem.is_basic
        if fooditem.image != nil{
            foodView!.fooditem.image = UIImagePNGRepresentation(fooditem.image!)
        }
        foodView!.fooditem.fridge_usually_expires.value = fooditem.fridge_usually_expires
        foodView!.fooditem.usually_expires.value = fooditem.usually_expires
        foodView!.fooditem.measurement_type = fooditem.measurement_type
        foodView!.fooditem.food_category = fooditem.food_category
        foodView!.fooditem.full_amount.value = fooditem.full_amount
        foodView!.food_label.text = fooditem.title!
        foodView!.add_food_buttom.setTitle("Add \(fooditem.title!)", forState: .Normal)
        if fooditem.image != nil{
            foodView!.food_image.image = fooditem.image
        }
        foodView!.fadeIn(duration: 0.3)
        foodView!.add_food_buttom.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView!.remove_button.addTarget(self, action: "remove_tint", forControlEvents: .TouchUpInside)
        foodView?.add_food_buttom.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        foodView?.remove_button.addTarget(mini, action: "get_groceries", forControlEvents: .TouchUpInside)
        
        view.addSubview(foodView!)
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
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.foodView?.removeFromSuperview()
        }
    }
    

    // MiniDelegate
    //Display FoodView
    func show_grocery_item(fooditem : FoodItem){
        
        add_tint()
        
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying \(fooditem.title!)")
        
        var xp = self.view.frame.width / 2 - (250 / 2)
        
        self.foodView = Food_Quantity_View(frame: CGRect(x: xp, y: 50, width: 250, height: 400))
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
        view.addSubview(foodView!)
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
        
    }


}
