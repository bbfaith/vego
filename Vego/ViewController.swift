//
//  ViewController.swift
//  Vego
//
//  Created by Faith Ben on 20/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 0.5
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

