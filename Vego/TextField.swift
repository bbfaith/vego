//
//  textField.swift
//  Vego
//
//  Created by Mu Lan on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation
import UIKit

class TextField : UITextField {
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 5);
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override internal func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override internal func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override internal func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}