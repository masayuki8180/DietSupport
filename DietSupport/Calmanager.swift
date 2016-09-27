//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func monthAgoDate() -> NSDate {
        let addValue = -1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func monthLaterDate() -> NSDate {
        let addValue: Int = 1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
}

class CalManager: NSObject {
    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = NSDate()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    //月の初日を取得
    func firstDateOfMonth() -> NSDate {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day],
                                                                 fromDate: selectedDate)
        components.day = 1
        let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components)!
        return firstDateMonth
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDateOfMonth())
        for var i = 0; i < numberOfItems; i++ {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!
            // ④配列に追加
            //print("date \(date)")
            currentMonthOfDates.append(date)
        }
    }
    
    // ⑵表記の変更
    func conversionDateFormat(indexPath: NSIndexPath) -> (String,Bool) {
        var rt: Bool = true

        dateForCellAtIndexPath(numberOfItems)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //print("date000 \(appDelegate.selectedMenuT.kaishi)")
        //print("a")
        //let datefrom: NSDate = Util.dateFromISOString(appDelegate.selectedMenuT.kaishi) as NSDate
        print("Util.convertDateFormat(appDelegate.selectedMenuT.kaishi) \(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi))")
        print("currentMonthOfDates[indexPath.row] \(currentMonthOfDates[indexPath.row])")
        if((currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedAscending) || (currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo)) == NSComparisonResult.OrderedDescending)){
            rt = false
            print("範囲外")
        }else if(currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedDescending){
            print("範囲内")
            rt = true
        }else{
            print("範囲内")
            rt = true
        }
        
        return (formatter.stringFromDate(currentMonthOfDates[indexPath.row]),rt)
    }
    
    //前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
}
