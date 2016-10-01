//
//  ChooseCategoryVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift

protocol ChooseCategoryDelegate {
    func choose_categories(category : String)
}


class ChooseCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var cancelButton : UIButton!
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var createCategoryButton : UIButton!
    @IBOutlet var delegate_done_Button : UIButton!
    
    @IBOutlet var topview : UIView!

    var delegate : ChooseCategoryDelegate?
    
    var categories = [String]()
    
    var addCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.allowsMultipleSelection = true
        
        self.topview.roundCorners([.TopLeft, .TopRight], radius: 6)
        
//        self.doneButton.userInteractionEnabled = false
        
        self.doneButton.addTarget(self, action: "pressedDone", forControlEvents: .TouchUpInside)
        self.cancelButton.addTarget(self, action: "remove_categoryVC", forControlEvents: .TouchUpInside)
        
        self.get_all_categories()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : CategoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
        cell.categoryLabel.text = "\(self.categories[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        print("Added \(self.categories[indexPath.row])")
        addCategories.append(self.categories[indexPath.row])
        
        if addCategories.count > 0{
//            self.doneButton.userInteractionEnabled = true
        }else{
//            self.doneButton.userInteractionEnabled = false
        }

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        
        if self.addCategories.contains(self.categories[indexPath.row]) == true{
            var it = self.addCategories.indexOf(self.categories[indexPath.row])
            print("Removing \(addCategories[it!])")
            self.addCategories.removeAtIndex(it!)
            print("Removed")
        }
        
        if addCategories.count > 0{
//            self.doneButton.userInteractionEnabled = true
        }else{
//            self.doneButton.userInteractionEnabled = false
        }
    }


    
    func pressedDone(){
        print("Pressed Done")
        
        if self.addCategories.count > 0{
            // user has selected categories continue like normal
            if let delegate = delegate{
                for each in self.addCategories{
                    print("Running Delegate")
                    delegate.choose_categories(each)
                    remove_categoryVC()
                }
                self.delegate_done_Button.sendActionsForControlEvents(.TouchUpInside)
                // this delegate_done_Button will execute actions in the CreateUniqueTVC, see in the show_chooseCategory function
            }
        }else{
            // user has not selected any category, Display popover to inform user
            choose_a_category_popover()
        }
        
    }
    

    
    
    
    func remove_categoryVC(){
        self.view.fadeOut(duration: 0.2)
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
                self.tableview.reloadData()
            }else{
                print("self.categories Already Contains : \(each.category)")
            }
        }
    }
    

    
    // when user selects done without first selecting a category
    func choose_a_category_popover(){
        print("Displaying Choose / Create Category Popover")
        
        let startPoint = CGPoint(x: self.view.frame.width / 2, y: 95)
        var aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 80))
        
        var label = UILabel(frame: CGRect(x: 9, y: 0, width: aView.frame.width - 20, height: aView.frame.height))
        label.numberOfLines = 0
        label.text = "Select or Create a Category to put this food in"
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = UIColor.grayColor()
        aView.addSubview(label)
        //lemon
        var lemon = UILabel(frame: CGRect(x: aView.frame.width - 27, y: 5, width: 30, height: 20))
        lemon.text = "🍎"
        aView.addSubview(lemon)
        
        var popoverOptions: [PopoverOption] = [
            .Type(.Down),
            .AnimationIn(0.3),
            .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.1))
        ]
        let popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
        popover.show(aView, point: startPoint, inView: self.view)
        
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
