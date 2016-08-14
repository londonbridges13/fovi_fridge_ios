//
//  ChooseImageVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/13/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ChooseImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var camera_button : UIButton!
    @IBOutlet var library_button : UIButton!
    @IBOutlet var cancel_button : UIButton!

    @IBOutlet var collectionview : UICollectionView!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        camera_button.addTarget(self, action: "takePic", forControlEvents: .TouchUpInside)
        library_button.addTarget(self, action: "use_Library", forControlEvents: .TouchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
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
            
//            if image != nil{
//                if let set_image_delegate = self.set_image_delegate{
//                    set_image_delegate.displayImage(image!)
//                    self.add_Image(image!)
//                }
//            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        let maniiy = dispatch_get_main_queue()
        dispatch_async(maniiy) { () -> Void in
            
//            if let set_image_delegate = self.set_image_delegate{
//                set_image_delegate.displayImage(image)
//                self.add_Image(image)
//            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        
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
