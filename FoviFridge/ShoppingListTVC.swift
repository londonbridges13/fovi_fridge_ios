//
//  ShoppingListTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ShoppingListTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var food = [1,2,3,4,5,6,7,8,9,0]
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addToListButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        addToListButton.layer.cornerRadius = 6
//        tableView.layer.cornerRadius = 9.0
//        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        tableView.layer.borderWidth = 0.78
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return food.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShoppingCell = tableView.dequeueReusableCellWithIdentifier("ShoppingCell", forIndexPath: indexPath) as! ShoppingCell

//        cell.foodImage.image = UIImage(named: "")
        cell.foodImage.layer.cornerRadius = 4

        tableView.rowHeight = 60
        // Configure the cell...

        return cell
    }
    

// Swipe Funtionality
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let addToFridge = UITableViewRowAction(style: .Normal, title: "Move to Fridge") { action, index in
            print("Move button tapped")
            self.tableView.beginUpdates()
            self.food.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
        var blue = UIColor(red: 0/255, green: 153/255, blue: 241/255, alpha: 1)
        addToFridge.backgroundColor = blue
        
        let remove = UITableViewRowAction(style: .Destructive, title: "Remove") { action, index in
            print("Remove button tapped")
//            tableView.reloadData()
            self.tableView.beginUpdates()
            self.food.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
        }
        remove.backgroundColor = UIColor.redColor()

        
        return [remove, addToFridge]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        // Delete Food Object from Realm
        
    }

    
    
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc: ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
        vc.segueStick = "shopping"
    }
    @IBAction func unwindToShopList(segue: UIStoryboardSegue){
        print("Unwind to ShoppingListVC")
        //ReQuery Food
        
    }


}
