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
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        // unauth() is the logout method for the current user.
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to Login!
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
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
