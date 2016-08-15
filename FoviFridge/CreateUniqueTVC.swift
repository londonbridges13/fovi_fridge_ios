//
//  CreateUniqueTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


protocol SettingImage{
    func displayImage(image : UIImage)
}


class CreateUniqueTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UseFood, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet var tableview : UITableView!
    
    var imagePicker: UIImagePickerController!

    var food_title : String?
    
    var measureVC : MeasurementViewController?
    
    var set_image_delegate : SettingImage?
    
    var new_fooditem = FoodItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        // Setting Default Values for New_Fooditem
        self.new_fooditem.measurement_type = "Ounces"
        self.new_fooditem.mylist_amount.value = 1
        self.new_fooditem.full_amount.value = 5
        self.new_fooditem.current_amount.value = 5
        self.new_fooditem.is_basic = false
        
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

    @IBAction func unwindToCreateFoodVC(segue: UIStoryboardSegue){
        
    }
    
    
    
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        // Normal Option
        if indexPath.row == 0{
            let cell : Get_Image_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Image_Cell", forIndexPath: indexPath) as! Get_Image_Cell
            tableview.rowHeight = 205
            // Configure the cell...
            cell.delegate = self
            self.set_image_delegate = cell
            cell.ourImages_button.addTarget(self, action: "use_our_images", forControlEvents: .TouchUpInside)

            return cell
        }else if indexPath.row == 1{
            let cell : Get_Title_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Title_Cell", forIndexPath: indexPath) as! Get_Title_Cell
            tableview.rowHeight = 230
            // Configure the cell...
            cell.delegate = self
            
            return cell
        }else if indexPath.row == 2{
            let cell : Get_Size_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Size_Cell", forIndexPath: indexPath) as! Get_Size_Cell
            tableView.rowHeight = 185
            // Configure the cell...
            cell.delegate = self
            cell.measure_button.addTarget(self, action: "use_measureVC", forControlEvents: .TouchUpInside)
            
            return cell
        }else if indexPath.row == 3{
            let cell : Get_Expire_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Expire_Cell", forIndexPath: indexPath) as! Get_Expire_Cell
            tableView.rowHeight = 302
            // Configure the cell...
            cell.delegate = self

            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("done", forIndexPath: indexPath)
            tableView.rowHeight = 100
            return cell
        }
        
        // Accurate Option, Coming Soon...
    }
    


    
    
    // Perform Segue
    func use_our_images(){
        self.performSegueWithIdentifier("choose_image", sender: self)
    }
    
    // UseFood Delegate functions
    func add_Title(title: String){ // This adds the title to a variable in the CreateFoodTVC
        print("Setting \(title) as the Food.title")
        
        self.new_fooditem.title = title
        print(new_fooditem)
    }
    func add_Image(image : UIImage){ // This adds the image to a variable in the CreateFoodTVC
        print("Adding Image")
        
        self.new_fooditem.image = UIImagePNGRepresentation(image)
        print(new_fooditem)
    }
    func add_Expiration(expires : Int){ // This adds the expiration to a variable in the CreateFoodTVC
        print("Exipires in \(expires) days")
        
        self.new_fooditem.usually_expires.value = expires
        self.new_fooditem.fridge_usually_expires.value = expires
        
        //Set date 
        var ex_date = NSDate()
        if expires >= 29{
//            ex_date.month.value() += 1
        }
        print(new_fooditem)
    }
    func add_Measurement(measurement_type : String, full_amount : Float, current_amount : Float){
        print("Measurement Type is \(measurement_type).")
        print("Full Amount is \(full_amount).")
        print("Current Amount is \(current_amount).")
        
        self.new_fooditem.measurement_type = measurement_type
        self.new_fooditem.current_amount.value = current_amount
        self.new_fooditem.full_amount.value = full_amount
        print(new_fooditem)
    }
    func add_MyListAmount(amount : Int){
        self.new_fooditem.mylist_amount.value = amount
        print(new_fooditem)
        print("New_Foodtiem.mylist_amount was set to : \(self.new_fooditem.mylist_amount.value!)")
    }
    
    
    // Images Delegates
    func use_Library(){
        //self.openPhotoLibrary()
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // if error change this back to uiimage... sourcetype.photolibrary
        self.presentViewController(image, animated: true, completion: nil)
        
        print("From Photo Library")
        
    }
    
    
    func takePic(){
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }


    
    
    
    
    
    // ImageController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        
        let maniiy = dispatch_get_main_queue()
        dispatch_async(maniiy) { () -> Void in
            
            if image != nil{
                if let set_image_delegate = self.set_image_delegate{
                    set_image_delegate.displayImage(image!)
                    self.add_Image(image!)
                }
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    
        let maniiy = dispatch_get_main_queue()
        dispatch_async(maniiy) { () -> Void in
            
            if let set_image_delegate = self.set_image_delegate{
                set_image_delegate.displayImage(image)
                self.add_Image(image)
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        

        
    }
    
    

    
    
    
    
    // Show Measurement VC
    func use_measureVC(){
        self.measureVC = storyboard?.instantiateViewControllerWithIdentifier("MeasurementViewController") as! MeasurementViewController

        var xp = measureVC!.view.frame.width / 2 - ((240) / 2)

        self.measureVC!.view.frame = CGRect(x: xp, y: 72, width: 240, height: 400)
        self.measureVC?.cancelButton.addTarget(self, action: "remove_measureVC", forControlEvents: .TouchUpInside)
        
        //To connect measureVC Delegate to Get_Size_Cell
        let index = NSIndexPath(forRow: 2, inSection: 0)
        var size_cell : Get_Size_Cell = tableview.cellForRowAtIndexPath(index) as! Get_Size_Cell
        self.measureVC?.delegate = size_cell
        
        //Load View
        self.measureVC?.view.layer.cornerRadius = 6
        self.view.addSubview(measureVC!.view!)
    }
    
    
    func remove_measureVC(){
        self.measureVC?.view.fadeOut()
    }
    
    
    
    
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
