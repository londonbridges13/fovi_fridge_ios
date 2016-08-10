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
    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var edit_width: NSLayoutConstraint!
    @IBOutlet var edit_containerView: UIView!
    
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
        
        // ContainerView
        edit_containerView.alpha = 0
        
        // Tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self

        get_cat_food(self.category!)
        
        
        
        // Do any additional setup after loading the view.
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
    }

    
    
    @IBAction func edit(sender: AnyObject) {
        print("Pressed Edit")
//        edit_category()
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
    
    
    
    
    
    
    
    
    
    
    
    
    // Edit Category
    
    func edit_category(){
//        var tableview = UITableView()
//        tableview.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: view.frame.height - 50)
//        
//        tableview.delegate = self
//        tableview.dataSource = self
//        
//        tableview.alpha = 0
//        
//        self.view.addSubview(tableview)
//        tableview.fadeIn()
        
        
    }
    
    
    func hide_edit(){
        var editvc = self.childViewControllers.first as! EditCategoryVC
        editvc.view.alpha = 0
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    

}
