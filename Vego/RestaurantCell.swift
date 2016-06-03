//
//  RestaurantTableViewCell.swift
//  Vego
//
//  Created by Robin Lin on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    // MARK: Properties

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var cuisines: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rating.layer.cornerRadius = 8.0
        rating.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
