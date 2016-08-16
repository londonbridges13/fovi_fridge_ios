//
//  ChooseImageVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ChooseImageVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var camera_button : UIButton!
    @IBOutlet var library_button : UIButton!
    @IBOutlet var cancel_button : UIButton!

    @IBOutlet var collectionview : UICollectionView!
    
    var imagePicker: UIImagePickerController!

    var all_basicfooditems = [BasicFoodItem]()

    var foodimage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.dataSource = self
        collectionview.delegate = self
        
        camera_button.addTarget(self, action: "takePic", forControlEvents: .TouchUpInside)
        library_button.addTarget(self, action: "use_Library", forControlEvents: .TouchUpInside)

        requestit()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return all_basicfooditems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ChooseImageCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChooseImageCell", forIndexPath: indexPath) as! ChooseImageCell
        
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
        print("Selected")
        // Set this image = self.foodimage
        // Then unwind segue
        
        self.foodimage =  self.all_basicfooditems[indexPath.row].image
        
        self.cancel_button.sendActionsForControlEvents(.TouchUpInside)
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
        
        self.foodimage = image

        
        let maniiy = dispatch_get_main_queue()
        dispatch_async(maniiy) { () -> Void in
            self.foodimage = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.cancel_button.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        self.foodimage = image

        let maniiy = dispatch_get_main_queue()
        dispatch_async(maniiy) { () -> Void in
            self.foodimage = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.cancel_button.sendActionsForControlEvents(.TouchUpInside)
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
                                
                                self.collectionview.reloadData()
                            })
                        }
                        //EndKF
                        
                        print("Added \(bfi.title) to BFIs")
                    }
                }
            }
            if let JSON = response.result.value{// as? Array<Dictionary<String,AnyObject>> {
                print("Here's JSON")
                print(JSON)
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if self.foodimage != nil{
            let vc : CreateUniqueTVC = segue.destinationViewController as! CreateUniqueTVC
            vc.add_Image(self.foodimage!)
            print(vc.new_fooditem)
            print("WE HAVE AN IMAGE***")
        }
    }
    

}
