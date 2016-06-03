//
//  ViewController.swift
//  Vego
//
//  Created by Faith Ben on 20/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 0.5
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        let userView = UIImageView(image: UIImage(named: "user.png"))
        userView.frame = CGRectMake(8, 6, 19, 19)
        emailField.leftViewMode = UITextFieldViewMode.Always
        emailField.addSubview(userView)
        
        let pswView = UIImageView(image: UIImage(named: "psw.png"))
        pswView.frame = CGRectMake(10, 5, 20, 20)
        passwordField.leftViewMode = UITextFieldViewMode.Always
        passwordField.addSubview(pswView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
        }
    }
    
    func textFieldShouldReturn(sender: UITextField) -> Bool {
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty {
            tryLogin(sender)
            sender.resignFirstResponder()
            return true
        } else {
            sender.resignFirstResponder()
            return false
        }
    }
    
    @IBAction func tryLogin(sender: AnyObject) {
        // Check internet connection first
        if Reachability.isConnectedToNetwork() == false {
            self.loginErrorAlert("Oops!", message: "You need to connect to the internet first.")
        } else {
            let email = emailField.text
            let password = passwordField.text
            
            if email != "" && password != "" {
                // Login with the Firebase's authUser method
                DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print(error)
                        self.loginErrorAlert("Oops!", message: "Check your username and password.")
                    } else {
                        // Be sure the correct uid is stored.
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        
                        // Enter the app!
                        self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
                    }
                })
                
            } else {
                // There was a problem logging in
                loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
            }
        }
    }
    
    func loginErrorAlert(title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

