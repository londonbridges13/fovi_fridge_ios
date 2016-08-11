//
//  CreateUniqueTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class CreateUniqueTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableview : UITableView!
    
    var food_title : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        
       
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
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Normal Option
        if indexPath.row == 0{
            let cell : Get_Image_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Image_Cell", forIndexPath: indexPath) as! Get_Image_Cell
            
            // Configure the cell...
            
            return cell
        }else if indexPath.row == 1{
            let cell : Get_Title_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Title_Cell", forIndexPath: indexPath) as! Get_Title_Cell
            
            // Configure the cell...
            
            return cell
        }else if indexPath.row == 2{
            let cell : Get_Size_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Size_Cell", forIndexPath: indexPath) as! Get_Size_Cell
            
            // Configure the cell...
            
            return cell
        }else{
            let cell : Get_Expire_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Expire_Cell", forIndexPath: indexPath) as! Get_Expire_Cell
            
            // Configure the cell...
            
            return cell
        }
        
        // Accurate Option, Coming Soon...
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    
    
    
    
    
    func show_Success(){
        var undesr = Success_View()
        undesr.frame = CGRect(x: 5, y: 70, width: 250, height: 200)
        undesr.alpha = 0
        undesr.successLabel.text = "Successfully Created: \(self.food_title!)"
        self.view.addSubview(undesr)
    }
    
    
    func use_showagain(){
        var undesr = ShowAgain_AlertView()
        undesr.frame = CGRect(x: 5, y: 70, width: 290, height: 250)
        undesr.alpha = 0
        self.view.addSubview(undesr)
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
