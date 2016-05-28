//
//  ViewController.swift
//  Vego
//
//  Created by Faith Ben on 20/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {


    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 0.5
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        let userView = UIImageView(image: UIImage(named: "user.png"))
        userView.frame = CGRectMake(8, 6, 19, 19)
        username.leftViewMode = UITextFieldViewMode.Always
        username.addSubview(userView)
        
        let pswView = UIImageView(image: UIImage(named: "psw.png"))
        pswView.frame = CGRectMake(10, 5, 20, 20)
        password.leftViewMode = UITextFieldViewMode.Always
        password.addSubview(pswView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

