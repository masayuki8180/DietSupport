//
//  DBService.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation

class DBService: NSObject {

    var db:FMDatabase = FMDatabase()
    
    func initDatabase(){
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dirPath = paths.first! as String

        let manager = FileManager()
        if(!manager.fileExists(atPath: dirPath + "/dietDB.db")){
            print("ファイルなし" + dirPath)
            db = FMDatabase(path: dirPath + "/dietDB.db")
            db.open()
            createUserT()
            createMenuT()
            createWorkoutT()
            createDayWorkoutT()
            db.close()
        }else{
            print("ファイルあり")
            db = FMDatabase(path: dirPath + "/dietDB.db")
        }

    
    }
    
    func createUserT(){
    
        let sql = "CREATE TABLE  UserT('user_id' INTEGER, 'name' TEXT, 'sex' INTEGER, 'age' INTEGER, 'weight' REAL, 'metabolism' REAL,'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER);"
        let ret = db.executeUpdate(sql, withArgumentsIn: nil)
        
        if ret{
            print("ユーザーテーブル作成成功")
        }
    }
    
    func insertUserT(_ userT:UserT){
        let sql = "INSERT INTO UserT(user_id, name, sex, age, weight, metabolism, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        db.open()
        print("登録内容 " + userT.name);
        db.executeUpdate(sql, withArgumentsIn: [userT.userID, userT.name, userT.sex, userT.age ,userT.weight, userT.metabolism, "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func updateUserT(_ userT:UserT){
        let sql = "UPDATE UserT set name = ?, sex = ?, age = ?, weight = ?, metabolism = ?;"
        
        db.open()
        print("更新内容 name \(userT.name) age \(userT.age)");
        db.executeUpdate(sql, withArgumentsIn: [userT.name, userT.sex, userT.age ,userT.weight, userT.metabolism])
        db.close()
    }
    /*
    let sql = "UPDATE DayWorkoutT set weight = ?,jissekiValue1 = ?,jissekiCal1 = ?,jissekiValue2 = ?,jissekiCal2 = ?,jissekiValue3 = ?,jissekiCal3 = ?,jissekiValue4 = ?,jissekiCal4 = ?,jissekiValue5 = ?,jissekiCal5 = ? WHERE menuNo = ? AND day = ?;"
    print("UPDATE DayWorkoutT \(dayWorkOutT.weight) \(dayWorkOutT.menuNo) \(dayWorkOutT.day)")
    db.open()
    db.executeUpdate(sql, withArgumentsInArray: [dayWorkOutT.weight,dayWorkOutT.jissekiValue1, dayWorkOutT.jissekiCal1,dayWorkOutT.jissekiValue2, dayWorkOutT.jissekiCal2,dayWorkOutT.jissekiValue3, dayWorkOutT.jissekiCal3,dayWorkOutT.jissekiValue4, dayWorkOutT.jissekiCal4,dayWorkOutT.jissekiValue5, dayWorkOutT.jissekiCal5,dayWorkOutT.menuNo, dayWorkOutT.day])
    db.close()
    */
    
    func selectUserT() -> (UserT){
        let sql = "SELECT user_id, name, sex, age, weight, metabolism FROM UserT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:nil)
        let userT:UserT = UserT()
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            userT.userID = (quiz_results?.long(forColumn: "user_id"))!
            print("userT.userID = \(userT.userID)")
            userT.name = (quiz_results?.string(forColumn: "name"))!
            userT.sex = (quiz_results?.long(forColumn: "sex"))!
            userT.age = (quiz_results?.long(forColumn: "age"))!
            userT.weight = (quiz_results?.double(forColumn: "weight"))!
            userT.metabolism = (quiz_results?.double(forColumn: "metabolism"))!
        }
        
        db.close()
        
        return userT
    }
    
    func createMenuT(){
        
        let sql = "CREATE TABLE  MenuT('menuNo' INTEGER PRIMARY KEY AUTOINCREMENT, 'sakuseibi' TEXT, 'kaishi' TEXT, 'syuryo' TEXT, 'kaishiWeight' REAL, 'mokuHyoweight' REAL, 'jyutenSyubetsu' INTEGER, 'kiboCategory' INTEGER, 'gazo' BLOB, 'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER);"
        let ret = db.executeUpdate(sql, withArgumentsIn: nil)
        
        /*

         */
        
        if ret{
            print("メニューテーブル作成成功")
        }
    }
    
    func insertMenuT(_ menuT:MenuT){
        let sql = "INSERT INTO MenuT(sakuseibi, kaishi, syuryo, kaishiWeight, mokuHyoweight, jyutenSyubetsu, kiboCategory, gazo, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        print("menuT.kaishi \(menuT.kaishi)")
        print("menuT.syuryo \(menuT.syuryo)")
        print("menuT.kaishiWeight \(menuT.kaishiWeight)")
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [menuT.sakuseibi, menuT.kaishi, menuT.syuryo ,menuT.kaishiWeight, menuT.mokuHyoweight, menuT.jyutenSyubetsu, menuT.kiboCategory,menuT.gazo,  "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func selectMenuT() -> (NSMutableArray){
        let sql = "SELECT menuNo,sakuseibi, kaishi, syuryo, kaishiWeight, mokuHyoweight, jyutenSyubetsu, kiboCategory, gazo FROM MenuT ORDER BY menuNo DESC;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:nil)
        let menuList = NSMutableArray(array: [])
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            let menuT:MenuT = MenuT()
            menuT.menuNo = (quiz_results?.long(forColumn: "menuNo"))!
            menuT.sakuseibi = (quiz_results?.string(forColumn: "sakuseibi"))!
            menuT.kaishi = (quiz_results?.string(forColumn: "kaishi"))!
            menuT.syuryo = (quiz_results?.string(forColumn: "syuryo"))!
            menuT.kaishiWeight = (quiz_results?.double(forColumn: "kaishiWeight"))!
            menuT.mokuHyoweight = (quiz_results?.double(forColumn: "mokuHyoweight"))!
            menuT.jyutenSyubetsu = (quiz_results?.long(forColumn: "jyutenSyubetsu"))!
            menuT.kiboCategory = (quiz_results?.string(forColumn: "kiboCategory"))!
            if let data = (quiz_results?.data(forColumn: "gazo")) {
                menuT.gazo = data
            }
            menuList.add(menuT)
        }
        
        db.close()
        
        return menuList
    }
    
    func selectMaxMenuNo() -> (Int){
        let sql = "SELECT max(menuNo) as MaxNo FROM MenuT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:nil)
        var maxNo: Int = 0
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            maxNo = (quiz_results?.long(forColumn: "MaxNo"))!
        }
        
        db.close()
        
        return maxNo
    }
    
    func deleteMenuT(_ menuNo:Int){
        let sql = "DELETE FROM MenuT WHERE menuNo = ?;"
        
        print("DELETE FROM MenuT menuNo \(menuNo)")
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [menuNo])
        db.close()
    }
    
    func createWorkoutT(){
        
        let sql = "CREATE TABLE  workoutT('menuNo' INTEGER, 'workOutNo' INTEGER, 'workOUtID' INTEGER, 'workOUtName' TEXT, 'workOUtValue' INTEGER, 'workOutValueName' TEXT, 'workOUtCal' REAL, 'workOUtSetsumei' TEXT,'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER,PRIMARY KEY('menuNo','workOutNo'));"
        let ret = db.executeUpdate(sql, withArgumentsIn: nil)
        
        if ret{
            print("ワークアウトテーブル作成成功")
        }
    }
    
    func insertWorkoutT(_ workoutT:WorkOutT){
        let sql = "INSERT INTO workoutT(menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOutValueName, workOUtCal, workOUtSetsumei, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        db.open()
        print("登録 \(workoutT.menuNo)")
        db.executeUpdate(sql, withArgumentsIn: [workoutT.menuNo, workoutT.workOutNo, workoutT.workOUtID, workoutT.workOUtName ,workoutT.workOUtValue,workoutT.workOutValueName, workoutT.workOUtCal, workoutT.workOutSetsumei, "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func selectWorkoutT(_ menuNo:Int) -> (NSMutableArray){
        let sql = "SELECT menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOutValueName, workOUtCal,workOUtSetsumei FROM workoutT WHERE menuNo = ?;"
        //let sql = "SELECT menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOUtCal FROM workoutT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:[menuNo])
        //let quiz_results = db.executeQuery(sql, withArgumentsInArray:nil)
        let workoutList = NSMutableArray(array: [])
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            let workoutT:WorkOutT = WorkOutT()
            workoutT.menuNo = (quiz_results?.long(forColumn: "menuNo"))!

            workoutT.workOutNo = (quiz_results?.long(forColumn: "workOutNo"))!
            workoutT.workOUtID = (quiz_results?.string(forColumn: "workOUtID"))!
            workoutT.workOUtName = (quiz_results?.string(forColumn: "workOUtName"))!
            workoutT.workOUtValue = (quiz_results?.long(forColumn: "workOUtValue"))!
            workoutT.workOutValueName = (quiz_results?.string(forColumn: "workOutValueName"))!
            workoutT.workOUtCal = (quiz_results?.double(forColumn: "workOUtCal"))!
            workoutT.workOutSetsumei = (quiz_results?.string(forColumn: "workOUtSetsumei"))!
            workoutList.add(workoutT)
            //print("取得成功 \(workoutT.menuNo)  \(workoutT.workOUtName)")
        }
        
        db.close()
        
        return workoutList
    }
    
    func deleteWorkoutT(_ menuNo:Int){
        let sql = "DELETE FROM workoutT WHERE menuNo = ?;"
        
        print("DELETE FROM workoutT menuNo \(menuNo)")
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [menuNo])
        db.close()
    }
    
    func createDayWorkoutT(){
        
        let sql = "CREATE TABLE  DayWorkoutT('menuNo' INTEGER, 'day' INTEGER, 'mokuhyoWeight' REAL, 'weight' REAL, 'workOutNo1' INTEGER, 'jissekiValue1' INTEGER, 'jissekiCal1' REAL, 'workOutNo2' INTEGER, 'jissekiValue2' INTEGER, 'jissekiCal2' REAL, 'workOutNo3' INTEGER, 'jissekiValue3' INTEGER, 'jissekiCal3' REAL, 'workOutNo4' INTEGER, 'jissekiValue4' INTEGER, 'jissekiCal4' REAL, 'workOutNo5' INTEGER, 'jissekiValue5' INTEGER, 'jissekiCal5'     REAL, 'gazo' BLOB,PRIMARY KEY('menuNo','day'));"
        let ret = db.executeUpdate(sql, withArgumentsIn: nil)
        
        if ret{
            print("デイリーワークアウトテーブル作成成功")
        }
    }
    
    func insertDayWorkoutT(_ dayWorkoutT:DayWorkOutT){
        let sql = "INSERT INTO DayWorkoutT(menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5,gazo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        print("insertDayWorkoutT  \(dayWorkoutT.menuNo) \(dayWorkoutT.day)　\(dayWorkoutT.weight)")
        
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [dayWorkoutT.menuNo, dayWorkoutT.day,dayWorkoutT.mokuhyoWeight, dayWorkoutT.weight, dayWorkoutT.workOutNo1, dayWorkoutT.jissekiValue1, dayWorkoutT.jissekiCal1, dayWorkoutT.workOutNo2, dayWorkoutT.jissekiValue2, dayWorkoutT.jissekiCal2, dayWorkoutT.workOutNo3, dayWorkoutT.jissekiValue3, dayWorkoutT.jissekiCal3, dayWorkoutT.workOutNo4, dayWorkoutT.jissekiValue4, dayWorkoutT.jissekiCal4, dayWorkoutT.workOutNo5, dayWorkoutT.jissekiValue5, dayWorkoutT.jissekiCal5, dayWorkoutT.gazo])
        db.close()
    }
    
    func selectDayWorkoutTByDay(_ menuNo: Int, inDay: String) -> (DayWorkOutT){
        let sql = "SELECT menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5, gazo FROM DayWorkoutT WHERE menuNo = ? AND day = ?;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:[menuNo,inDay])
        let dayWorkoutT:DayWorkOutT = DayWorkOutT()
        
        //print("selectDayWorkoutT  \(menuNo) \(inDay)")
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            dayWorkoutT.menuNo = (quiz_results?.long(forColumn: "menuNo"))!
            dayWorkoutT.day = (quiz_results?.string(forColumn: "day"))!
            dayWorkoutT.mokuhyoWeight = (quiz_results?.double(forColumn: "mokuhyoWeight"))!
            dayWorkoutT.weight = (quiz_results?.double(forColumn: "weight"))!
            dayWorkoutT.workOutNo1 = (quiz_results?.long(forColumn: "workOutNo1"))!
            dayWorkoutT.jissekiValue1 = (quiz_results?.long(forColumn: "jissekiValue1"))!
            dayWorkoutT.jissekiCal1 = (quiz_results?.double(forColumn: "jissekiCal1"))!
            dayWorkoutT.workOutNo2 = (quiz_results?.long(forColumn: "workOutNo2"))!
            dayWorkoutT.jissekiValue2 = (quiz_results?.long(forColumn: "jissekiValue2"))!
            dayWorkoutT.jissekiCal2 = (quiz_results?.double(forColumn: "jissekiCal2"))!
            dayWorkoutT.workOutNo3 = (quiz_results?.long(forColumn: "workOutNo3"))!
            dayWorkoutT.jissekiValue3 = (quiz_results?.long(forColumn: "jissekiValue3"))!
            dayWorkoutT.jissekiCal3 = (quiz_results?.double(forColumn: "jissekiCal3"))!
            dayWorkoutT.workOutNo4 = (quiz_results?.long(forColumn: "workOutNo4"))!
            dayWorkoutT.jissekiValue4 = (quiz_results?.long(forColumn: "jissekiValue4"))!
            dayWorkoutT.jissekiCal4 = (quiz_results?.double(forColumn: "jissekiCal4"))!
            dayWorkoutT.workOutNo5 = (quiz_results?.long(forColumn: "workOutNo5"))!
            dayWorkoutT.jissekiValue5 = (quiz_results?.long(forColumn: "jissekiValue5"))!
            dayWorkoutT.jissekiCal5 = (quiz_results?.double(forColumn: "jissekiCal5"))!
            if let data = (quiz_results?.data(forColumn: "gazo")) {
                dayWorkoutT.gazo = data
            }
            
            print("selectDayWorkoutT-  \(dayWorkoutT.menuNo) \(dayWorkoutT.day)　\(dayWorkoutT.weight)　\(dayWorkoutT.jissekiValue1)")
        }
        
        db.close()
        
        return dayWorkoutT
    }

    func selectDayWorkoutTByDayFromTo(_ menuNo: Int, inDayFrom: String, inDayTo: String) -> (NSMutableArray){
        let sql = "SELECT menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5, gazo FROM DayWorkoutT WHERE menuNo = ? AND day >= ? AND day <= ?;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:[menuNo,inDayFrom,menuNo,inDayTo])
        let workoutDayList = NSMutableArray(array: [])
        
        //print("selectDayWorkoutT  \(menuNo) \(inDay)")
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            let dayWorkoutT:DayWorkOutT = DayWorkOutT()
            dayWorkoutT.menuNo = (quiz_results?.long(forColumn: "menuNo"))!
            dayWorkoutT.day = (quiz_results?.string(forColumn: "day"))!
            dayWorkoutT.mokuhyoWeight = (quiz_results?.double(forColumn: "mokuhyoWeight"))!
            dayWorkoutT.weight = (quiz_results?.double(forColumn: "weight"))!
            dayWorkoutT.workOutNo1 = (quiz_results?.long(forColumn: "workOutNo1"))!
            dayWorkoutT.jissekiValue1 = (quiz_results?.long(forColumn: "jissekiValue1"))!
            dayWorkoutT.jissekiCal1 = (quiz_results?.double(forColumn: "jissekiCal1"))!
            dayWorkoutT.workOutNo2 = (quiz_results?.long(forColumn: "workOutNo2"))!
            dayWorkoutT.jissekiValue2 = (quiz_results?.long(forColumn: "jissekiValue2"))!
            dayWorkoutT.jissekiCal2 = (quiz_results?.double(forColumn: "jissekiCal2"))!
            dayWorkoutT.workOutNo3 = (quiz_results?.long(forColumn: "workOutNo3"))!
            dayWorkoutT.jissekiValue3 = (quiz_results?.long(forColumn: "jissekiValue3"))!
            dayWorkoutT.jissekiCal3 = (quiz_results?.double(forColumn: "jissekiCal3"))!
            dayWorkoutT.workOutNo4 = (quiz_results?.long(forColumn: "workOutNo4"))!
            dayWorkoutT.jissekiValue4 = (quiz_results?.long(forColumn: "jissekiValue4"))!
            dayWorkoutT.jissekiCal4 = (quiz_results?.double(forColumn: "jissekiCal4"))!
            dayWorkoutT.workOutNo5 = (quiz_results?.long(forColumn: "workOutNo5"))!
            dayWorkoutT.jissekiValue5 = (quiz_results?.long(forColumn: "jissekiValue5"))!
            dayWorkoutT.jissekiCal5 = (quiz_results?.double(forColumn: "jissekiCal5"))!
            if let data = (quiz_results?.data(forColumn: "gazo")) {
                dayWorkoutT.gazo = data
            }
            workoutDayList.add(dayWorkoutT)
            print("selectDayWorkoutT-  \(dayWorkoutT.menuNo) \(dayWorkoutT.day)　\(dayWorkoutT.weight)　\(dayWorkoutT.jissekiValue1)")
        }
        
        db.close()
        
        return workoutDayList
    }

    func selectDayWorkoutT(_ menuNo: Int) -> (NSMutableArray){
        let sql = "SELECT menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5, gazo FROM DayWorkoutT WHERE menuNo = ? order by day;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsIn:[menuNo])
        
        let dayWorkoutList = NSMutableArray(array: [])
        
        while (quiz_results?.next())! {
            // カラム名を指定して値を取得する方法
            let dayWorkoutT:DayWorkOutT = DayWorkOutT()
            dayWorkoutT.menuNo = (quiz_results?.long(forColumn: "menuNo"))!
            dayWorkoutT.day = (quiz_results?.string(forColumn: "day"))!
            dayWorkoutT.mokuhyoWeight = (quiz_results?.double(forColumn: "mokuhyoWeight"))!
            dayWorkoutT.weight = (quiz_results?.double(forColumn: "weight"))!
            dayWorkoutT.workOutNo1 = (quiz_results?.long(forColumn: "workOutNo1"))!
            dayWorkoutT.jissekiValue1 = (quiz_results?.long(forColumn: "jissekiValue1"))!
            dayWorkoutT.jissekiCal1 = (quiz_results?.double(forColumn: "jissekiCal1"))!
            dayWorkoutT.workOutNo2 = (quiz_results?.long(forColumn: "workOutNo2"))!
            dayWorkoutT.jissekiValue2 = (quiz_results?.long(forColumn: "jissekiValue2"))!
            dayWorkoutT.jissekiCal2 = (quiz_results?.double(forColumn: "jissekiCal2"))!
            dayWorkoutT.workOutNo3 = (quiz_results?.long(forColumn: "workOutNo3"))!
            dayWorkoutT.jissekiValue3 = (quiz_results?.long(forColumn: "jissekiValue3"))!
            dayWorkoutT.jissekiCal3 = (quiz_results?.double(forColumn: "jissekiCal3"))!
            dayWorkoutT.workOutNo4 = (quiz_results?.long(forColumn: "workOutNo4"))!
            dayWorkoutT.jissekiValue4 = (quiz_results?.long(forColumn: "jissekiValue4"))!
            dayWorkoutT.jissekiCal4 = (quiz_results?.double(forColumn: "jissekiCal4"))!
            dayWorkoutT.workOutNo5 = (quiz_results?.long(forColumn: "workOutNo5"))!
            dayWorkoutT.jissekiValue5 = (quiz_results?.long(forColumn: "jissekiValue5"))!
            dayWorkoutT.jissekiCal5 = (quiz_results?.double(forColumn: "jissekiCal5"))!
            if let data = (quiz_results?.data(forColumn: "gazo")) {
                dayWorkoutT.gazo = data
            }
            dayWorkoutList.add(dayWorkoutT)
        }
        
        db.close()
        
        return dayWorkoutList
    }
    
    func updateDayWorkoutT(_ dayWorkOutT: DayWorkOutT){
        let sql = "UPDATE DayWorkoutT set weight = ?,jissekiValue1 = ?,jissekiCal1 = ?,jissekiValue2 = ?,jissekiCal2 = ?,jissekiValue3 = ?,jissekiCal3 = ?,jissekiValue4 = ?,jissekiCal4 = ?,jissekiValue5 = ?,jissekiCal5 = ?, gazo = ? WHERE menuNo = ? AND day = ?;"
        print("UPDATE DayWorkoutT \(dayWorkOutT.weight) \(dayWorkOutT.menuNo) \(dayWorkOutT.day) \(dayWorkOutT.jissekiCal1)  \(dayWorkOutT.jissekiCal2) ")
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [dayWorkOutT.weight,dayWorkOutT.jissekiValue1, dayWorkOutT.jissekiCal1,dayWorkOutT.jissekiValue2, dayWorkOutT.jissekiCal2,dayWorkOutT.jissekiValue3, dayWorkOutT.jissekiCal3,dayWorkOutT.jissekiValue4, dayWorkOutT.jissekiCal4,dayWorkOutT.jissekiValue5, dayWorkOutT.jissekiCal5, dayWorkOutT.gazo, dayWorkOutT.menuNo, dayWorkOutT.day])
        db.close()
    }
    
    func deleteDayWorkoutT(_ menuNo:Int){
        let sql = "DELETE FROM DayWorkoutT WHERE menuNo = ?;"
        
        print("DELETE FROM DayWorkoutT menuNo \(menuNo)")
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [menuNo])
        db.close()
    }


}
