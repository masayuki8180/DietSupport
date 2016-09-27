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
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let dirPath = paths.first! as String

        let manager = NSFileManager()
        if(!manager.fileExistsAtPath(dirPath + "/dietDB.db")){
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
    
        let sql = "CREATE TABLE  UserT('name' TEXT, 'sex' INTEGER, 'age' INTEGER, 'weight' REAL, 'metabolism' REAL,'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER);"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        if ret{
            print("ユーザーテーブル作成成功")
        }
    }
    
    func insertUserT(userT:UserT){
        let sql = "INSERT INTO UserT(name, sex, age, weight, metabolism, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        db.open()
        print("登録内容 " + userT.name);
        db.executeUpdate(sql, withArgumentsInArray: [userT.name, userT.sex, userT.age ,userT.weight, userT.metabolism, "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func selectUserT() -> (UserT){
        let sql = "SELECT name, sex, age, weight, metabolism FROM UserT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:nil)
        let userT:UserT = UserT()
        
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            userT.name = quiz_results.stringForColumn("name")
            userT.sex = quiz_results.longForColumn("sex")
            userT.age = quiz_results.longForColumn("age")
            userT.weight = quiz_results.doubleForColumn("weight")
            userT.metabolism = quiz_results.doubleForColumn("metabolism")
        }
        
        db.close()
        
        return userT
    }
    
    func createMenuT(){
        
        let sql = "CREATE TABLE  MenuT('menuNo' INTEGER PRIMARY KEY AUTOINCREMENT, 'sakuseibi' TEXT, 'kaishi' TEXT, 'syuryo' TEXT, 'kaishiWeight' REAL, 'mokuHyoweight' REAL, 'jyutenSyubetsu' INTEGER, 'kiboCategory' INTEGER,'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER);"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        /*

         */
        
        if ret{
            print("メニューテーブル作成成功")
        }
    }
    
    func insertMenuT(menuT:MenuT){
        let sql = "INSERT INTO MenuT(sakuseibi, kaishi, syuryo, kaishiWeight, mokuHyoweight, jyutenSyubetsu, kiboCategory, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        print("menuT.kaishi \(menuT.kaishi)")
        print("menuT.syuryo \(menuT.syuryo)")
        print("menuT.kaishiWeight \(menuT.kaishiWeight)")
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [menuT.sakuseibi, menuT.kaishi, menuT.syuryo ,menuT.kaishiWeight, menuT.mokuHyoweight, menuT.jyutenSyubetsu, menuT.kiboCategory, "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func selectMenuT() -> (NSMutableArray){
        let sql = "SELECT menuNo,sakuseibi, kaishi, syuryo, kaishiWeight, mokuHyoweight, jyutenSyubetsu, kiboCategory FROM MenuT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:nil)
        let menuList = NSMutableArray(array: [])
        
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            let menuT:MenuT = MenuT()
            menuT.menuNo = quiz_results.longForColumn("menuNo")
            menuT.sakuseibi = quiz_results.stringForColumn("sakuseibi")
            menuT.kaishi = quiz_results.stringForColumn("kaishi")
            menuT.syuryo = quiz_results.stringForColumn("syuryo")
            menuT.kaishiWeight = quiz_results.doubleForColumn("kaishiWeight")
            menuT.mokuHyoweight = quiz_results.doubleForColumn("mokuHyoweight")
            menuT.jyutenSyubetsu = quiz_results.longForColumn("jyutenSyubetsu")
            menuT.kiboCategory = quiz_results.longForColumn("kiboCategory")
            menuList.addObject(menuT)
        }
        
        db.close()
        
        return menuList
    }
    
    func selectMaxMenuNo() -> (Int){
        let sql = "SELECT max(menuNo) as MaxNo FROM MenuT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:nil)
        var maxNo: Int = 0
        
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            maxNo = quiz_results.longForColumn("MaxNo")
        }
        
        db.close()
        
        return maxNo
    }
    
    func createWorkoutT(){
        
        let sql = "CREATE TABLE  workoutT('menuNo' INTEGER, 'workOutNo' INTEGER, 'workOUtID' INTEGER, 'workOUtName' TEXT, 'workOUtValue' INTEGER, 'workOutValueName' TEXT, 'workOUtCal' INTEGER,'yobi1' TEXT, 'yobi2' TEXT, 'yobi3' TEXT, 'yobi4' TEXT, 'yobi5' TEXT,'yobi6' INTEGER, 'yobi7' INTEGER, 'yobi8' INTEGER, 'yobi9' INTEGER, 'yobi10' INTEGER,PRIMARY KEY('menuNo','workOutNo'));"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        if ret{
            print("ワークアウトテーブル作成成功")
        }
    }
    
    func insertWorkoutT(workoutT:WorkOutT){
        let sql = "INSERT INTO workoutT(menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOutValueName, workOUtCal, yobi1, yobi2, yobi3, yobi4, yobi5, yobi6, yobi7, yobi8, yobi9, yobi10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        db.open()
        print("登録 \(workoutT.menuNo)")
        db.executeUpdate(sql, withArgumentsInArray: [workoutT.menuNo, workoutT.workOutNo, workoutT.workOUtID, workoutT.workOUtName ,workoutT.workOUtValue,workoutT.workOutValueName, workoutT.workOUtCal, "", "", "", "", "", 0, 0, 0, 0, 0])
        db.close()
    }
    
    func selectWorkoutT(menuNo:Int) -> (NSMutableArray){
        let sql = "SELECT menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOutValueName, workOUtCal FROM workoutT WHERE menuNo = ?;"
        //let sql = "SELECT menuNo, workOutNo, workOUtID, workOUtName, workOUtValue, workOUtCal FROM workoutT;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:[menuNo])
        //let quiz_results = db.executeQuery(sql, withArgumentsInArray:nil)
        let workoutList = NSMutableArray(array: [])
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            let workoutT:WorkOutT = WorkOutT()
            workoutT.menuNo = quiz_results.longForColumn("menuNo")

            workoutT.workOutNo = quiz_results.longForColumn("workOutNo")
            workoutT.workOUtID = quiz_results.longForColumn("workOUtID")
            workoutT.workOUtName = quiz_results.stringForColumn("workOUtName")
            workoutT.workOUtValue = quiz_results.longForColumn("workOUtValue")
            workoutT.workOutValueName = quiz_results.stringForColumn("workOutValueName")
            workoutT.workOUtCal = quiz_results.longForColumn("workOUtCal")
            workoutList.addObject(workoutT)
            //print("取得成功 \(workoutT.menuNo)  \(workoutT.workOUtName)")
        }
        
        db.close()
        
        return workoutList
    }
    
    func createDayWorkoutT(){
        
        let sql = "CREATE TABLE  DayWorkoutT('menuNo' INTEGER, 'day' TEXT, 'mokuhyoWeight' REAL, 'weight' REAL, 'workOutNo1' INTEGER, 'jissekiValue1' INTEGER, 'jissekiCal1' INTEGER, 'workOutNo2' INTEGER, 'jissekiValue2' INTEGER, 'jissekiCal2' INTEGER, 'workOutNo3' INTEGER, 'jissekiValue3' INTEGER, 'jissekiCal3' INTEGER, 'workOutNo4' INTEGER, 'jissekiValue4' INTEGER, 'jissekiCal4' INTEGER, 'workOutNo5' INTEGER, 'jissekiValue5' INTEGER, 'jissekiCal5'     INTEGER,PRIMARY KEY('menuNo','day'));"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        if ret{
            print("デイリーワークアウトテーブル作成成功")
        }
    }
    
    func insertDayWorkoutT(dayWorkoutT:DayWorkOutT){
        let sql = "INSERT INTO DayWorkoutT(menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        print("insertDayWorkoutT  \(dayWorkoutT.menuNo) \(dayWorkoutT.day)　\(dayWorkoutT.weight)")
        
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [dayWorkoutT.menuNo, dayWorkoutT.day,dayWorkoutT.mokuhyoWeight, dayWorkoutT.weight, dayWorkoutT.workOutNo1, dayWorkoutT.jissekiValue1, dayWorkoutT.jissekiCal1, dayWorkoutT.workOutNo2, dayWorkoutT.jissekiValue2, dayWorkoutT.jissekiCal2, dayWorkoutT.workOutNo3, dayWorkoutT.jissekiValue3, dayWorkoutT.jissekiCal3, dayWorkoutT.workOutNo4, dayWorkoutT.jissekiValue4, dayWorkoutT.jissekiCal4, dayWorkoutT.workOutNo5, dayWorkoutT.jissekiValue5, dayWorkoutT.jissekiCal5])
        db.close()
    }
    
    func selectDayWorkoutTByDay(menuNo: Int, inDay: String) -> (DayWorkOutT){
        let sql = "SELECT menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5 FROM DayWorkoutT WHERE menuNo = ? AND day = ?;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:[menuNo,inDay])
        let dayWorkoutT:DayWorkOutT = DayWorkOutT()
        
        //print("selectDayWorkoutT  \(menuNo) \(inDay)")
        
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            dayWorkoutT.menuNo = quiz_results.longForColumn("menuNo")
            dayWorkoutT.day = quiz_results.stringForColumn("day")
            dayWorkoutT.mokuhyoWeight = quiz_results.doubleForColumn("mokuhyoWeight")
            dayWorkoutT.weight = quiz_results.doubleForColumn("weight")
            dayWorkoutT.workOutNo1 = quiz_results.longForColumn("workOutNo1")
            dayWorkoutT.jissekiValue1 = quiz_results.longForColumn("jissekiValue1")
            dayWorkoutT.jissekiCal1 = quiz_results.longForColumn("jissekiCal1")
            dayWorkoutT.workOutNo2 = quiz_results.longForColumn("workOutNo2")
            dayWorkoutT.jissekiValue2 = quiz_results.longForColumn("jissekiValue2")
            dayWorkoutT.jissekiCal2 = quiz_results.longForColumn("jissekiCal2")
            dayWorkoutT.workOutNo3 = quiz_results.longForColumn("workOutNo3")
            dayWorkoutT.jissekiValue3 = quiz_results.longForColumn("jissekiValue3")
            dayWorkoutT.jissekiCal3 = quiz_results.longForColumn("jissekiCal3")
            dayWorkoutT.workOutNo4 = quiz_results.longForColumn("workOutNo4")
            dayWorkoutT.jissekiValue4 = quiz_results.longForColumn("jissekiValue4")
            dayWorkoutT.jissekiCal4 = quiz_results.longForColumn("jissekiCal4")
            dayWorkoutT.workOutNo5 = quiz_results.longForColumn("workOutNo5")
            dayWorkoutT.jissekiValue5 = quiz_results.longForColumn("jissekiValue5")
            dayWorkoutT.jissekiCal5 = quiz_results.longForColumn("jissekiCal5")
            
            print("selectDayWorkoutT-  \(dayWorkoutT.menuNo) \(dayWorkoutT.day)　\(dayWorkoutT.weight)　\(dayWorkoutT.jissekiValue1)")
        }
        
        db.close()
        
        return dayWorkoutT
    }

    func selectDayWorkoutT(menuNo: Int) -> (NSMutableArray){
        let sql = "SELECT menuNo, day, mokuhyoWeight, weight, workOutNo1, jissekiValue1, jissekiCal1, workOutNo2, jissekiValue2, jissekiCal2, workOutNo3, jissekiValue3, jissekiCal3, workOutNo4, jissekiValue4, jissekiCal4, workOutNo5, jissekiValue5, jissekiCal5 FROM DayWorkoutT WHERE menuNo = ?;"
        
        db.open()
        let quiz_results = db.executeQuery(sql, withArgumentsInArray:[menuNo])
        
        let dayWorkoutList = NSMutableArray(array: [])
        
        while quiz_results.next() {
            // カラム名を指定して値を取得する方法
            let dayWorkoutT:DayWorkOutT = DayWorkOutT()
            dayWorkoutT.menuNo = quiz_results.longForColumn("menuNo")
            dayWorkoutT.day = quiz_results.stringForColumn("day")
            dayWorkoutT.mokuhyoWeight = quiz_results.doubleForColumn("mokuhyoWeight")
            dayWorkoutT.weight = quiz_results.doubleForColumn("weight")
            dayWorkoutT.workOutNo1 = quiz_results.longForColumn("workOutNo1")
            dayWorkoutT.jissekiValue1 = quiz_results.longForColumn("jissekiValue1")
            dayWorkoutT.jissekiCal1 = quiz_results.longForColumn("jissekiCal1")
            dayWorkoutT.workOutNo2 = quiz_results.longForColumn("workOutNo2")
            dayWorkoutT.jissekiValue2 = quiz_results.longForColumn("jissekiValue2")
            dayWorkoutT.jissekiCal2 = quiz_results.longForColumn("jissekiCal2")
            dayWorkoutT.workOutNo3 = quiz_results.longForColumn("workOutNo3")
            dayWorkoutT.jissekiValue3 = quiz_results.longForColumn("jissekiValue3")
            dayWorkoutT.jissekiCal3 = quiz_results.longForColumn("jissekiCal3")
            dayWorkoutT.workOutNo4 = quiz_results.longForColumn("workOutNo4")
            dayWorkoutT.jissekiValue4 = quiz_results.longForColumn("jissekiValue4")
            dayWorkoutT.jissekiCal4 = quiz_results.longForColumn("jissekiCal4")
            dayWorkoutT.workOutNo5 = quiz_results.longForColumn("workOutNo5")
            dayWorkoutT.jissekiValue5 = quiz_results.longForColumn("jissekiValue5")
            dayWorkoutT.jissekiCal5 = quiz_results.longForColumn("jissekiCal5")
            dayWorkoutList.addObject(dayWorkoutT)
        }
        
        db.close()
        
        return dayWorkoutList
    }
    
    func updateDayWorkoutT(dayWorkOutT: DayWorkOutT){
        let sql = "UPDATE DayWorkoutT set weight = ? WHERE menuNo = ? AND day = ?;"
        print("UPDATE DayWorkoutT \(dayWorkOutT.weight) \(dayWorkOutT.menuNo) \(dayWorkOutT.day)")
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [dayWorkOutT.weight,dayWorkOutT.menuNo, dayWorkOutT.day])
        db.close()
    }
    
    func updateDayWorkoutT1(dayWorkOutT: DayWorkOutT){
        let sql = "UPDATE DayWorkoutT set jissekiValue1 = ?,jissekiCal1 = ? WHERE menuNo = ? AND day = ?;"
        print("UPDATE DayWorkoutT \(dayWorkOutT.jissekiValue1) \(dayWorkOutT.menuNo) \(dayWorkOutT.day)")
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [dayWorkOutT.jissekiValue1, dayWorkOutT.jissekiCal1, dayWorkOutT.menuNo, dayWorkOutT.day])
        db.close()
    }


}