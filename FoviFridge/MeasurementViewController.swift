//
//  MeasurementViewController.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 8/11/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit

protocol MeasureToCellDelegate {
    func set_measure_type(measureType: String)
}

class MeasurementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var cancelButton : UIButton!
    
    @IBOutlet var topview : UIView!

    var delegate : MeasureToCellDelegate?
    
    var measures = ["Milliliters", "Grams", "Of Them", "Ounces", "Pounds", "Kilograms", "Liters", "Pints", "Floor Ounces", "Gallon", "Slices", "Pieces"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topview.roundCorners([.TopLeft, .TopRight], radius: 6)

        
        tableview.delegate = self
        tableview.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measures.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : MeasurementsCell = tableView.dequeueReusableCellWithIdentifier("measurecell", forIndexPath: indexPath) as! MeasurementsCell
        cell.measureLabel.text = "\(self.measures[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let measurementType = self.measures[indexPath.row]
        
        if let delegate = delegate{
            print("Running MeasureToCell Delegate")
            delegate.set_measure_type(measurementType)
            self.cancelButton.sendActionsForControlEvents(.TouchUpInside)
        }
        self.view.fadeOut(duration: 0.3)
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
