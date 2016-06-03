//
//  CalendarViewController.swift
//  Vego
//
//  Created by Mu Lan on 23/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate  {
    
    var datesWCheckedIn : NSMutableArray = NSMutableArray()
    var count = 0
    
    @IBOutlet var monthInfo: UILabel!
    
    @IBOutlet var dayInfo: UILabel!
    
    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBAction func sign(sender: AnyObject) {
        // If the user already checked in today
        if(datesWCheckedIn.containsObject(calendar.stringFromDate(NSDate()))){
            let alert = UIAlertController(title: "Hey!", message: "You already checked today!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler:nil))
            alert.view.setNeedsLayout()
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Set and format of date
            let currentDateString = calendar.stringFromDate(NSDate())
            
            // Update info on the view
            datesWCheckedIn.addObject(currentDateString)
            dayInfo.text = "Well Done!"
            count += 1
            monthInfo.text = "You've checked " + String(count) + (count < 2 ? " day" : " days") + " this month!"
            self.calendar.reloadData()
            
            // Upload checked date to database
            DataService.dataService.createDate(currentDateString)
        }
    }
    
    func fetchDates() {
        let DATES_REF = DataService.dataService.DATES_REF
        DATES_REF.observeEventType(.Value, withBlock: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let dateKeyDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let dateString = dateKeyDictionary["date"] as! String
                        self.datesWCheckedIn.addObject(dateString)
                    }
                }
                // Update info on the view
                self.calendar.reloadData()
                self.countMonth(NSDate())
                self.monthInfo.text = "You've checked " + String(self.count) + (self.count < 2 ? " day" : " days") + " this month!"
                
                // If the user already checked in today
                if(self.datesWCheckedIn.containsObject(self.calendar.stringFromDate(NSDate()))){
                    self.checkInButton.enabled = false
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch checked dates from database
        fetchDates()
        
        self.dayInfo.text = ""
    }
    
    func countMonth(nsdate : NSDate) {
        count = 0
        for date in datesWCheckedIn {
            if(calendar.monthOfDate(calendar.dateFromString(date as! String, format: "yyyy-MM-dd")) == calendar.monthOfDate(nsdate)) {
                count += 1
            }
        }
    }
    
    func addDaystoGivenDate(baseDate:NSDate, NumberOfDaysToAdd:Int)->NSDate
    {
        let dateComponents = NSDateComponents()
        let CurrentCalendar = NSCalendar.currentCalendar()
        let CalendarOption = NSCalendarOptions()
        
        dateComponents.day = NumberOfDaysToAdd
        
        let newDate = CurrentCalendar.dateByAddingComponents(dateComponents, toDate: baseDate, options: CalendarOption)
        return newDate!
    }
    
    // Set the minimum display day for the calendar
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 5, day: 30)
    }
    
    // Set the maximum display day of the calendar
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 12, day: 31)
    }
    
    // Mark days every 5 days
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let day = calendar.dayOfDate(date)
        return day % 5 == 0 ? day/5 : 0;
    }
    
    // Count check-in days in this month
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        self.dayInfo.text = ""
        if(calendar.monthOfDate((calendar.currentPage)) > calendar.monthOfDate(NSDate())){
            monthInfo.text = "Future will be better"
        } else {
            countMonth((calendar.currentPage))
            monthInfo.text = "You checked " + (count as NSNumber).stringValue + " days this month!"
        }
    }
    
    // Show status of a day
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        if(datesWCheckedIn.containsObject(calendar.stringFromDate(date)))
        {
            self.dayInfo.text = "A meat free day! Well Done!"
        } else {
            self.dayInfo.text = ""
        }
    }
    
    // Change a day's image
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        let imageName = "veg" + String(arc4random_uniform(UInt32(31)) + 1)
        return datesWCheckedIn.containsObject(calendar.stringFromDate(date)) ? UIImage(named: imageName) : nil
        
    }
}

