//
//  Set_Expiration_Alert.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 9/8/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift


protocol SetExpirationDelegate {
    func remove_set_Expiration_Alert()
    func displayEnterInputAlert()
}

class Set_Expiration_Alert: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SetExpireCellDelegate {

    @IBOutlet var collectionView : UICollectionView!
    
    var options = [ExpirationOption]()
    
    var fooditem = FoodItem()
    
    var delegate : SetExpirationDelegate?
    
    var update_exdate = false // use this to see whether you should update the expiration
    
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
        cell.setDays = self.options[indexPath.row].set_Days
        
        if self.options[indexPath.row].image != nil{
            cell.setImageView.image = self.options[indexPath.row].image
        }
        cell.delegate = self
        cell.selectButton.layer.cornerRadius = 4
        var that_color = UIColor(red: 90/255, green: 155/255, blue: 178/255, alpha: 1)
//        cell.selectButton.layer.borderColor = that_color.CGColor
//        cell.selectButton.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3{
            // Custom Input, Display Alert
            print("Display Custom Alert")
            selectedCustomInput()
        }else{
            self.selectedCell(self.options[indexPath.row].set_Days!)
        }
    }
    
    func selectedCell(setDays : Int){
        let realm = try! Realm()
        try! realm.write({
            print("\(fooditem.title!).set_expiration was : \(fooditem.set_expiration.value)")
            self.fooditem.set_expiration.value = setDays
            print("\(fooditem.title!).set_expiration is now : \(fooditem.set_expiration.value)")
        })
        
        if let delegate = self.delegate{
            print("Running Delegate (to remove alert view)")
            delegate.remove_set_Expiration_Alert()
        }
        
        // check to update/set the expiration date in the food
        if self.fooditem.fridge_amount.value > 0 && fooditem.set_expiration.value != nil && fooditem.expiration_date == nil{
            // This means that there is no expiration date, this is a fooditem from the previous version(1.10.0)
            // Test this out, by adding a fooditem with no set expiration date to the fridge from the shopping list. This alert should appear and then this function should be exucuted once this this day is set.
            
            // I'm adding a timer to give Realm a second to set the fooditem.set_expiration to a value.
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(250 * Double(NSEC_PER_MSEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.update_fooditem_expiration_date(self.fooditem)
            }
            
        }
        
    }
    
    
    func selectedCustomInput(){
        // Display EnterInput Alert through Delegate with FullFoodView
        // Comeback Here
        
        if let delegate = self.delegate{
            print("Running Delegate (to remove alert view)")
//            delegate.remove_set_Expiration_Alert()
            delegate.displayEnterInputAlert()
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
        longtime.description = "Set the \(fooditem.title!) to last about \(longtime.set_Days!) days."
//        longtime.image = UIImage(named: "")
        
        var month = ExpirationOption()
        month.title = "A Month"
        month.set_Days = 30
        month.description = "Set the \(fooditem.title!) to last about \(month.set_Days!) days."
        //        month.image = UIImage(named: "")

        var twoweeks = ExpirationOption()
        twoweeks.title = "Two Weeks"
        twoweeks.set_Days = 14
        twoweeks.description = "Set the \(fooditem.title!) to last about \(twoweeks.set_Days!) days."
        //        twoweeks.image = UIImage(named: "")

        var aweek = ExpirationOption()
        aweek.title = "A Week"
        aweek.set_Days = 7
        aweek.description = "Set the \(fooditem.title!) to last about \(aweek.set_Days!) days."
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
    

    func update_fooditem_expiration_date(each : FoodItem){
        print("running update expiration")
        var today = NSDate()
        var setvalue = Double(each.set_expiration.value!)
        let added_days = setvalue * 86400
        let new_date = today.dateByAddingTimeInterval(added_days)
        print("\(each.title!) expiration date was updated from \(each.expiration_date)")
        print("to \(new_date)")
        let realm = try! Realm()
        try! realm.write({
            each.expiration_date = new_date
        })
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
