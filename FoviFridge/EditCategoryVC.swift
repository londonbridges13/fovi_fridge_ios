//
//  EditCategoryVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/10/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class EditCategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableview : UITableView!
    
    var cells = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableview.delegate = self
        tableview.dataSource = self

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
        return cells.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("edit1", forIndexPath: indexPath)
        
        
        tableView.rowHeight = 60
        
        return cell
    }


}
