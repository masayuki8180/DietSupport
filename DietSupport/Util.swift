//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation

class Util{

    class func dateFromISOString(string: String) -> NSDate {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        return dateFormatter.dateFromString(string)!
        
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.dateFromString(string)!
         */
    }
    
    class func convertDateFormat(dateStr:String) -> NSDate {
        // 引数で渡ってきた文字列をNSDateFormatterでNSDateに直します
        let inFormatter = NSDateFormatter()
        inFormatter.dateFormat = "yyyy年MM月dd日"
        let date:NSDate = inFormatter.dateFromString(dateStr)!
        
        // NSDateから指定のフォーマットの文字列に変換します
        let outFormatter = NSDateFormatter()
        outFormatter.dateFormat = "yyyy-MM-dd"
        let str: String = outFormatter.stringFromDate(date)
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        return dateFormatter.dateFromString(str)!
    }
    
    class func dateFromISOString2(string: String) -> NSDate {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        return dateFormatter.dateFromString(string)!
        
        /*
         let dateFormatter = NSDateFormatter()
         dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
         dateFormatter.timeZone = NSTimeZone.localTimeZone()
         dateFormatter.dateFormat = "yyyy年MM月dd日"
         
         return dateFormatter.dateFromString(string)!
         */
    }
    
    class func ISOStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.stringFromDate(date)
    }
}
