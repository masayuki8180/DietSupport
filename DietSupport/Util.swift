//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation
import UIKit

class Util{

    class func dateFromISOString(_ string: String) -> Date {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: string)!
        
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.dateFromString(string)!
         */
    }
    
    class func convertDateFormat(_ dateStr:String) -> Date {
        // 引数で渡ってきた文字列をNSDateFormatterでNSDateに直します
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy年MM月dd日"
        let date:Date = inFormatter.date(from: dateStr)!
        
        // NSDateから指定のフォーマットの文字列に変換します
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "yyyy-MM-dd"
        let str: String = outFormatter.string(from: date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: str)!
    }
    
    class func dateFromISOString2(_ string: String) -> Date {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: string)!
    }
    
    class func dateFromISOString3(_ string: String) -> Date {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: string)!
    }
    
    class func stringFromDate(_ date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from:date)
    }
    
    class func endOfMonth(_ date:Date) -> Date
    {
        let cal = Calendar.current
        let flags : NSCalendar.Unit = [.year, .month, .day]
        let comps : DateComponents = (cal as NSCalendar).components(flags , from: date)
        
        var y = comps.year
        var m = comps.month
        m = m! + 1
        if (m! >= 13) {
            y = y! + 1
            m = 1
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        let firstOfMonth : Date = dateFormatter.date(from: "\(y!)-\(m!)-01")!
        
        let endOfMonth : Date = firstOfMonth
        return endOfMonth
    }
    
    class func ISOStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    class func ISOStringFromDate2(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy/M/d"
        
        return dateFormatter.string(from: date)
    }
    
    class func torokuDayWorkOutT(_ appDelegate: AppDelegate){
        let datefrom: Date = Util.dateFromISOString(appDelegate.menuT.kaishi) as Date
        //let datefrom = Util.stringFromDate(self.appDelegate.menuT.kaishi, format: "yyyy年MM月dd日"), forState: .Normal)
        let dateto: Date = Util.dateFromISOString(appDelegate.menuT.syuryo) as Date
        
        let span = datefrom.timeIntervalSince(dateto) // 1209600秒差
        var daySpan: Int = abs(Int(span/60/60/24))
        
        daySpan = daySpan + 1
        print("期間 \(daySpan)")
        
        var wkDate :Date
        wkDate = datefrom
        let dayWorkoutT:DayWorkOutT = DayWorkOutT()
        let sa: Double = (appDelegate.menuT.kaishiWeight - appDelegate.menuT.mokuHyoweight)/Double(daySpan)
        //let sa: Double = appDelegate.selectedMenuT.kaishiWeight - appDelegate.selectedMenuT.mokuHyoweight
        var genWeight: Double = appDelegate.menuT.kaishiWeight
        print("appDelegate.menuT.kaishiWeight \(appDelegate.menuT.kaishiWeight) appDelegate.menuT.mokuHyoweight \(appDelegate.menuT.mokuHyoweight) sa \(sa)")
        for i in 0..<daySpan {
            dayWorkoutT.menuNo = appDelegate.dbService.selectMaxMenuNo()
            dayWorkoutT.day = Util.ISOStringFromDate(wkDate)
            //print("作成する日付 \(dayWorkoutT.day)")
            dayWorkoutT.workOutNo1 = 0
            genWeight = genWeight - sa
            print("genWeight \(genWeight) sa \(sa)")
            dayWorkoutT.mokuhyoWeight = genWeight
            dayWorkoutT.jissekiValue1 = -1
            dayWorkoutT.jissekiCal1 = -1
            dayWorkoutT.workOutNo2 = 0
            dayWorkoutT.jissekiValue2 = -1
            dayWorkoutT.jissekiCal2 = -1
            dayWorkoutT.workOutNo3 = 0
            dayWorkoutT.jissekiValue3 = -1
            dayWorkoutT.jissekiCal3 = -1
            dayWorkoutT.workOutNo4 = 0
            dayWorkoutT.jissekiValue4 = -1
            dayWorkoutT.jissekiCal4 = -1
            dayWorkoutT.workOutNo5 = 0
            dayWorkoutT.jissekiValue5 = -1
            dayWorkoutT.jissekiCal5 = -1
            
            appDelegate.dbService.insertDayWorkoutT(dayWorkoutT)
            
            wkDate = Date(timeInterval: 60*60*24, since: wkDate) as Date
            print("\(i)")
        }
    }
    
    class func getKcal(_ value: Double, mets: Double, weight: Double) -> Double{
        var kcal: Double = 0.0
        
        kcal = (value/60) * mets * weight * 1.05
        
        return kcal
    }
    
    class func getStatusbarHight(_ navigationController: UINavigationController) -> CGFloat{
        
        // Status Barの高さを取得する.
        var barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
        let barHeight2: CGFloat? = navigationController.navigationBar.frame.size.height
        
        barHeight = barHeight! + barHeight2!
        
        return barHeight!
    }
    
    class func getWeightLastDay(_ appDelegate: AppDelegate, menuNo: Int) -> CGFloat{
        var rtWeight: CGFloat = 0.0
        let dayWorkList:NSMutableArray = appDelegate.dbService.selectDayWorkoutT(menuNo)
        //print("スタート)")
        if dayWorkList.count > 0 {
            //for i in dayWorkList.count...1 {
            for i in (0 ..< dayWorkList.count).reversed() {
                let dayWorkOutT = dayWorkList.object(at: i) as! DayWorkOutT
                //print("i = \(i) dayWorkOutT.weight = \(dayWorkOutT.weight)")
                if dayWorkOutT.weight > 0 {
                    //print(" 見つかった！ = \(i) dayWorkOutT.weight = \(dayWorkOutT.weight)")
                    rtWeight = CGFloat(dayWorkOutT.weight)
                    break
                }
            }
        }
        
        return rtWeight
        
        
    }
 }
