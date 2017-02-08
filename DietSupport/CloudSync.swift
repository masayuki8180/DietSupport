//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class CloudSync{

    class func HTTPPostRequest(_ dict: [String: AnyObject], api_url: String) -> Any {
        let url = URL(string: ConstStruct.site_url + api_url)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var json: String = ""
        do {
            // Dict -> JSON
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: []) //(*)options??
            
            json = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print("Error!: \(error)")
        }
        
        let strData = json.data(using: String.Encoding.utf8)
        request.httpBody = strData
        
        var jsonDict: Any = {}
        
        do {
            // API POST
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
            
            json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            
            // JSON -> Dict
            jsonDict = try JSONSerialization.jsonObject(with: data, options: []) //(*)options??
            print(jsonDict)
            
            
            //if let team1 = jsonDict["team1"] as? [String: Any] {
            //}
            
        } catch {
            print("error!: \(error)")
        }
        
        return jsonDict
    }
    
    class func chkVersion(){
        let version: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let appVer: Double = NSString(string: version!).doubleValue
        
        let jsonData: [String: AnyObject] = [
            "key": "munbai" as AnyObject
        ]
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.get_version_url)
        
        var cloudVer: Double = 1.00
        /*
         if let jsonResult = data as? [String: Any] {
         cloudVer = NSString(string: jsonResult["version_no"] as! String).doubleValue
         }*/
        
        if let jsonResult = data as? [String: Any] {
            let result = jsonResult["result"] as Any
            if let jsonResult = result as? [String: Any] {
                cloudVer = NSString(string: jsonResult["version_no"] as! String).doubleValue
                
                print("appVer = \(appVer)  cloudVer = \(cloudVer)")
                if appVer < cloudVer {
                    
                    let itunesURL:String = "itms-apps://itunes.apple.com/app/710247888"
                    let url = URL(string:itunesURL)
                    let app:UIApplication = UIApplication.shared
                    app.openURL(url!)
                }
            }
        }else{
            print("バージョン比較できず")
        }
    }

    class func editUser(_ mode: Int, userT: UserT) -> (Bool,UserT){
        
        var rt: Bool = false
        
        let jsonData: [String: AnyObject] = [
            "toroku_syubetsu": String(mode) as AnyObject
            ,"user_id": userT.userID as AnyObject
            ,"user_name": userT.name as AnyObject
            ,"sex": userT.sex as AnyObject
            ,"age": userT.age as AnyObject
            ,"weight": userT.weight as AnyObject
            ,"metabolism": userT.metabolism as AnyObject
        ]
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.user_edit_url)
        
        if let jsonResult = data as? [String: Any] {
            let result = jsonResult["status"] as! Int;
            if result == 0 {
                if mode == 0 {
                    userT.userID = jsonResult["result"] as! Int
                }
                rt = true
            }else{
                rt = false
            }
            //    userT.userID = NSString(string: jsonResult["result"] as! String).integerValue

            //}
        }else{
            rt = false
        }
        
        return (rt,userT)
    }
    
    class func demandMenu(_ menuT: MenuT, userT: UserT) -> (NSMutableArray,String){
        
        let daySpan: Int = Int((Util.convertDateFormat(menuT.syuryo).timeIntervalSince(Util.convertDateFormat(menuT.kaishi)))/60/60/24)+1
        
        let jsonData: [String: AnyObject] = [
            "day_span": String(daySpan) as AnyObject
            ,"genzai_weight": String(menuT.kaishiWeight) as AnyObject
            ,"mokuhyo_weight": String(menuT.mokuHyoweight) as AnyObject
            ,"sex": String(userT.sex) as AnyObject
            ,"age": String(userT.age) as AnyObject
            ,"metabolism": String(userT.metabolism) as AnyObject
            ,"kyodo": String(menuT.jyutenSyubetsu) as AnyObject
            ,"kibo_workout_category": String(menuT.kiboCategory) as AnyObject
        ]
        
        print("jsonData = \(jsonData)")
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.get_menu_url)
        
        let cloudmenuList = NSMutableArray(array: [])
        var str: String = ""
        
        if let jsonResult = data as? [String: Any] {
            let resultStatus = jsonResult["status"] as! Int;
            if resultStatus == 0 {
                let result = jsonResult["result"] as! [Any]
                for i in 0..<result.count {
                    if let jsonResult2 = result[i] as? [Any] {
                        
                        let workoutList = NSMutableArray(array: [])
                        
                        for i in 0..<jsonResult2.count {
                            if let jsonResult3 = jsonResult2[i] as? [String: Any] {
                                let workOutT:WorkOutT = WorkOutT()
                                workOutT.workOUtID = jsonResult3["workout_id"] as! String
                                workOutT.workOUtName = jsonResult3["workout_name"] as! String
                                workOutT.workOutValueName = jsonResult3["unit_name"] as! String
                                workOutT.workOUtCal = jsonResult3["cal"] as! Double
                                workOutT.workOUtValue = jsonResult3["workout_value"] as! Int
                                workOutT.workOutSetsumei = jsonResult3["setsumei"] as! String
                                //print("workOutT.workOUtName = \(workOutT.workOUtName) workOutT.workOUtValue = \(workOutT.workOUtValue) workOutT.workOUtCal = \(workOutT.workOUtCal)")
                                workoutList.add(workOutT)
                            }
                        }
                        
                        cloudmenuList.add(workoutList)
                    }
                }
            }else{
                str = jsonResult["error"] as! String;
            }
        }else{
            str = "メニューの取得に失敗しました。通信環境をご確認の上、再度お試しください。"
        }
        
        return (cloudmenuList,str);
        
        //print("appVer = \(appVer)  cloudVer = \(cloudVer)")
    }

    class func demandAdvice(_ jyokenList: NSMutableArray) -> (Bool,String){
        
        let jsonData: [String: AnyObject] = [
            "syubetsu": jyokenList.object(at: 0) as AnyObject
            ,"mokuhyo_weight": jyokenList.object(at: 1) as AnyObject
            ,"genzai_weight": jyokenList.object(at: 2) as AnyObject
            ,"mokuhyo_cal": jyokenList.object(at: 3) as AnyObject
            ,"jisseki_cal": jyokenList.object(at: 4) as AnyObject
        ]
        
        print("jsonData = \(jsonData)")
        
        var rt: Bool = false
        var str: String = ""
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.get_advice_url)
        
        if let jsonResult = data as? [String: Any] {
            let result = jsonResult["status"] as! Int;
            if result == 0 {
                str = jsonResult["result"] as! String
                //for i in 0..<result.count {
                    //if let jsonResult2 = result[i] as? [String: Any] {
                        //str = result2["msg"] as! String
                        print("str = \(str)")
                rt = true
                    //}
               // }
            }
        }else{
            rt = false
            str = "アドバイスの取得に失敗しました。通信環境をご確認の上、再度お試しください。"
        }
        
        return (rt,str)
        
        //print("appVer = \(appVer)  cloudVer = \(cloudVer)")
    }
    
    class func getCategory() -> NSMutableArray{
        
        let categoryList = NSMutableArray(array: [])
        
        let jsonData: [String: AnyObject] = [
            "key": "" as AnyObject
        ]
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.get_category_url)
        if let jsonResult = data as? [String: Any] {
            let result = jsonResult["result"] as! [Any]
            for i in 0..<result.count {
                if let jsonResult2 = result[i] as? [String: Any] {
                    /*
                    let category = jsonResult3["category_id"] as! String
                    let categoryName = jsonResult3["category_name"] as! String
                    print("category = \(category) categoryName = \(categoryName)")
                     */
                    
                    let categoryT:CategoryT = CategoryT()
                    categoryT.categoryID = jsonResult2["category_id"] as! String
                    categoryT.categoryName = jsonResult2["category_name"] as! String
                    categoryList.add(categoryT)
                    print(" categoryName = \(categoryT.categoryName)")
                }
            }
        }
        
        return categoryList
    }

    class func getWorkout() -> NSMutableArray{
        
        let workoutList = NSMutableArray(array: [])
        
        let jsonData: [String: AnyObject] = [
            "key": "" as AnyObject
        ]
        
        let data: Any = HTTPPostRequest(jsonData,api_url: ConstStruct.get_workout_url)
        
        if let jsonResult = data as? [String: Any] {
            let result = jsonResult["result"] as! [Any]
            for i in 0..<result.count {
                if let jsonResult2 = result[i] as? [String: Any] {
                    /*
                     
                    let category = jsonResult3["workout_id"] as! String
                    let categoryName = jsonResult3["category_name"] as! String
                    print("category = \(category) categoryName = \(categoryName)")
                    */
                    
                    let workOutT:WorkOutT = WorkOutT()
                    workOutT.workOUtID = jsonResult2["workout_id"] as! String
                    workOutT.workOUtName = jsonResult2["workout_name"] as! String
                    workOutT.categoryID = jsonResult2["category_id"] as! String
                    workOutT.workOutValueName = jsonResult2["unit_name"] as! String
                    workOutT.workOUtCal = Double(jsonResult2["mets"] as! String)!
                    workOutT.workOutSetsumei = jsonResult2["setsumei"] as! String
                    workoutList.add(workOutT)
                }
            }
        }
        
        return workoutList
    }
}
