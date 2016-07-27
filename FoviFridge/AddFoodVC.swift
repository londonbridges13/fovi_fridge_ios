//
//  AddFoodVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class AddFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {

    
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var unwindToFridgeButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addFoodButton: UIButton!
    
    @IBOutlet var searchBar: UISearchBar!
    
    
//    @IBOutlet var bottomView: UIView!
    
    
    
    
    var food = [1,2,3,4,4,5,5,3,3,3,3,3,3,34,4,5,56,6,6,7,7,7,78,8,89,8,7,67,6,6,5,5,4,4,4,54,6,7,8,9,9,90,9,8,7,6,5,4,43,3,2,2,2,1,1]//[String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bottomView.roundCorners([.BottomLeft, .BottomRight], radius: 13)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.layer.cornerRadius = 9//13
        self.addFoodButton.layer.cornerRadius = 2
        self.doneButton.layer.cornerRadius = 2
//        self.collectionView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        self.collectionView.layer.borderWidth = 1
//        self.doneButton.layer.borderWidth = 1
//        self.doneButton.layer.borderColor = UIColor.lightGrayColor().CGColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return food.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FoodItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("boughtItem", forIndexPath: indexPath) as! FoodItemCollectionViewCell

        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func doneWithFood(sender: AnyObject) {
        // Save FoodData, Unwind
//        unwindToFridgeButton.sendActionsForControlEvents(.TouchUpInside)
        
        performSegueWithIdentifier("DoneIt", sender: self)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addfood"{
            let vc: ChooseFoodVC = segue.destinationViewController as! ChooseFoodVC
            vc.segueStick = "addfood"
        }else{
            if segue is CustomUnwindSegue {
                (segue as! CustomUnwindSegue).animationType = .Push
            }
        }

    }
    
    @IBAction func unwindToAddFood(segue: UIStoryboardSegue){
        print("Unwind to AddFoodVC")
        //ReQuery Food
        
    }

    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
//        segue.animationType = .Push
//        return segue
//    }
    


}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

