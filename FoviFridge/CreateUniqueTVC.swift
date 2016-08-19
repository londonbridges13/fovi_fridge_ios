//
//  CreateUniqueTVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

protocol SettingImage{
    func displayImage(image : UIImage)
}


class CreateUniqueTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UseFood, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChooseCategoryDelegate {

    
    @IBOutlet var tableview : UITableView!
    
    @IBOutlet var cancelbutton : UIButton!
    
    var actIndi : NVActivityIndicatorView?

    var imagePicker: UIImagePickerController!

    var food_title : String?
    
    var dtint : UIView?
    
    var measureVC : MeasurementViewController?
    var categoryVC : ChooseCategoryVC?
    
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
            tableview.rowHeight = 255
            // Configure the cell...
            cell.delegate = self
            self.set_image_delegate = cell
            cell.ourImages_button.addTarget(self, action: "use_our_images", forControlEvents: .TouchUpInside)
            if self.new_fooditem.image != nil{
                cell.food_image.image = UIImage(data: self.new_fooditem.image!)
            }

            return cell
        }else if indexPath.row == 1{
            let cell : Get_Title_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Title_Cell", forIndexPath: indexPath) as! Get_Title_Cell
            tableview.rowHeight = 300
            // Configure the cell...
            cell.delegate = self
            
            return cell
        }else if indexPath.row == 2{
            let cell : Get_Size_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Size_Cell", forIndexPath: indexPath) as! Get_Size_Cell
            tableView.rowHeight = 225
            // Configure the cell...
            cell.delegate = self
            cell.measure_button.addTarget(self, action: "use_measureVC", forControlEvents: .TouchUpInside)
            
            return cell
        }else if indexPath.row == 3{
            let cell : Get_Expire_Cell = tableView.dequeueReusableCellWithIdentifier("Get_Expire_Cell", forIndexPath: indexPath) as! Get_Expire_Cell
            tableView.rowHeight = 312
            // Configure the cell...
            cell.delegate = self

            
            return cell
        }else{
            let cell : DoneCell = tableView.dequeueReusableCellWithIdentifier("done", forIndexPath: indexPath) as! DoneCell
            tableView.rowHeight = 100
            
            cell.doneButton.addTarget(self, action: "check_everything", forControlEvents: .TouchUpInside)
            cell.selectionStyle = .None
            
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
        let image_data = image.mediumQualityJPEGNSData
        self.new_fooditem.image = image_data//UIImagePNGRepresentation(image)
        
        // For ChooseImageVC
//        let index = NSIndexPath(forRow: 0, inSection: 0)
//        var image_cell : Get_Image_Cell = tableview.cellForRowAtIndexPath(index) as! Get_Image_Cell
//        image_cell.food_image.image = image
        
        tableview.reloadData()
        
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
        self.measureVC?.cancelButton.addTarget(self, action: "remove_darktint", forControlEvents: .TouchUpInside)
        //To connect measureVC Delegate to Get_Size_Cell
        let index = NSIndexPath(forRow: 2, inSection: 0)
        var size_cell : Get_Size_Cell = tableview.cellForRowAtIndexPath(index) as! Get_Size_Cell
        self.measureVC?.delegate = size_cell
        
        //Load View
        self.add_darktint()
        self.measureVC?.view.layer.cornerRadius = 6
        self.view.addSubview(measureVC!.view!)
    }
    
    
    func remove_measureVC(){
        self.measureVC?.view.fadeOut()
    }
    
    
    
    
    // Show ChooseCategoryVC
    func show_chooseCategory(){
        print("Showing Category")
        
        categoryVC = storyboard?.instantiateViewControllerWithIdentifier("ChooseCategoryVC") as! ChooseCategoryVC

        var xp = categoryVC!.view.frame.width / 2 - ((240) / 2)

        categoryVC!.view.frame = CGRect(x: xp, y: 72, width: 240, height: 400)
        categoryVC!.delegate = self
        
        self.add_darktint()
        
        categoryVC?.cancelButton.addTarget(self, action: "remove_darktint", forControlEvents: .TouchUpInside)
        categoryVC?.doneButton.addTarget(self, action: "remove_darktint", forControlEvents: .TouchUpInside)
        categoryVC?.doneButton.addTarget(self, action: "loading", forControlEvents: .TouchUpInside)
        categoryVC?.doneButton.addTarget(self, action: "create_new_item", forControlEvents: .TouchUpInside)
        categoryVC?.doneButton.addTarget(self, action: "suggest_it", forControlEvents: .TouchUpInside)
        
        categoryVC!.view.layer.cornerRadius = 6
        self.view.addSubview(categoryVC!.view)
    }
    

    
    // ChooseCategory Delegates
    func choose_categories(category : String){
        var cat = Category()
        cat.category = category
        
        let realm = try! Realm()
        
        try! realm.write {
            self.new_fooditem.category.append(cat)
            print(self.new_fooditem)
            print("Appended \(cat.category) to NewFooditem")
            print("Number of Categories = \(self.new_fooditem.category.count)")
        }
    }
    
    
    
    
    
    
    
    // Begin Checking
    
    func check_everything(){
        check_title()
    }
    
    func check_title(){
        print("Checking Title")
        if new_fooditem.title?.characters.count >= 1{
            // Good to go, continue checking
            check_expiration()
        }else{
            // Problem here, scroll to this cell
            let index = NSIndexPath(forRow: 2, inSection: 0)
            tableview.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
    }
    
    
    func check_expiration(){
        print("Checking Expiration")
        if new_fooditem.usually_expires.value != nil{
            // Good to go, continue checking
            check_image()
        }else{
            // Problem here, scroll to this cell
            let index = NSIndexPath(forRow: 3, inSection: 0)
            tableview.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }

    func check_image(){
        print("Checking Image")
        if self.new_fooditem.image != nil{
            // Good to go, display choose categoryVC
            
            self.show_chooseCategory()
        }else{
            // Problem here, display chooseimageVC
            self.performSegueWithIdentifier("choose_image", sender: self)
            
        }
    }

    func loading(){
        // show loading indicator
        var xp = view.frame.width / 2 - ((100) / 2)
        var yp = view.frame.height / 2 - ((100) / 2)

        var loadview = UIView(frame: CGRect(x: xp, y: yp, width: 100, height: 100))
        
        let bluecolor = UIColor(red: 0, green: 153/255, blue: 241/255, alpha: 1)
        loadview.backgroundColor = bluecolor
        loadview.layer.cornerRadius = 9
        
        self.view.addSubview(loadview)
        
        let vdelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(vdelayTime, dispatch_get_main_queue()) {

            var size : CGFloat = 37
            var xxp = loadview.frame.width / 2 - (size / 2)
            var hp = loadview.frame.height / 2 - (size / 2)
            let frame = CGRect(x: xxp, y: hp, width: size, height: size)
            
            self.actIndi = NVActivityIndicatorView(frame: frame, type: .LineScale, color: UIColor.whiteColor(), padding: 3)
            self.actIndi?.startAnimation()
            self.actIndi?.alpha = 0
            
            loadview.addSubview(self.actIndi!)
            
            self.actIndi?.fadeIn(duration: 0.2)
        }

        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.unwind()
        }
    }
    
    func unwind(){
        self.cancelbutton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    // Finished 
    func create_new_item(){
        let realm = try! Realm()
        
        try! realm.write({ 
            realm.add(new_fooditem)
            print(new_fooditem)
            print("Succussfully Created \(new_fooditem.title!)")
        })
    }
    
    
    // Send Suggestion
    
    func pre_send(){
        let title = "\(self.new_fooditem.title!)"
        let m_type = "\(new_fooditem.measurement_type!)"
        let full_amount = new_fooditem.full_amount.value!
        let expires = new_fooditem.usually_expires.value!
        

    }
    func suggest_it(){//(title : String, m_type : String, full_amount : Float, expires : Int){
        print("Posting...")
        
        let title = "\(self.new_fooditem.title!)"
        let m_type = "\(new_fooditem.measurement_type!)"
        let full_amount = new_fooditem.full_amount.value!
        let expires = new_fooditem.usually_expires.value!
        

        
        let parameters = [
            "title": title,
            "is_basic": false,
            "measurement_type": m_type,
            "full_amount": full_amount,
            "usually_expires": expires,
            "categories": ["Fruits","On CounterTop", "Healthy", "Red"]
            
        ]
        
        Alamofire.request(.POST, "https://rocky-fjord-88249.herokuapp.com/api/v1/suggested_food_items", parameters: parameters as! [String : AnyObject], encoding: .JSON).response(completionHandler: {
            (request, response, data, error) in
            print("")
            print(request)
            print(response)
            print(data)
            print(error)
        })
        
        print("Posted \(self.new_fooditem.title!) to SFI...")
        
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
    
    
    
    
    
    func add_darktint(){
        dtint = UIView()
        
        if dtint?.alpha != 0.3{
            dtint?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height)
            dtint?.backgroundColor = UIColor.blackColor()
            dtint?.alpha = 0.3
            self.view.addSubview(dtint!)
        }else{
            dtint?.fadeOut()
        }
    }
    
    func remove_darktint(){
        dtint?.fadeOut(duration: 0.2)
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


extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.6)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
