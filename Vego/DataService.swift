//
//  DataService.swift
//  Vego
//
//  Created by Robin Lin on 27/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://vego.firebaseio.com"

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
    
    var PLEDGE_REF: Firebase {
        let currentPledge = self.CURRENT_USER_REF.childByAppendingPath("pledge")
        
        return currentPledge!
    }
    
    var DATES_REF: Firebase {
        let currentPledge = self.CURRENT_USER_REF.childByAppendingPath("pledge")
        
        return currentPledge!
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
        let endDateData = calendar.dateByAddingUnit(.Day, value: period * 28, toDate: NSDate(), options: [])
        let endDate = dateFormatter.stringFromDate(endDateData!)
        
        let pledge: Dictionary<String, String> = [
            "period": String(period),
            "days": String(days),
            "pledged_days": String(days),
            "start_date": startDate,
            "end_date": endDate]
        CURRENT_USER_REF.childByAppendingPath("pledge").setValue(pledge)
    }
    
    func updatePledge(newPeriod: Int, newDays: Int, lastPledge: Dictionary<String, String>) {
        let pledgedEndDateString = lastPledge["end_date"]!
        let pledgedDays = Int(lastPledge["days"]!)!
        let pledgedPeriod = Int(lastPledge["period"]!)!
        let finalDays = newDays + pledgedDays
        let finalPeriod = newPeriod + pledgedPeriod
        
        // Set and format of dates
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Get NSDates
        let pledgedEndDate = dateFormatter.dateFromString(pledgedEndDateString)!
        let currentDate = NSDate()
        
        // Get current calendar
        let calendar = NSCalendar.currentCalendar()
        
        // If current date is earlier than pledged end date
        if currentDate.compare(pledgedEndDate) == .OrderedAscending {
            let endDate = calendar.dateByAddingUnit(.Day, value: finalPeriod * 28, toDate: pledgedEndDate, options: [])
            let finalEndDateString = dateFormatter.stringFromDate(endDate!)
            
            // Update database
            let pledge: Dictionary<String, String> = [
                "period": String(finalPeriod),
                "days": String(finalDays),
                "pledged_days": String(finalDays),
                "end_date": finalEndDateString]
            CURRENT_USER_REF.childByAppendingPath("pledge").updateChildValues(pledge)
        
        } else {
            let endDate = calendar.dateByAddingUnit(.Day, value: newPeriod * 28, toDate: currentDate, options: [])
            let finalEndDateString = dateFormatter.stringFromDate(endDate!)
            let startDateString = dateFormatter.stringFromDate(currentDate)
            
            // Update database
            let pledge: Dictionary<String, String> = [
                "period": String(pledgedPeriod),
                "days": String(pledgedDays),
                "pledged_days": String(finalDays),
                "start_date": startDateString,
                "end_date": finalEndDateString]
            CURRENT_USER_REF.childByAppendingPath("pledge").updateChildValues(pledge)
        }
    }
    
    func updateCounter(newPledgeDays: Int) {
        let COUNTER_REF = BASE_REF.childByAppendingPath("counter")
        COUNTER_REF.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
                let currentCountsString = snapshot.value as! String
                let currentCounts = Int(currentCountsString)!
                let newCounts = currentCounts + newPledgeDays
                self.BASE_REF.updateChildValues(["counter": "\(newCounts)"])
        })
    }
}