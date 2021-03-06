//
//  addPledgeViewController.swift
//  Vego
//
//  Created by Faith Ben on 24/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit
import Foundation

class AddPledgeViewController: UIViewController {

    @IBOutlet var monthButtons: [UIButton]!
    
    @IBOutlet var dayButtons: [UIButton]!
    
    var months: Int?
    
    var days: Int?
    
    var pledge: Dictionary<String, String>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for monthButton in monthButtons {
            monthButton.imageView?.contentMode = .ScaleAspectFit
        }

        for dayButton in dayButtons {
            dayButton.imageView?.contentMode = .ScaleAspectFit
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectedMonth(sender: UIButton) {
        // Deselect all buttons
        for monthButton in monthButtons {
            if(monthButton.selected == true) {
                monthButton.selected = false
                monthButton.enabled = true
            }
        }
        // Select the clicked button
        sender.selected = true
        sender.enabled = false
        months = sender.tag
        
        // Enable day buttons
        var multiply = 1
        for dayButton in dayButtons {
            
            dayButton.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                dayButton.alpha = 1.0

                let text = String(7 * self.months! * multiply)
                dayButton.setTitle(text, forState: .Normal)
                dayButton.enabled = true
            })
            multiply += 1
        }
    }
    
    @IBAction func selectedDay(sender: UIButton) {
        // Deselect all buttons
        for dayButton in dayButtons {
            if(dayButton.selected == true) {
                dayButton.selected = false
                dayButton.enabled = true
            }
        }
        
        // Select the clicked button
        sender.selected = true
        sender.enabled = false
        days = Int(sender.titleLabel!.text!)
    }

    
    @IBAction func addPledge(sender: UIButton) {
        // Check if connected to the internet
        if Reachability.isConnectedToNetwork() == false {
            self.addPledgeAlert("Oops", message: "You are not connected to the internet. Failed to pledge.")
        } else {
            // Add pledge
            if let m = months, d = days {
                if let pledge = self.pledge {
                    DataService.dataService.updatePledge(m, newDays: d, lastPledge: pledge)
                } else {
                    DataService.dataService.createNewPledge(m, days: d)
                }
                DataService.dataService.updateCounter(d)
                self.addedPledgeAlert()
            } else {
                self.addPledgeAlert("Oops!", message: "Please select perid and days first")
            }
        }
    }
    
    func addPledgeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addedPledgeAlert() {
        let alert = UIAlertController(title: "Congrats!", message: "You've made a pledge.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
                self.navigationController?.popViewControllerAnimated(true)
        })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
