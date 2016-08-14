//
//  CategoryItemsVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var categoryLabel : UILabel!
    
    @IBOutlet var createCatButton : UIButton!
    
    var category : String?
    var categoryColor : UIColor?
    
    var edit_categoryVC : EditCategoryVC?
    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var edit_width: NSLayoutConstraint!
    
    var dtint : UIView?
    
    var food = [FoodItem]()
    
    var blue = UIColor(red: 0/255, green: 153/255, blue: 241/255, alpha: 1)
    
    var fireRed = UIColor(red: 237/255, green: 90/255, blue: 80/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(category)
        print(categoryColor)
        self.categoryLabel.text = category!
        if categoryColor != nil{
            categoryLabel.textColor = categoryColor!
        }
        
        // Edit Button
        self.editButton.layer.cornerRadius = 3
        self.editButton.layer.borderColor = blue.CGColor
        self.editButton.layer.borderWidth = 1.25
        
        //Category Button
        self.createCatButton.layer.cornerRadius = 3
        self.createCatButton.layer.borderColor = fireRed.CGColor
        self.createCatButton.layer.borderWidth = 1.25
        
        
        // Tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self

        get_cat_food(self.category!)
        
        
        // Do any additional setup after loading the view.
    }

    func delete_this(){
        let realm = try! Realm()
        var thiscat = realm.objects(Category).filter(NSPredicate(format:"category = 'Pantry'"))
        print("This is P.count \(thiscat.count)")
        try! realm.write{
            for each in thiscat{
                realm.delete(each)
                print("Deleted")
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func unwindToCatItems(segue: UIStoryboardSegue){
        print("Back to Category")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 200 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.addFood_from_mylist()
        }
    }

    
    
    @IBAction func edit(sender: AnyObject) {
        print("Pressed Edit")
        edit_category()
    }
    
    
    
    func addFood_from_mylist(){
        let realm = try! Realm()
        
        print("Category before Change Label: \(self.category!)")
        self.changeTitleLabel()
        
        var mylist = realm.objects(FoodItem).filter(NSPredicate(format: "mylist_amount > 0"))
        var a_cat = Category()
        a_cat.category = self.category!
        try! realm.write({ 
            for each in mylist{
                print("Adding \(a_cat.category) to \(each.title)")
                each.category.append(a_cat)
                print(each)
                each.mylist_amount.value = 0
            }
            print("Category After ChangeLabel: \(self.category!)")
            self.get_cat_food(self.category!)
            self.edit_categoryVC?.get_cat_food(self.category!)
        })
        
    }
    
    
    func check_for_others(){
        // check for more food, if none then delete category
        let realm = try! Realm()
        let predicate = NSPredicate(format: "ANY category.category CONTAINS[c] %@", self.category!)
        var check = realm.objects(FoodItem).filter(predicate)
        
        if check.count == 0{
            // Delete the Category
            delete_none()
        }
    }
    
    
    func delete_none(){
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "category = '\(self.category!)'")
        var it = realm.objects(Category).filter(predicate)
        for each in it{
            try! realm.write{
                print(each.category)
                realm.delete(each)
                print("GoneDeleted")
            }
        }
    }
    
    
    
    
    //Tableview
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CategoryFoodItemCell = tableview.dequeueReusableCellWithIdentifier("CategoryFoodItemCell", forIndexPath: indexPath) as! CategoryFoodItemCell
        cell.foodImage.image = UIImage(data: self.food[indexPath.row].image!)
        cell.foodLabel.text = self.food[indexPath.row].title!
        
        tableview.rowHeight = 65
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
  
    
    
    
    
    
    
    
    
    // QUERY Food in Category
    
    func get_cat_food(cat : String){
        self.food.removeAll()
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "ANY category.category CONTAINS[c] %@", cat)
        var all_cat_food = realm.objects(FoodItem).filter(predicate)
        for each in all_cat_food{
            print("\(each.title!)")
            self.food.append(each)
            
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 300 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.tableview.reloadData()
        }
    }
    
    
    
    
    func add_food_toCat(){
        print("Going")
        performSegueWithIdentifier("EditCategory_AddFood", sender: self)
    }
    
    
    
    func done_edit(){
        self.food.removeAll()
        self.get_cat_food(self.category!)
    }
    
    
    
    
    
    
    
    
    // Edit Category
    
    func edit_category(){
        
        self.edit_categoryVC = storyboard?.instantiateViewControllerWithIdentifier("EditCategoryVC") as! EditCategoryVC
        var xp = self.view.frame.width / 2 - (320 / 2)
        var hp = self.view.frame.height - 39

        edit_categoryVC?.view.frame = CGRect(x: xp, y: 39, width: 320, height: hp)
        edit_categoryVC?.view.layer.cornerRadius = 9
        edit_categoryVC?.view.layer.masksToBounds = true
        
        edit_categoryVC!.category = "kl"//self.category!
        
     
        edit_categoryVC?.get_cat_food(self.category!)
        edit_categoryVC?.doneButton.addTarget(self, action: "done_edit", forControlEvents: .TouchUpInside)
        edit_categoryVC?.doneButton.addTarget(self, action: "stop_edit", forControlEvents: .TouchUpInside)
        edit_categoryVC?.doneButton.addTarget(self, action: "check_for_others", forControlEvents: .TouchUpInside)
        edit_categoryVC?.segueButton.addTarget(self, action: "add_food_toCat", forControlEvents: .TouchUpInside)
        edit_categoryVC?.changeTitleButton.addTarget(self, action: "changeTitleLabel", forControlEvents: .TouchUpInside)
        edit_categoryVC?.unwindToFridgeButton.addTarget(self, action: "unwind_Deleted_Cat", forControlEvents: .TouchUpInside)
        edit_categoryVC?.view.alpha = 0
        self.view.addSubview(self.edit_categoryVC!.view!)

        edit_categoryVC?.view.fadeIn(duration: 0.3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 100 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.edit_categoryVC?.deleteButton.layer.cornerRadius = 3
            let redh = UIColor(red: 237/255, green: 90/255, blue: 80/255, alpha: 1)
            self.edit_categoryVC?.deleteButton.layer.borderColor = redh.CGColor
            self.edit_categoryVC?.deleteButton.layer.borderWidth = 1.25

            self.edit_categoryVC?.doneView.roundCorners([.TopLeft, .TopRight], radius: 9)
        }

    }
    
    
    

    
    
    
    
    func stop_edit(){
        self.edit_categoryVC!.view.fadeOut()
    }

  
    
    
    func changeTitleLabel(){
//        if edit_categoryVC?.category != nil{
        self.categoryLabel.text = edit_categoryVC?.category!
        self.category = edit_categoryVC?.category!
//        }
    }
    
    func unwind_Deleted_Cat(){
        self.doneButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "EditCategory_AddFood"{
            var vc : ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
            vc.segueStick = "EditCategory"
        }
    }
    

}
