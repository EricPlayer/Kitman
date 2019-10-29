//
//  DateTimeFormatter.swift
//  Swagafied
//
//  Created by Amitabha on 24/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation

class DateTimeFormatter {
    // Create a shared variable
    
    let calendar = Calendar.current
    let formatter: DateFormatter = DateFormatter()
    var components = NSDateComponents()
    
    static let sharedFormatter = DateTimeFormatter()
    
    func convertDateToString(date:Date , dateFormatter:String) -> String{
        formatter.dateFormat = dateFormatter
        let dateT: String = formatter.string(from: date)
        return dateT
    }
    
    func convertStringToDate(dateString:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone.system
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    func timeFromNow(date : Date) -> String{
        
        let elapsedTime = NSDate().timeIntervalSince(date)
        let (h, m, _) = secondsToHoursMinutesSeconds (interval: elapsedTime)
        
        if h == 0 {
            return " \(m) minutes ago - "
        }else{
            
            if h > 23 {
                return " \(h/23)d\(h%23)h\(m)m - "
            }else{
                return " \(h)h\(m) - "
            }
        }
    }
    
    
    func secondsToHoursMinutesSeconds (interval:TimeInterval) -> (Int, Int, Int) {
        let seconds = NSInteger(interval)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
