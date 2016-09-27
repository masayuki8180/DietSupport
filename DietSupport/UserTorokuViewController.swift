//
//  UserTorokuViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit



class UserTorokuViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var infoView:UIView = UIView()
    private var nameTextField: UITextField = UITextField()
    private var ageTextField: UITextField = UITextField()
    private var weightTextField: UITextField = UITextField()
    private var metabolismTextField: UITextField = UITextField()
    var sexBtn: UIButton!
    var sexPicker: UIPickerView! = nil
    var sexArr: NSArray = ["男","女"]
    var sexSyubetsu:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.userInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))
        
        self.userInputViewSet()
        self.infoMsgViewSet()

    }
    
    func userInputViewSet(){
        let label = UILabel(frame:CGRectMake(50, 80, 100, 25))
        label.text = "ニックネーム";
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        self.view.addSubview(label)
        nameTextField = UITextField(frame: CGRectMake(50,105,150,30))
        nameTextField.delegate = self
        nameTextField.borderStyle = UITextBorderStyle.Line
        nameTextField.returnKeyType = .Done
        self.view.addSubview(nameTextField)
        
        let label2 = UILabel(frame:CGRectMake(50, 145, 100, 25))
        label2.text = "性別";
        label2.font = UIFont.systemFontOfSize(15)
        label2.textAlignment = NSTextAlignment.Left
        label2.textColor = UIColor.blackColor()
        self.view.addSubview(label2)
        
        sexBtn = UIButton(frame: CGRectMake(50, 170, 150, 30))
        sexBtn.backgroundColor = UIColor.lightGrayColor()
        sexBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        sexBtn.setTitle("男", forState: .Normal)
        sexBtn.addTarget(self, action:#selector(UserTorokuViewController.sexSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(sexBtn)
        
        let label3 = UILabel(frame:CGRectMake(50, 210, 100, 25))
        label3.text = "年齢";
        label3.font = UIFont.systemFontOfSize(15)
        label3.textAlignment = NSTextAlignment.Left
        label3.textColor = UIColor.blackColor()
        self.view.addSubview(label3)
        ageTextField = UITextField(frame: CGRectMake(50,235,150,30))
        ageTextField.delegate = self
        ageTextField.borderStyle = UITextBorderStyle.Line
        ageTextField.returnKeyType = .Done
        self.view.addSubview(ageTextField)
        
        let label4 = UILabel(frame:CGRectMake(50, 280, 100, 25))
        label4.text = "体重";
        label4.font = UIFont.systemFontOfSize(15)
        label4.textAlignment = NSTextAlignment.Left
        label4.textColor = UIColor.blackColor()
        self.view.addSubview(label4)
        weightTextField = UITextField(frame: CGRectMake(50,305,150,30))
        weightTextField.delegate = self
        weightTextField.borderStyle = UITextBorderStyle.Line
        weightTextField.returnKeyType = .Done
        self.view.addSubview(weightTextField)
        
        let label5 = UILabel(frame:CGRectMake(50, 345, 100, 25))
        label5.text = "基礎代謝";
        label5.font = UIFont.systemFontOfSize(15)
        label5.textAlignment = NSTextAlignment.Left
        label5.textColor = UIColor.blackColor()
        self.view.addSubview(label5)
        metabolismTextField = UITextField(frame: CGRectMake(50,370,150,30))
        metabolismTextField.delegate = self
        metabolismTextField.borderStyle = UITextBorderStyle.Line
        metabolismTextField.returnKeyType = .Done
        self.view.addSubview(metabolismTextField)
        
        let button2 = UIButton(frame: CGRectMake(50, 430, 50, 30))
        button2.backgroundColor = UIColor.lightGrayColor()
        button2.setTitle("登録", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button2.addTarget(self, action:#selector(UserTorokuViewController.userDataToroku(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
    }
    
    func infoMsgViewSet(){
        let boundSize: CGSize = UIScreen.mainScreen().bounds.size
        infoView = UIView(frame:CGRectMake(0, 0, boundSize.width, boundSize.height))
        infoView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(infoView)
        
        let label = UILabel(frame:CGRectMake(15, 0, boundSize.width-20, boundSize.height))
        label.text = "ダイエトンをインストールいただきありがとうございます。\n\nはじめにユーザー登録をしましょう！"
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 5
        infoView.addSubview(label)
        
        let button = UIButton(frame: CGRectMake(310, 100, 30, 30))
        let buttonImage:UIImage = UIImage(named: "nextBtn.png")!
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(UserTorokuViewController.next(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(button)
    }
    
    func next(sender: UIButton){
        infoView.removeFromSuperview()
    }
    
    func sexSelected(sender: UIButton){
        
        self.view.endEditing(true)
        
        if(sexPicker != nil){
            sexPicker.removeFromSuperview()
            sexPicker = nil
            print("sexPickerをお掃除")
        }
        
        sexPicker = UIPickerView()
        sexPicker.frame = CGRectMake(0, self.view.frame.height-200, self.view.frame.width, 200)
        sexPicker.backgroundColor = UIColor.whiteColor()
        sexPicker.layer.cornerRadius = 5.0
        sexPicker.layer.shadowOpacity = 0.5
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexPicker.selectRow(sexSyubetsu, inComponent: 0, animated: true)
        self.view.addSubview(sexPicker)
    }
    
    func userDataToroku(sender: UIButton){
        let alert: UIAlertController = UIAlertController(title: "アカウント登録", message: "この内容で登録してもいいですか？", preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let userT:UserT = UserT()
            userT.name = self.nameTextField.text!
            userT.sex = 1
            userT.age = Int(self.ageTextField.text!)!
            userT.weight = Double(self.weightTextField.text!)!
            userT.metabolism = Double(self.metabolismTextField.text!)!
            appDelegate.dbService.insertUserT(userT)
            
            self.navigationController?.popViewControllerAnimated(true)
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    //表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    //表示内容
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return sexArr[row] as! String
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("値: \(sexArr[row])")
        sexBtn.setTitle(sexArr[row] as? String, forState: .Normal)
        if row == 0{
            sexSyubetsu = 0
        }else{
            sexSyubetsu = 1
        }
    }
    
    func viewTapped(sender: UIView){
        
        if(sexPicker != nil){
            sexPicker.removeFromSuperview()
            sexPicker = nil
            print("sexPickerをお掃除")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("UserTorokuViewController viewWillAppear() is called")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
