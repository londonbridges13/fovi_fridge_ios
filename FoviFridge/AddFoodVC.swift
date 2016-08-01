//
//  AddFoodVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


class AddFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {

    
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var unwindToFridgeButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addFoodButton: UIButton!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var my_groceries = [FoodItem]()
    
    var tint : UIView?
    
    var foodView : Food_Quantity_View?
//    @IBOutlet var bottomView: UIView!
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addFoodButton.layer.cornerRadius = 2
        self.doneButton.layer.cornerRadius = 2

        
        
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
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return my_groceries.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("boughtItem", forIndexPath: indexPath) as! FoodItemCollectionViewCell
        
        if self.my_groceries[indexPath.row].image != nil{
            cell.foodImage.image = UIImage(data: self.my_groceries[indexPath.row].image!)
        }
        if self.my_groceries[indexPath.row].title != nil{
            cell.foodLabel.text = self.my_groceries[indexPath.row].title!
        }
        
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        show_food_item(my_groceries[indexPath.row])
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    
    
    
    
    // Get MyGroceries
    func get_groceries(){
        self.my_groceries.removeAll()
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
    
    
    
    
    
    
    @IBAction func doneWithFood(sender: AnyObject) {
        // Save FoodData, Unwind
//        unwindToFridgeButton.sendActionsForControlEvents(.TouchUpInside)
        
        performSegueWithIdentifier("DoneIt", sender: self)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addfood"{
            let vc: ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
            vc.segueStick = "addfood"
        }else{
            if segue is CustomUnwindSegue {
                (segue as! CustomUnwindSegue).animationType = .Push
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

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

