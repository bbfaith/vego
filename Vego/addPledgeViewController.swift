//
//  addPledgeViewController.swift
//  Vego
//
//  Created by Faith Ben on 24/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class addPledgeViewController: UIViewController {

    @IBOutlet weak var quarterButton: UIButton!
    @IBOutlet weak var halfButton: UIButton!
    @IBOutlet weak var quarter3Button: UIButton!
    @IBOutlet weak var fullButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quarterButton.imageView?.contentMode = .ScaleAspectFit
        halfButton.imageView?.contentMode = .ScaleAspectFit
        quarter3Button.imageView?.contentMode = .ScaleAspectFit
        fullButton.imageView?.contentMode = .ScaleAspectFit
        // Do any additional setup after loading the view.
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
