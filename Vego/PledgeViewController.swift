//
//  PledgeViewController.swift
//  Vego
//
//  Created by Faith Ben on 23/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class PledgeViewController: UIViewController {

    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var poultryLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var aquaticLabel: UILabel!
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var addPledgeButton: UIButton!
    
    var pledge: Dictionary<String, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check internet connection first
        if Reachability.isConnectedToNetwork() == false {
            self.pledgeErrorAlert("Oops", message: "You are not connected to the internet. Data cannot display correctly.")
        } else {
            addPledgeButton.enabled = false
        
            // Retrive data from database
            let pledgeURL = DataService.dataService.PLEDGE_REF
            pledgeURL.observeEventType(.Value, withBlock: {
                snapshot in
                
                    // If the user ever made a pledge
                    if let pledge = snapshot.value as? Dictionary<String, String> {
                        self.pledge = pledge
                        let pledgedDays = Int(pledge["pledged_days"]!)!
                        
                        let daysDouble = Double(pledgedDays)
                        self.dayLabel.text = String(pledgedDays) + " Days"
                        self.lowerLabel.text = "You Can Make An Impact On"
                        self.poultryLabel.text = String(format: "%.2f", daysDouble * 0.07)
                        self.co2Label.text = String(format: "%.2f", daysDouble * 4.7)
                        self.squareLabel.text = String(format: "%.0f", daysDouble * 31)
                        self.aquaticLabel.text = String(format: "%.2f", daysDouble * 0.95)
                        
                    } else { // If the user haven't made a pledge
                        self.dayLabel.text = "0 Days"
                        self.lowerLabel.text = "For Each Meat Free Day, You Can"
                        self.poultryLabel.text = "0.07"
                        self.co2Label.text = "4.7"
                        self.squareLabel.text = "31"
                        self.aquaticLabel.text = "0.95"
                    }
                    self.addPledgeButton.enabled = true
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pledgeErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? AddPledgeViewController {
            destination.pledge = self.pledge
        }
    }

}
