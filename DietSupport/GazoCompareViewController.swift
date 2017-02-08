//
//  XXXViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class GazoCompareViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var beforeImgView: UIImageView = UIImageView()
    var afterImgView: UIImageView = UIImageView()
    var beforeLabel: UILabel = UILabel()
    var datePicker: UIPickerView! = nil
    let tagBeforeImgView = 1
    let tagAfterImgView = 2
    var datePickerSelected:Int = 0
    var dayWorkList:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "写真比較";
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        //self.view.addGestureRecognizer(tapGestureRecognizer)
        //tapGestureRecognizer.cancelsTouchesInView = false
        //self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        let infoLabel: UILabel = UILabel(frame: CGRect(x: self.view.frame.width*0.1,y: self.view.frame.height*0.08,width: self.view.frame.width*0.8,height: self.view.frame.height*0.204))
        infoLabel.text = "画像を選択して過去・未来の\n自分同士を比較しましょう。"
        infoLabel.font = UIFont.boldSystemFont(ofSize: 17)
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.textColor = UIColor.lightGray
        infoLabel.numberOfLines = 2
        self.view.addSubview(infoLabel)
        
        beforeImgView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height/2-(self.view.frame.height*0.37/2), width: self.view.frame.width/2, height: self.view.frame.height*0.37))
        beforeImgView.image = UIImage(named: "person.png")!
        beforeImgView.tag = tagBeforeImgView
        self.view.addSubview(beforeImgView)
        
        beforeLabel = UILabel(frame: CGRect(x: 0,y: 0-(self.view.frame.height*0.05),width: self.view.frame.width/2,height: self.view.frame.height*0.045))
        beforeLabel.text = ""
        beforeLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        beforeLabel.adjustsFontSizeToFitWidth = true
        beforeLabel.textAlignment = .center
        beforeLabel.backgroundColor = UIColor.white
        beforeLabel.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        beforeLabel.layer.borderWidth = 1
        beforeLabel.textColor = UIColor.black
        beforeImgView.addSubview(beforeLabel)
        
        //let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imgViewTap(_:)))
        //beforeImgView.addGestureRecognizer(myTap)
        
        afterImgView = UIImageView(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2-(self.view.frame.height*0.37/2), width: self.view.frame.width/2, height: self.view.frame.height*0.37))
        afterImgView.image = UIImage(data: appDelegate.selectedDayWorkOutT.gazo)
        afterImgView.tag = tagAfterImgView
        self.view.addSubview(afterImgView)
        
        let afterLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0-(self.view.frame.height*0.05),width: self.view.frame.width/2,height: self.view.frame.height*0.045))
        afterLabel.text = Util.ISOStringFromDate2(Util.dateFromISOString2(appDelegate.selectedDayWorkOutT.day))
        afterLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        afterLabel.adjustsFontSizeToFitWidth = true
        afterLabel.textAlignment = .center
        afterLabel.backgroundColor = UIColor.white
        afterLabel.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        afterLabel.layer.borderWidth = 1
        afterLabel.textColor = UIColor.black
        afterLabel.adjustsFontSizeToFitWidth = true
        afterLabel.textAlignment = .center
        afterImgView.addSubview(afterLabel)
        
        let wkDayWorkList:NSMutableArray = appDelegate.dbService.selectDayWorkoutT(appDelegate.selectedMenuT.menuNo)
        var imgSet = false
        var cnt = 0
        for wkDayWorkout in wkDayWorkList.reversed() {
            let dayWorkout = wkDayWorkout as! DayWorkOutT
            if dayWorkout.gazo.count > 0 {
                dayWorkList.add(dayWorkout)
                if imgSet == true {
                    beforeImgView.image = UIImage(data: dayWorkout.gazo)
                    beforeLabel.text = Util.ISOStringFromDate2(Util.dateFromISOString2(dayWorkout.day))
                    imgSet = false
                    datePickerSelected = cnt
                }
                if dayWorkout.day == appDelegate.selectedDayWorkOutT.day{
                    imgSet = true
                }
                cnt = cnt + 1
            }
        }
        
        datePicker = UIPickerView()
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 1.0
        datePicker.layer.shadowOpacity = 1.0
        //datePicker.layer.borderColor = UIColor.black.cgColor
        //datePicker.layer.borderWidth = 0.5
        datePicker.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        datePicker.layer.shadowOpacity = 0.8
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.selectRow(datePickerSelected, inComponent: 0, animated: true)
        self.view.addSubview(datePicker)
    }
    
    /*
    func imgViewTap(_ sender:UITapGestureRecognizer){
        print("タッチ！！")

        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
        }
     
        datePicker = UIPickerView()
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.selectRow(datePickerSelected, inComponent: 0, animated: true)
        self.view.addSubview(datePicker)
    }*/
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("タッチ！！")
        
        // タッチイベントを取得する
        let touch = touches.first
        if touch.tag
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
        }
        
        let wkDayWorkList:NSMutableArray = appDelegate.dbService.selectDayWorkoutT(appDelegate.selectedMenuT.menuNo)
        for wkDayWorkout in wkDayWorkList {
            let dayWorkout = wkDayWorkout as! DayWorkOutT
            if dayWorkout.gazo.count > 0 {
                dayWorkList.add(dayWorkout)
            }
        }
        
        datePicker = UIPickerView()
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        datePicker.delegate = self
        datePicker.dataSource = self
        self.view.addSubview(datePicker)
    }*/

    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayWorkList.count
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        let dayWorkOutT:DayWorkOutT = dayWorkList.object(at: row) as! DayWorkOutT
        
        return Util.ISOStringFromDate2(Util.dateFromISOString2(dayWorkOutT.day))
    }

    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dayWorkOutT:DayWorkOutT = dayWorkList.object(at: row) as! DayWorkOutT
        beforeImgView.image = UIImage(data: dayWorkOutT.gazo)
        beforeLabel.text = Util.ISOStringFromDate2(Util.dateFromISOString2(dayWorkOutT.day))
        datePickerSelected = row
        
    }
    
    /*
    func viewTapped(_ sender: UIView){
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

