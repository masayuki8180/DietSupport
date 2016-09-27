//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuMakeViewController: UIViewController, UITextFieldDelegate {

    private var genWeightTextField: UITextField = UITextField()
    private var weightTextField: UITextField = UITextField()
    var datePicker: UIDatePicker! = nil
    var pickerMode: Int = 0
    var kaishiBtn: UIButton!
    var syuryoBtn: UIButton!
    var userT: UserT = UserT()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.userInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))
        
        let button = UIButton(frame: CGRectMake(310, 100, 30, 30))
        let buttonImage:UIImage = UIImage(named: "nextBtn.png")!
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(MenuMakeViewController.next(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        let kikanLabel = UILabel(frame:CGRectMake(50, 145, 100, 25))
        kikanLabel.text = "ダイエット期間";
        kikanLabel.font = UIFont.systemFontOfSize(15)
        kikanLabel.textAlignment = NSTextAlignment.Left
        kikanLabel.textColor = UIColor.blackColor()
        self.view.addSubview(kikanLabel)
        
        kaishiBtn = UIButton(frame: CGRectMake(50, 170, 120, 30))
        kaishiBtn.backgroundColor = UIColor.lightGrayColor()
        kaishiBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        kaishiBtn.tag = 1;
        let date: NSDate = NSDate()
        kaishiBtn.setTitle(self.stringFromDate(date, format: "yyyy年MM月dd日"), forState: .Normal)
        kaishiBtn.addTarget(self, action:#selector(MenuMakeViewController.dateSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(kaishiBtn)
        
        syuryoBtn = UIButton(frame: CGRectMake(200, 170, 120, 30))
        syuryoBtn.backgroundColor = UIColor.lightGrayColor()
        syuryoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        syuryoBtn.tag = 2;
        syuryoBtn.setTitle(self.stringFromDate(date, format: "yyyy年MM月dd日"), forState: .Normal)
        syuryoBtn.addTarget(self, action:#selector(MenuMakeViewController.dateSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(syuryoBtn)
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        userT = appDelegate.dbService.selectUserT()
        
        let genWeightLabel = UILabel(frame:CGRectMake(50, 220, 100, 25))
        genWeightLabel.text = "現在体重"
        genWeightLabel.font = UIFont.systemFontOfSize(15)
        genWeightLabel.textAlignment = NSTextAlignment.Left
        genWeightLabel.textColor = UIColor.blackColor()
        self.view.addSubview(genWeightLabel)
        
        genWeightTextField = UITextField(frame: CGRectMake(50,250,150,30))
        genWeightTextField.delegate = self
        genWeightTextField.borderStyle = UITextBorderStyle.Line
        genWeightTextField.returnKeyType = .Done
        genWeightTextField.text = String(userT.weight)
        self.view.addSubview(genWeightTextField)

        /*
        let genWeightValueLabel = UILabel(frame:CGRectMake(50, 250, 100, 35))
        genWeightValueLabel.text = String(userT.weight);
        genWeightValueLabel.font = UIFont.systemFontOfSize(17)
        genWeightValueLabel.textAlignment = NSTextAlignment.Left
        genWeightValueLabel.textColor = UIColor.blackColor()
        self.view.addSubview(genWeightValueLabel)
         */
        
        let mokuhyoWeightLabel = UILabel(frame:CGRectMake(50, 300, 100, 25))
        mokuhyoWeightLabel.text = "目標体重"
        mokuhyoWeightLabel.font = UIFont.systemFontOfSize(15)
        mokuhyoWeightLabel.textAlignment = NSTextAlignment.Left
        mokuhyoWeightLabel.textColor = UIColor.blackColor()
        self.view.addSubview(mokuhyoWeightLabel)
        
        weightTextField = UITextField(frame: CGRectMake(50,325,150,30))
        weightTextField.delegate = self
        weightTextField.borderStyle = UITextBorderStyle.Line
        weightTextField.returnKeyType = .Done
        self.view.addSubview(weightTextField)
    }

    func viewTapped(sender: UIView){
    
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
            print("datePickerをお掃除")
        }
    }
    
    func dateSelected(sender: UIButton){
        
        weightTextField.resignFirstResponder()
        
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
            print("datePickerをお掃除")
        }
        
        datePicker = UIDatePicker()
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        datePicker.frame = CGRectMake(0, self.view.frame.height-200, self.view.frame.width, 200)
        datePicker.timeZone = NSTimeZone.localTimeZone()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        
        datePicker.addTarget(self, action:#selector(MenuMakeViewController.onDidChangeDate(_:)), forControlEvents: .ValueChanged)
        
        var str_date: String! = ""
        
        if sender.tag == 1 {
            pickerMode = 1
            str_date = kaishiBtn.currentTitle
        }else{
            pickerMode = 2
            str_date = syuryoBtn.currentTitle
        }

        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "yyyy年MM月dd日"
        let d:NSDate = myDateFormatter.dateFromString(str_date)!
        datePicker.setDate(d, animated: true)
        
        self.view.addSubview(datePicker)
    }
    
    internal func onDidChangeDate(sender: UIDatePicker){
        // フォーマットを生成.
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "yyyy年MM月dd日"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
        if pickerMode == 1{
            kaishiBtn.setTitle(mySelectedDate as String, forState: .Normal)
        }else{
            syuryoBtn.setTitle(mySelectedDate as String, forState: .Normal)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    func next(sender: UIButton){
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.menuT.kaishi = kaishiBtn.currentTitle!
        appDelegate.menuT.syuryo = syuryoBtn.currentTitle!
        appDelegate.menuT.kaishiWeight = Double(genWeightTextField.text!)!
        appDelegate.menuT.mokuHyoweight = Double(weightTextField.text!)!
        
        let menuMake2ViewController = MenuMake2ViewController()
        self.navigationController?.pushViewController(menuMake2ViewController, animated: true)
    }
    
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

