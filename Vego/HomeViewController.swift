//
//  homeViewController.swift
//  Vego
//
//  Created by Faith Ben on 22/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {

    @IBOutlet weak var myPledgeButton: UIButton!
    @IBOutlet weak var recipeButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPledgeButton.imageView?.contentMode = .ScaleAspectFit
        recipeButton.imageView?.contentMode = .ScaleAspectFit
        restaurantButton.imageView?.contentMode = .ScaleAspectFit
        signOutButton.imageView?.contentMode = .ScaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
