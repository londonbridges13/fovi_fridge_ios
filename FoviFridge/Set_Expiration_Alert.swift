//
//  Set_Expiration_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/8/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

protocol SetExpirationDelegate {
    func remove_set_Expiration_Alert()
}

class Set_Expiration_Alert: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView : UICollectionView!
    
    var options = [ExpirationOption]()
    
    var fooditem = FoodItem()
    
    var delegate : SetExpirationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        add_ExpirationOptions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : Set_Expiration_Cell = collectionView.dequeueReusableCellWithReuseIdentifier("expire_optioncell", forIndexPath: indexPath) as! Set_Expiration_Cell
        
        cell.setLabel.text = self.options[indexPath.row].title
        cell.descLabel.text = self.options[indexPath.row].description
        
        if self.options[indexPath.row].image != nil{
            cell.setImageView.image = self.options[indexPath.row].image
        }
        
        cell.selectButton.layer.cornerRadius = 4
        var that_color = UIColor(red: 90/255, green: 155/255, blue: 178/255, alpha: 1)
        cell.selectButton.layer.borderColor = that_color.CGColor
        cell.selectButton.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let delegate = self.delegate{
            print("Running Delegate (to remove alert view)")
            delegate.remove_set_Expiration_Alert()
        }
    }
    
    
    
    
    
    
    func add_ExpirationOptions(){
        //  BY DEFAULT SET ALL FOODITEMS TO GO WITH FOODITEM.USUALLY_EXPIRES
        
        var freezer = ExpirationOption()
        freezer.set_Days = 90
        freezer.title = "Freezer"
        freezer.description = "If you put the \(fooditem.title!) in the freezer, they should last about \(freezer.set_Days!) days."
//        freezer.image = UIImage(named: "")
        
        
        var fridge = ExpirationOption()
        fridge.title = "Fridge"
        if fooditem.fridge_usually_expires.value != nil{
            fridge.set_Days = fooditem.fridge_usually_expires.value
        }else{
            fridge.set_Days = 15
        }
        fridge.description = "If you put the \(fooditem.title!) in the fridge, they should last about \(fridge.set_Days!) days."
//       fridge.image = UIImage(named: "")
        
        
        var counter = ExpirationOption()
        counter.title = "Counter"
        if fooditem.fridge_usually_expires.value != nil{
            counter.set_Days = fooditem.fridge_usually_expires.value
        }else{
            counter.set_Days = 7
        }
        counter.description = "If you leave the \(fooditem.title!) out, they should last about \(counter.set_Days!) days."
//        counter.image = UIImage(named: "")
        
        
        var custom = ExpirationOption()
        custom.title = "Custom"
        custom.description = "Set the \(fooditem.title!) expiration yourself."
//        custom.image = UIImage(named: "")
        
        var longtime = ExpirationOption()
        longtime.title = "Long Time"
        longtime.set_Days = 120
        longtime.description = "Set the \(fooditem.title!) to last about \(longtime.set_Days) days."
//        longtime.image = UIImage(named: "")
        
        var month = ExpirationOption()
        month.title = "A Month"
        month.set_Days = 30
        month.description = "Set the \(fooditem.title!) to last about \(month.set_Days) days."
        //        month.image = UIImage(named: "")

        var twoweeks = ExpirationOption()
        twoweeks.title = "Two Weeks"
        twoweeks.set_Days = 14
        twoweeks.description = "Set the \(fooditem.title!) to last about \(twoweeks.set_Days) days."
        //        twoweeks.image = UIImage(named: "")

        var aweek = ExpirationOption()
        aweek.title = "A Week"
        aweek.set_Days = 7
        aweek.description = "Set the \(fooditem.title!) to last about \(aweek.set_Days) days."
        //        aweek.image = UIImage(named: "")

        
        self.options.append(counter)
        self.options.append(fridge)
        self.options.append(freezer)
        self.options.append(custom)
        self.options.append(aweek)
        self.options.append(twoweeks)
        self.options.append(month)
        self.options.append(longtime)

        self.collectionView.reloadData()
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
