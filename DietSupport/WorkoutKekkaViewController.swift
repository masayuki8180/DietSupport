//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class WorkoutKekkaViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var mokuhyoWeightLabel: UILabel!
    var workoutList = NSMutableArray(array: [])
    var dayWorkoutT: DayWorkOutT!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("ABC \(appDelegate.selectedMenuT.menuNo)")
        workoutList = appDelegate.dbService.selectWorkoutT(appDelegate.selectedMenuT.menuNo)
        
        // Cell名の登録をおこなう.
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        
        dayWorkoutT = appDelegate.dbService.selectDayWorkoutTByDay(appDelegate.selectedMenuT.menuNo, inDay: appDelegate.selectedDay)
        print("体重 \(dayWorkoutT.weight) 実績１ \(dayWorkoutT.jissekiValue1) 目標体重 \(dayWorkoutT.mokuhyoWeight) appDelegate.selectedDay \(appDelegate.selectedDay)")
        if dayWorkoutT.weight != 0 {
            weight.text = String(dayWorkoutT.weight)
        }
        
        weight.returnKeyType = .Done
        
        mokuhyoWeightLabel.text = "目標体重　".stringByAppendingString(String(dayWorkoutT.mokuhyoWeight))
        // Do any additional setup after loading the view, typically from a nib.
    }

    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("workoutList.count　\(workoutList.count)")
        return workoutList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
        // 再利用するCellを取得する.
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        // Cellに値を設定する.
        let workoutT: WorkOutT = workoutList.objectAtIndex(indexPath.row) as! WorkOutT
        print("開始　" + workoutT.workOUtName)
        cell.textLabel?.text = workoutT.workOUtName
        
        //let label = tableView.viewWithTag(1) as! UILabel
        //label.text = workoutT.workOUtName
        
        var contentLabel = UILabel()
        contentLabel = UILabel(frame: CGRectMake(10, 20, 300, 15))
        contentLabel.text = workoutT.workOUtName
        contentLabel.font = UIFont.systemFontOfSize(22)
        cell.addSubview(contentLabel)
        */
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //let label1: UILabel
        //label1 = tableView.viewWithTag(1) as! UILabel
        //label1.text = "No.\(indexPath.row + 1)"
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutCell", forIndexPath: indexPath)
        

        //cell.textLabel!.text = "ジョギングだべ"
        //let label1 = cell.contentView.viewWithTag(1) as! UILabel
        //label1.text = "多い"
        
        // Labelを作成.
        //print("workoutT.workOutValueName \(indexPath.row)")
        let workoutT: WorkOutT = workoutList.objectAtIndex(indexPath.row) as! WorkOutT
        
        let workOUtNameLabel: UILabel = UILabel(frame: CGRectMake(130,10,100,20))
        workOUtNameLabel.text = workoutT.workOUtName
        workOUtNameLabel.textColor = UIColor.blackColor()
        cell.contentView.addSubview(workOUtNameLabel)
        
        let workOUtValueTextField: UITextField = UITextField(frame: CGRectMake(200,45,100,30))
        
        workOUtValueTextField.text = String(self.getWorkOUtValue(indexPath.row,workOut: workoutT))
        workOUtValueTextField.delegate = self
        workOUtValueTextField.tag = (indexPath.row + 1) * 10
        workOUtValueTextField.borderStyle = UITextBorderStyle.Line
        cell.contentView.addSubview(workOUtValueTextField)
        
        let workOutValueNameLabel: UILabel = UILabel(frame: CGRectMake(303,55,30,15))
        workOutValueNameLabel.text = workoutT.workOutValueName
        //print("workoutT.workOutValueName \(workoutT.workOutValueName)")
        workOutValueNameLabel.font = UIFont.systemFontOfSize(CGFloat(13))
        workOutValueNameLabel.textColor = UIColor.blackColor()
        cell.contentView.addSubview(workOutValueNameLabel)
        
        let btn: UIButton = UIButton()
        
        btn.frame = CGRectMake(400,45,50,30)
        btn.backgroundColor = UIColor.blueColor()
        btn.layer.masksToBounds = true
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //btn.layer.cornerRadius = 20.0
        btn.tag = indexPath.row + 1
        //btn.addTarget(self, action: "dayWorkoutSave:", forControlEvents: .TouchUpInside)
        btn.addTarget(self, action:#selector(self.dayWorkoutSave(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(btn)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    
    @IBAction func save(){
        dayWorkoutT.weight = Double(weight.text!)!
        dayWorkoutT.menuNo = appDelegate.selectedMenuT.menuNo
        dayWorkoutT.day = appDelegate.selectedDay
        appDelegate.dbService.updateDayWorkoutT(dayWorkoutT)
    }
    
    func getWorkOUtValue(index: Int,workOut: WorkOutT) -> Int{
    
        var rt: Int = 0
        
        switch index {
            case 0:
                if dayWorkoutT.jissekiValue1 > 0 {
                    rt = dayWorkoutT.jissekiValue1
                }else{
                    rt = workOut.workOUtValue
                }
            case 1:
                if dayWorkoutT.jissekiValue2 > 0 {
                    rt = dayWorkoutT.jissekiValue2
                }else{
                    rt = workOut.workOUtValue
                }
            case 2:
                if dayWorkoutT.jissekiValue3 > 0 {
                    rt = dayWorkoutT.jissekiValue3
                }else{
                    rt = workOut.workOUtValue
                }
            case 3:
                if dayWorkoutT.jissekiValue4 > 0 {
                    rt = dayWorkoutT.jissekiValue4
                }else{
                    rt = workOut.workOUtValue
                }
            case 4:
                if dayWorkoutT.jissekiValue5 > 0 {
                    rt = dayWorkoutT.jissekiValue5
                }else{
                    rt = workOut.workOUtValue
                }
            default:
                break
        }
        return rt
    
    }
    
    func dayWorkoutSave(btn: UIButton){
    
        if btn.tag == 1 {
            let cell = btn.superview?.superview as! UITableViewCell
            let txtField = cell.contentView.viewWithTag(btn.tag*10) as! UITextField
            dayWorkoutT.jissekiValue1 = Int(txtField.text!)!
            dayWorkoutT.jissekiCal1 = 100
            dayWorkoutT.menuNo = appDelegate.selectedMenuT.menuNo
            dayWorkoutT.day = appDelegate.selectedDay
            appDelegate.dbService.updateDayWorkoutT1(dayWorkoutT)
        }
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

