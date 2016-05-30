//
//  SignUpViewController.swift
//  Vego
//
//  Created by Faith Ben on 23/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
        signUpButton.imageView?.contentMode = .ScaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let passwordConfirm = passwordConfirmField.text
        
        if username != "" && email != "" && password != "" && passwordConfirm != "" {
            // If re-entered password does not match
            guard password == passwordConfirm else {
                self.signupErrorAlert("Oops!", message: "The re-entered password doesn't match. Try again.")
                return
            }
            
            // Set Email and Password for the New User.
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                } else {
                    
                    // Create and Login the New User with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!, "email": email!, "username": username!]
                        
                        // Seal the deal in DataService.swift.
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    // Enter the app.
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
            
        } else if password == passwordConfirm {
            signupErrorAlert("Oops!", message: "The second password is different. Try again.")
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    
    func signupErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    func textFieldShouldReturn(sender: UITextField) -> Bool {
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty && !passwordConfirmField.text!.isEmpty && !usernameField.text!.isEmpty {
            createAccount(sender)
            sender.resignFirstResponder()
            return true
        } else {
            sender.resignFirstResponder()
            return false
        }
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
