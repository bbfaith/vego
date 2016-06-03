//
//  HomeViewController.swift
//  Vego
//
//  Created by Robin Lin on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var myPledgeButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var recipeButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPledgeButton.imageView?.contentMode = .ScaleAspectFit
        recipeButton.imageView?.contentMode = .ScaleAspectFit
        restaurantButton.imageView?.contentMode = .ScaleAspectFit
        checkInButton.imageView?.contentMode = .ScaleAspectFit
        signOutButton.layer.cornerRadius = 8
        signOutButton.layer.borderWidth = 1
        signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        for index in 1...7 {
            let digitLabel = self.view.viewWithTag(index) as! UILabel
            digitLabel.layer.cornerRadius = 5
        }
        displayCounter()
    }
    
    func displayCounter() {
        let COUNTER_REF = DataService.dataService.BASE_REF.childByAppendingPath("counter")
        COUNTER_REF.observeEventType(.Value, withBlock: {
            snapshot in
            let countString = snapshot.value as! String
            var count = Int(countString)!
            for index in 1...7 {
                let digitLabel = self.view.viewWithTag(index) as? UILabel
                if count != 0 {
                    digitLabel!.text = String(count % 10)
                    count /= 10
                } else {
                    digitLabel!.text = "0"
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        // Check internet connection first
        if Reachability.isConnectedToNetwork() == false {
            self.homeErrorAlert("Oops", message: "You need to connect to the internet first.")
        } else {
            // unauth() is the logout method for the current user.
            DataService.dataService.CURRENT_USER_REF.unauth()
            
            // Remove the user's uid from storage.
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            
            // Head back to Login!
            let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
            UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        }
    }

    func homeErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
