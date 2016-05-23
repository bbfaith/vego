//
//  VoucherTableViewCell.swift
//  Vego
//
//  Created by Faith Ben on 22/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var voucherImageLabel: UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
