//
//  CalendarViewController.swift
//  Vego
//
//  Created by Mu Lan on 23/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate  {
    
    var datesWithCat : NSMutableArray = ["2016-04-01","2016-04-30","2016-05-01", "2016-05-31"]
    var count = 0
    
    @IBOutlet var monthInfo: UILabel!
    
    @IBOutlet var dayInfo: UILabel!
    
    @IBOutlet var calendar: FSCalendar!
    
    @IBAction func sign(sender: AnyObject) {
        if(datesWithCat.containsObject(calendar.stringFromDate(NSDate()))){
            let alert = UIAlertController(title: "Hey!", message: "You already checked today!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler:nil))
            alert.view.setNeedsLayout()
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            datesWithCat.addObject(calendar.stringFromDate(NSDate()))
            dayInfo.text = "Well Done!"
            count += 1
            monthInfo.text = "You checked " + (count as NSNumber).stringValue + " day this month!"
            self.calendar.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let newDate = addDaystoGivenDate(NSDate(), NumberOfDaysToAdd: 1)
//        print(calendar.dateFromString("2015-12-01", format: "yyyy-MM-dd"))
//        print(newDate)
        self.dayInfo.text = ""
        countMonth(NSDate())
        monthInfo.text = "You checked " + (count as NSNumber).stringValue + " day this month!"
    }
    
    func countMonth(nsdate : NSDate) {
        count = 0
        for date in datesWithCat {
//            print(calendar.monthOfDate(nsdate))
            if(calendar.monthOfDate(calendar.dateFromString(date as! String, format: "yyyy-MM-dd")) == calendar.monthOfDate(nsdate)) {
                count += 1
            }
        }
    }
    
    func addDaystoGivenDate(baseDate:NSDate,NumberOfDaysToAdd:Int)->NSDate
    {
        let dateComponents = NSDateComponents()
        let CurrentCalendar = NSCalendar.currentCalendar()
        let CalendarOption = NSCalendarOptions()
        
        dateComponents.day = NumberOfDaysToAdd
        
        let newDate = CurrentCalendar.dateByAddingComponents(dateComponents, toDate: baseDate, options: CalendarOption)
        return newDate!
    }
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 12, day: 31)
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let day = calendar.dayOfDate(date)
        return day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        self.dayInfo.text = ""
        if(calendar.monthOfDate((calendar.currentPage)) > calendar.monthOfDate(NSDate())){
            monthInfo.text = "Future will be better"
        } else {
            countMonth((calendar.currentPage))
            monthInfo.text = "You checked " + (count as NSNumber).stringValue + " day this month!"
        }
//        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        if(datesWithCat.containsObject(calendar.stringFromDate(date)))
        {
            self.dayInfo.text = "Well Done!"
        } else {
            self.dayInfo.text = ""
        }

//        NSLog("calendar did select date \(calendar.stringFromDate(date))")
    }
    
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return datesWithCat.containsObject(calendar.stringFromDate(date)) ? UIImage(named: "icon_cat") : nil

    }
}

