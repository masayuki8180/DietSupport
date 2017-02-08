//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuMakeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var genWeightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    var datePicker: UIDatePicker! = nil
    var pickerMode: Int = 0
    @IBOutlet weak var kaishiBtn: UIButton!
    @IBOutlet weak var syuryoBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var jyutenBtn: UIButton!
    @IBOutlet weak var kaishiHisuLabel: UILabel!
    @IBOutlet weak var syuryoHisuLabel: UILabel!
    @IBOutlet weak var kaishiWHisuLabel: UILabel!
    @IBOutlet weak var syuryoWHisuLabel: UILabel!
    var jyutenPicker: UIPickerView! = nil
    var jyutenArr: NSArray = ["なし","小","中","大"]
    var jyutenSelected:Int = 0
    @IBOutlet weak var workGroupBtn: UIButton!
    var workGroupPicker: UIPickerView! = nil
    var workGroupArr = NSMutableArray(array: [])
    //var workGroupArr: NSArray = ["なし","筋トレ","ヨガ","ジョギング"]
    var workGroupSelected:Int = 0
    var pickerBackView: UIView = UIView()

    var userT: UserT = UserT()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        navigationItem.title = "メニュー作成"
        
        self.view.backgroundColor = UIColor.white
        
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.onClickRightButton(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
        appDelegate.cameraMode = .menuCamera
        
        kaishiBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        kaishiBtn.layer.borderColor = UIColor.lightGray.cgColor
        kaishiBtn.layer.borderWidth = 1
        kaishiBtn.tag = 1;
        let date: Date = Date()
        kaishiBtn.setTitle(self.stringFromDate(date, format: "yyyy年MM月dd日"), for: UIControlState())
        
        syuryoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        syuryoBtn.layer.borderColor = UIColor.lightGray.cgColor
        syuryoBtn.layer.borderWidth = 1
        syuryoBtn.tag = 2;
        syuryoBtn.setTitle(self.stringFromDate(date, format: "yyyy年MM月dd日"), for: UIControlState())
        
        userT = appDelegate.dbService.selectUserT()
        
        genWeightTextField.delegate = self
        genWeightTextField.keyboardType = .decimalPad
        genWeightTextField.layer.borderColor = UIColor.lightGray.cgColor
        genWeightTextField.layer.borderWidth = 1
        genWeightTextField.placeholder = "タップして開始体重を入力"
        genWeightTextField.tag = 1
        genWeightTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        genWeightTextField.text = String(userT.weight)
        
        weightTextField.delegate = self
        weightTextField.keyboardType = .decimalPad
        weightTextField.layer.borderColor = UIColor.lightGray.cgColor
        weightTextField.layer.borderWidth = 1
        weightTextField.placeholder = "タップして目標体重を入力"
        weightTextField.tag = 2
        weightTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        
        jyutenBtn.setTitle("\(jyutenArr[0])", for: UIControlState())
        jyutenBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        jyutenBtn.layer.borderColor = UIColor.lightGray.cgColor
        jyutenBtn.layer.borderWidth = 1
        
        workGroupBtn.setTitle("なし", for: UIControlState())
        workGroupBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        workGroupBtn.layer.borderColor = UIColor.lightGray.cgColor
        workGroupBtn.layer.borderWidth = 1
        
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.layer.cornerRadius = 3
    
        kaishiHisuLabel.backgroundColor = UIColor.red
        kaishiHisuLabel.layer.cornerRadius = 3
        kaishiHisuLabel.clipsToBounds = true
        kaishiHisuLabel.textColor = UIColor.white
        
        syuryoHisuLabel.backgroundColor = UIColor.red
        syuryoHisuLabel.layer.cornerRadius = 3
        syuryoHisuLabel.clipsToBounds = true
        syuryoHisuLabel.textColor = UIColor.white
        
        kaishiWHisuLabel.backgroundColor = UIColor.red
        kaishiWHisuLabel.layer.cornerRadius = 3
        kaishiWHisuLabel.clipsToBounds = true
        kaishiWHisuLabel.textColor = UIColor.white
        
        syuryoWHisuLabel.backgroundColor = UIColor.red
        syuryoWHisuLabel.layer.cornerRadius = 3
        syuryoWHisuLabel.clipsToBounds = true
        syuryoWHisuLabel.textColor = UIColor.white
        
        workGroupArr = CloudSync.getCategory()
        let categoryT:CategoryT = CategoryT()
        categoryT.categoryID = "C000"
        categoryT.categoryName = "なし"
        workGroupArr.insert(categoryT, at: 0)
    }

    func viewTapped(_ sender: UIView){
    
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
            pickerBackView.removeFromSuperview()
            print("datePickerをお掃除")
        }
        
        if(jyutenPicker != nil){
            jyutenPicker.removeFromSuperview()
            jyutenPicker = nil
            pickerBackView.removeFromSuperview()
            print("jyutenPickerをお掃除")
        }
        
        if(workGroupPicker != nil){
            workGroupPicker.removeFromSuperview()
            workGroupPicker = nil
            pickerBackView.removeFromSuperview()
            print("workGroupPickerをお掃除")
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func dateSelected(_ sender: UIButton){
        
        weightTextField.resignFirstResponder()
        
        if(datePicker != nil){
            datePicker.removeFromSuperview()
            datePicker = nil
            pickerBackView.removeFromSuperview()
            print("datePickerをお掃除")
        }
        
        datePicker = UIDatePicker()
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        
        datePicker.addTarget(self, action:#selector(MenuMakeViewController.onDidChangeDate(_:)), for: .valueChanged)
        
        var str_date: String! = ""
        
        if sender.tag == 1 {
            pickerMode = 1
            str_date = kaishiBtn.currentTitle
        }else{
            pickerMode = 2
            str_date = syuryoBtn.currentTitle
        }

        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy年MM月dd日"
        let d:Date = myDateFormatter.date(from: str_date)!
        datePicker.setDate(d, animated: true)
        
        pickerBackView.frame = self.view.bounds
        pickerBackView.backgroundColor = UIColor.black
        pickerBackView.alpha = 0.5
        self.view.addSubview(pickerBackView)
        
        self.view.addSubview(datePicker)
    }
    
    internal func onDidChangeDate(_ sender: UIDatePicker){
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy年MM月dd日"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        if pickerMode == 1{
            kaishiBtn.setTitle(mySelectedDate as String, for: UIControlState())
        }else{
            syuryoBtn.setTitle(mySelectedDate as String, for: UIControlState())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func jyutenSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(jyutenPicker != nil){
            jyutenPicker.removeFromSuperview()
            jyutenPicker = nil
            pickerBackView.removeFromSuperview()
            print("jyutenPickerをお掃除")
        }
        
        jyutenPicker = UIPickerView()
        jyutenPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        jyutenPicker.backgroundColor = UIColor.white
        jyutenPicker.layer.cornerRadius = 5.0
        jyutenPicker.layer.shadowOpacity = 0.5
        jyutenPicker.delegate = self
        jyutenPicker.dataSource = self
        jyutenPicker.tag = sender.tag
        jyutenPicker.selectRow(jyutenSelected, inComponent: 0, animated: true)
        self.view.addSubview(jyutenPicker)
    }

    @IBAction func workGroupSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(workGroupPicker != nil){
            workGroupPicker.removeFromSuperview()
            workGroupPicker = nil
            pickerBackView.removeFromSuperview()
            print("workGroupPickerをお掃除")
        }
        
        workGroupPicker = UIPickerView()
        workGroupPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        workGroupPicker.backgroundColor = UIColor.white
        workGroupPicker.layer.cornerRadius = 5.0
        workGroupPicker.layer.shadowOpacity = 0.5
        workGroupPicker.delegate = self
        workGroupPicker.dataSource = self
        workGroupPicker.tag = 2
        if(sender.tag == 1){
            workGroupPicker.selectRow(workGroupSelected, inComponent: 0, animated: true)
        }
        self.view.addSubview(workGroupPicker)
    }

    @IBAction func next(_ sender: UIButton){
        
        if genWeightTextField.text?.characters.count == 0 {
            self.alertView("", "開始体重を入力してください。")
            return
        }else{
            if Double(genWeightTextField.text!) == nil{
                self.alertView("", "開始体重が不正です。")
                return
            }else{
                if Double(genWeightTextField.text!)! < 20 || Double(genWeightTextField.text!)! > 200 {
                    self.alertView("", "開始体重が不正です。\n(体重：20~200)")
                    return
                }
            }
        }

        
        if weightTextField.text?.characters.count == 0 {
            self.alertView("", "目標体重を入力してください。")
            return
        }else{
            if Double(weightTextField.text!) == nil{
                self.alertView("", "目標体重が不正です。")
                return
            }else{
                if Double(weightTextField.text!)! < 20 || Double(weightTextField.text!)! > 200 {
                    self.alertView("", "目標体重が不正です。\n(体重：20~200)")
                    return
                }
            }
        }
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.menuT.kaishi = kaishiBtn.currentTitle!
        appDelegate.menuT.syuryo = syuryoBtn.currentTitle!
        appDelegate.menuT.kaishiWeight = Double(genWeightTextField.text!)!
        appDelegate.menuT.mokuHyoweight = Double(weightTextField.text!)!
        appDelegate.menuT.jyutenSyubetsu = jyutenSelected
        let categoryT:CategoryT = workGroupArr.object(at: workGroupSelected) as! CategoryT
        appDelegate.menuT.kiboCategory = categoryT.categoryID
        
        let seUserT = appDelegate.dbService.selectUserT()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        globalQueue.async {
            let rt = CloudSync.demandMenu(appDelegate.menuT, userT: seUserT)
        
            DispatchQueue.main.async {
                indicator.stopAnimating()
                indicator.removeFromSuperview()

                if rt.1 == "" {
                    appDelegate.cloudmenuList.removeAllObjects()
                    appDelegate.cloudmenuList = rt.0
                    self.performSegue(withIdentifier: "menuSelectViewController", sender:self)
                }else{
                    self.alertView("", rt.1)
                    return
                }
            }
        }
    }
    
    func stringFromDate(_ date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var value:Int = 0
        if(pickerView.tag == 1){
            value = 4
        }else{
            value = workGroupArr.count
        }
        return value
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        var str:String = ""
        if(pickerView.tag == 1){
            str = jyutenArr[row] as! String
        }else{
            let categoryT:CategoryT = workGroupArr.object(at: row) as! CategoryT
            str = categoryT.categoryName
        }
        
        return str
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("値: \(jyutenArr[row])")
        if(pickerView.tag == 1){
            if(pickerView.tag == 1){
                jyutenSelected = row
                jyutenBtn.setTitle(jyutenArr[row] as? String, for: UIControlState())
            }
        }else{
            if(pickerView.tag == 2){
                workGroupSelected = row
                let categoryT:CategoryT = workGroupArr.object(at: row) as! CategoryT
                workGroupBtn.setTitle(categoryT.categoryName, for: UIControlState())
            }
        }
    }
    
    func alertView(_ title: String, _ msg: String) {
        MyAlertController.show(presentintViewController: self, title: "", message:msg, buttonTitle: "OK")
        { action in
            switch action {
            case .ok :break
            default  :break
            }
        }
    }
    
    func onClickRightButton(_ sender: UIButton){
        MyAlertController.show(presentintViewController: self, title: "", message: "メニューの作成をキャンセルしてもよろしいですか？",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
            switch action {
            case .ok :
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
                break
            case .cancel :break
            }
        }
    }
    
    func textFieldChange(_ sender: UITextField) {
        let txtField = sender
        if let str = txtField.text {
            let arr = str.components(separatedBy:".")
            if arr.count > 2 {
                if str.characters.count > 5 {
                    txtField.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
                    
                }
            }else{
                if arr[0].characters.count > 3 {
                    if arr.count > 1 {
                        txtField.text = arr[0].substring(to: arr[0].index(arr[0].startIndex, offsetBy: 3)) + "." + arr[1]
                    }else{
                        txtField.text = arr[0].substring(to: arr[0].index(arr[0].startIndex, offsetBy: 3))
                    }
                }
                if arr.count > 1 {
                    if arr[1].characters.count > 1 {
                        txtField.text = arr[0] + "." + arr[1].substring(to: arr[1].index(arr[1].startIndex, offsetBy: 1))
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

