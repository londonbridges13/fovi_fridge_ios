//
//  ChooseFoodVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 6/23/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

class ChooseFoodVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collViewTopConstraint: NSLayoutConstraint!
    
    var food = [1,2,3,4,4,5,5,3,3,3,3,3,3,34,4,5,56,6,6,7,7,7,78,8,89,8,7,67,6,6,5,5,4,4,4,54,6,7,8,9,9,90,9,8,7,6,5,4,43,3,2,2,2,1,1]//[String]()
    
    var i = 0
    
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var uniqueButton: UIButton!
    @IBOutlet var finishedButton: UIButton!
    
    @IBOutlet var myFoodColl: UIView!
    
    @IBOutlet var unwindAddFoodButton: UIButton!
    @IBOutlet var unwindShopListButton: UIButton!

    @IBOutlet var uniqueBackground: UIView!
    
    
    var segueStick: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.layer.cornerRadius = 9//15
        collectionView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        collectionView.layer.borderWidth = 1
        finishedButton.layer.cornerRadius = 4
        uniqueBackground.layer.cornerRadius = 13
        uniqueButton.layer.cornerRadius = 4
        collectionView.delegate = self
        collectionView.dataSource = self
//        // Collection View Insects
//        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        if segueStick != nil{
            print(segueStick)
        }else{
            print("segueStick = nil")
        }

    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChoosenItemCell", forIndexPath: indexPath) as! UICollectionViewCell

        cell.layer.cornerRadius = 12

        
        return cell
    }
    
    
    
    
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.collectionView.panGestureRecognizer.translationInView(self.view).y < 0.0 {
            
            if self.i == 0{
                let left = CGAffineTransformMakeTranslation(-300, 0)
                let right = CGAffineTransformMakeTranslation(300, 0)
                let down = CGAffineTransformMakeTranslation(0, 40)
                let minidown = CGAffineTransformMakeTranslation(0, 52)
                let up = CGAffineTransformMakeTranslation(0, -50)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    // self.container is your view that you want to animate
                    self.finishedButton.transform = down
                    self.myFoodColl.transform = minidown
                    self.uniqueButton.transform = up
                    self.uniqueBackground.transform = up
                    
                    self.collViewTopConstraint.constant = 50 // Top Constraint
                    self.collViewConstraint.constant = 89 //Bottom Constraint
                    
                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(90, 5, 10, 5)
                    //End
                    
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.0, options: [], animations: {
                    //
//                    self.searchBar.alpha = 1
                    
                    }, completion: nil)
                self.i = 1
            }
            
            
        }else{
            
            if self.i == 1{
                let left = CGAffineTransformMakeTranslation(-300, 0)
                let right = CGAffineTransformMakeTranslation(300, 0)
                let back = CGAffineTransformMakeTranslation(0, 0)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                    // Add the transformation in this block
                    // self.container is your view that you want to animate
                    self.finishedButton.transform = back
                    self.myFoodColl.transform = back
                    self.uniqueButton.transform = back
                    self.uniqueBackground.transform = back

                    self.view.layoutIfNeeded()

                    // Collection View Insects
                    let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    flow.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5)
                    // End
                    
                    self.collViewTopConstraint.constant = 91 // Top Constraint
                    self.collViewConstraint.constant = 139 //Bottom Constraint
                    self.view.layoutIfNeeded()

//                    self.searchBar.endEditing(true)
                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
                    //
//                    self.searchBar.alpha = 0
                    
                    }, completion: nil)
                self.i = 0
            }
        }
        
        
    }

    
    

    
    
    
    
    
    
    
    
    
    @IBAction func pressedFinished(sender: AnyObject) {
        //Save Data to realm, unwind segue
        
        if segueStick == "addfood"{
            unwindAddFoodButton.sendActionsForControlEvents(.TouchUpInside)

        }else if segueStick == "shopping"{
            unwindShopListButton.sendActionsForControlEvents(.TouchUpInside)
        }else if segueStick == ""{
            //.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToChooseVC(segue: UIStoryboardSegue){
        print("Unwind to ChooseFoodVC")
        //ReQuery Food
        
    }


}
