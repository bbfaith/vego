//
//  DataService.swift
//  Vego
//
//  Created by Robin Lin on 27/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewPledge(period: Int, days: Int) {
        // Set and format of dates
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Get current date
        let startDate = dateFormatter.stringFromDate(NSDate())
        
        // Get current calendar
        let calendar = NSCalendar.currentCalendar()
        
        // Get end date
        let endDateData = calendar.dateByAddingUnit(.Day, value: period, toDate: NSDate(), options: [])
        let endDate = dateFormatter.stringFromDate(endDateData!)
        
        let pledge: Dictionary<String, String> = [
            "period": String(period),
            "days": String(days),
            "start_date": startDate,
            "end_date": endDate]
        CURRENT_USER_REF.childByAppendingPath("pledge").setValue(pledge)
    }
}