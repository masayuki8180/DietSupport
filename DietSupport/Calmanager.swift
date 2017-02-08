//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
}

class CalManager: NSObject {
    var currentMonthOfDates = [Date]() //表記する月の配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
  
    //週の数を返すメソッド
    func getNumberOfWeeks() -> Int {
        let rangeOfWeeks = (Calendar.current as NSCalendar).range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        return numberOfWeeks
    }
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = (Calendar.current as NSCalendar).range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    //月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                 from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(_ numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth(), options: NSCalendar.Options(rawValue: 0))!
            // ④配列に追加
            //print("date \(date)")
            currentMonthOfDates.append(date)
        }
    }
    
    // ⑵表記の変更
    func conversionDateFormat(_ indexPath: IndexPath) -> (String,Bool,String) {
        var rt: Bool = true

        dateForCellAtIndexPath(numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        
        let formatter2: DateFormatter = DateFormatter()
        formatter2.dateFormat = "yyyyMMdd"
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //print("date000 \(appDelegate.selectedMenuT.kaishi)")
        //print("a")
        //let datefrom: NSDate = Util.dateFromISOString(appDelegate.selectedMenuT.kaishi) as NSDate
        //print("kaishi \(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi))　syuryo \(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo))")
        //print("currentMonthOfDates[indexPath.row] \(currentMonthOfDates[indexPath.row])")
        /*
        if((currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedAscending) || (currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo)) == NSComparisonResult.OrderedDescending)){
            rt = false
            print("範囲外")
        }else if(currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedDescending){
            print("範囲内")
            rt = true
        }else{
            print("範囲内")
            rt = true
        }*/
        
        /*
        if(currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedDescending){
            print("OrderedDescending")
            rt = true
        }else if(currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == NSComparisonResult.OrderedAscending){
            print("OrderedAscending")
        }*/
        
        //NSDate *date = [[NSDate alloc] init];
        //NSTimeInterval addDay = 86400;　//進めたい秒数
        //currentMonthOfDates[indexPath.row] = [NSDate dateWithTimeInterval:addDay sinceDate:date];
        let wkData: Date = Date(timeInterval: 60*60*24, since: currentMonthOfDates[indexPath.row])
        if((wkData.compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) == ComparisonResult.orderedAscending) || (currentMonthOfDates[indexPath.row].compare(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo)) == ComparisonResult.orderedDescending)){
            rt = false
            //print("範囲外")
        }else{
            //print("範囲内")
            rt = true
        }
        
        return (formatter.string(from: currentMonthOfDates[indexPath.row]),rt,formatter2.string(from: currentMonthOfDates[indexPath.row]))
    }
    
    //前月の表示
    func prevMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
    
    func isMonthRange(_ date: Date, mode: Int) -> Bool{
        var rt: Bool = true
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        print("date---- \(date)")
        print("kaishi \(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi))　syuryo \(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo))")
        if mode == 0 {
            if (date.compare(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)) != ComparisonResult.orderedAscending) {
                rt = true
            }else{rt = false}
        } else if mode == 1 {
            if (date.compare(Util.convertDateFormat(appDelegate.selectedMenuT.syuryo)) != ComparisonResult.orderedAscending) {
                rt = false
            }else{rt = true}
        }
        print("end")
        return rt
    }
}
