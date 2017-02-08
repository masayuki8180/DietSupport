//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class SelfMenuViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var categoryBtn: UIButton!
    var categoryPicker: UIPickerView! = nil
    var categorySelected:Int = 0
    var zanCal: Double = 0.0
    
    @IBOutlet weak var selfWorkoutBtn: UIButton!
    var selfWorkoutPicker: UIPickerView! = nil
    var selfWorkoutSelected:Int = 0
    
    var categoryList = NSMutableArray(array: [])
    var allWorkoutList = NSMutableArray(array: [])
    var workoutList = NSMutableArray(array: [])
    var kekkaWorkoutList = NSMutableArray(array: [])
    @IBOutlet weak var workOUtValueTextField: UITextField!
    @IBOutlet weak var workOUtValueLabel: UILabel!
    @IBOutlet weak var workOUtCalLabel: UILabel!
    //@IBOutlet weak var workOUtNameLabel: UILabel!
    @IBOutlet weak var calZanLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var fixBtn: UIButton!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var workoutTableViewCell: UITableViewCell!
    
    var pickerBackView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "メニュー作成"
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.onClickRightButton(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
        self.view.backgroundColor = UIColor.white
        
        print("appDelegate.menuT.kaishi = \(appDelegate.menuT.kaishi) appDelegate.menuT.syuryo = \(appDelegate.menuT.syuryo)")
        print("appDelegate.menuT.kaishiWeight = \(appDelegate.menuT.kaishiWeight) appDelegate.menuT.mokuHyoweight = \(appDelegate.menuT.mokuHyoweight)")
        let daySpan: Int = Int((Util.convertDateFormat(appDelegate.menuT.syuryo).timeIntervalSince(Util.convertDateFormat(appDelegate.menuT.kaishi)))/60/60/24)+1
        
        print("daySpan = \(daySpan)")
        zanCal = (((appDelegate.menuT.kaishiWeight-appDelegate.menuT.mokuHyoweight)*1000)*9)/Double(daySpan)
        
        categoryBtn.layer.borderColor = UIColor.lightGray.cgColor
        categoryBtn.layer.borderWidth = 1

        selfWorkoutBtn.layer.borderColor = UIColor.lightGray.cgColor
        selfWorkoutBtn.layer.borderWidth = 1
        
        workOUtValueTextField.layer.borderColor = UIColor.lightGray.cgColor
        workOUtValueTextField.layer.borderWidth = 1
        workOUtValueTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        
        workOUtCalLabel.textAlignment = NSTextAlignment.center
        workOUtCalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        workOUtCalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(15))
        workOUtCalLabel.layer.cornerRadius = 5
        workOUtCalLabel.clipsToBounds = true
        workOUtCalLabel.textColor = UIColor.white
        
        calZanLabel.text = "あと" + String(format: "%.1f",zanCal) + "kcal"
        calZanLabel.textAlignment = .center
        calZanLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        calZanLabel.font = UIFont.systemFont(ofSize: CGFloat(24))
        calZanLabel.layer.cornerRadius = 8
        calZanLabel.clipsToBounds = true
        calZanLabel.textColor = UIColor.white
        
        fixBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        fixBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        fixBtn.layer.cornerRadius = 3

        categoryList = CloudSync.getCategory()
        allWorkoutList = CloudSync.getWorkout()
        
        if categoryList.count < 1 || allWorkoutList.count < 1{
            print("おい")
            MyAlertController.show(presentintViewController: self, title: "", message: "ワークアウトの取得に失敗しました。通信環境をご確認の上、再度お試しください。", buttonTitle: "OK")
            { action in
                switch action {
                case .ok :
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                    return
                case .cancel:return
                }
            }
        }else{
        
            let categoryT:CategoryT = categoryList.object(at: 0) as! CategoryT
            workoutSet(categoryT.categoryID)
            
            self.view.isUserInteractionEnabled = true;
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.viewTapped(_:))))
            
            categoryBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            let wkCategoryT: CategoryT = categoryList.object(at: 0) as! CategoryT
            categoryBtn.setTitle("\(wkCategoryT.categoryName)", for: UIControlState())
            categoryBtn.tag = 1

            selfWorkoutBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            let wkWorkoutT: WorkOutT = workoutList.object(at: 0) as! WorkOutT
            selfWorkoutBtn.setTitle("\(wkWorkoutT.workOUtName)", for: UIControlState())
            selfWorkoutBtn.tag = 2
            
            self.displayWorkout(wkWorkoutT, x: 50, y: 250, w: 300, h: 100)
            
            //workoutTableView = UITableView(frame: CGRect(x: 0, y: 380, width: self.view.frame.width, height: 200))
            workoutTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            workoutTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            workoutTableView.layer.borderColor = UIColor.lightGray.cgColor
            workoutTableView.layer.borderWidth = 1
            
            let gUserT: UserT = appDelegate.dbService.selectUserT()
            
            var sexStr: String = ""
            if gUserT.sex == 1 {
                sexStr = "男性"
            }else if gUserT.sex == 2 {
                sexStr = "女性"
            }
            
            let strMsg: String = "　　性別：" + sexStr + "\n" + "　　年齢：" + String(gUserT.age) + "\n" + "　　体重：" + String(gUserT.weight) + "\n" +  "　　新陳代謝：" + String(gUserT.metabolism) + "\n\n上記の情報をもとにワークアウトを作成しました。"
            
            MyAlertController.show(presentintViewController: self, title: "", message:strMsg, buttonTitle: "OK")
            { action in
                switch action {
                case .ok :break
                case .cancel :break
                }
            }
        }
    }

    func workoutSet(_ categoryID: String){
        
        workoutList.removeAllObjects();
        
        for i in 0..<allWorkoutList.count {
            let workOutT:WorkOutT = allWorkoutList.object(at: i) as! WorkOutT
            if workOutT.categoryID == categoryID{
                workoutList.add(workOutT)
            }
        }
        
        /*
        if categoryID.compare(<#T##aString: String##String#>) == 1{
            print("menu 1")
            var workoutT:WorkOutT = WorkOutT()
            workoutT.menuNo = 1
            workoutT.workOUtID = 1000
            workoutT.workOUtName = "ジョギング"
            workoutT.workOutValueName = "km"
            workoutT.workOUtCal = 59
            workoutT.workOutSetsumei = "必死のジョギングです。自分で作ったメニューです。必死のジョギングです。自分で作ったメニューです。必死のジョギングです。自分で作ったメニューです。必死のジョギングです。自分で作ったメニューです。必死のジョギングです。自分で作ったメニューです。"
            workoutList.add(workoutT)
            
            workoutT = WorkOutT()
            workoutT.menuNo = 1
            workoutT.workOUtID = 2000
            workoutT.workOUtName = "ウォーキング"
            workoutT.workOutValueName = "km"
            workoutT.workOUtCal = 46
            workoutT.workOutSetsumei = "必死のウォーキングです。自分で作ったメニューです。"
            workoutList.add(workoutT)
            
        }else if menuNo == 2{
            print("menu 2")
            var workoutT:WorkOutT = WorkOutT()
            workoutT = WorkOutT()
            workoutT.menuNo = 2
            workoutT.workOUtID = 3000
            workoutT.workOUtName = "腹筋"
            workoutT.workOutValueName = "分"
            workoutT.workOUtCal = 9
            workoutT.workOutSetsumei = "必死の腹筋です。自分で作ったメニューです。"
            workoutList.add(workoutT)
            
            workoutT = WorkOutT()
            workoutT.menuNo = 2
            workoutT.workOUtID = 4000
            workoutT.workOUtName = "腕立て伏せ"
            workoutT.workOutValueName = "分"
            workoutT.workOUtCal = 5
            workoutT.workOutSetsumei = "必死の腕立て伏せです。自分で作ったメニューです。"
            workoutList.add(workoutT)
        }
         */
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    func next(_ sender: UIButton){
        let menuSelectViewController = MenuSelectViewController()
        self.navigationController?.pushViewController(menuSelectViewController, animated: true)
    }*/
    
    @IBAction func categorySelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(categoryPicker != nil){
            categoryPicker.removeFromSuperview()
            categoryPicker = nil
            pickerBackView.removeFromSuperview()
            print("categoryPickerをお掃除")
        }
        
        pickerBackView.frame = self.view.bounds
        pickerBackView.backgroundColor = UIColor.black
        pickerBackView.alpha = 0.5
        self.view.addSubview(pickerBackView)
        
        categoryPicker = UIPickerView()
        categoryPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        categoryPicker.backgroundColor = UIColor.white
        categoryPicker.layer.cornerRadius = 5.0
        categoryPicker.layer.shadowOpacity = 0.5
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.tag = sender.tag
        categoryPicker.selectRow(categorySelected, inComponent: 0, animated: true)
        
        self.view.addSubview(categoryPicker)
    }
    
    @IBAction func selfWorkoutSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(selfWorkoutPicker != nil){
            selfWorkoutPicker.removeFromSuperview()
            selfWorkoutPicker = nil
            pickerBackView.removeFromSuperview()
            print("selfWorkoutPickerをお掃除")
        }
        
        pickerBackView.frame = self.view.bounds
        pickerBackView.backgroundColor = UIColor.black
        pickerBackView.alpha = 0.5
        self.view.addSubview(pickerBackView)
        
        selfWorkoutPicker = UIPickerView()
        selfWorkoutPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        selfWorkoutPicker.backgroundColor = UIColor.white
        selfWorkoutPicker.layer.cornerRadius = 5.0
        selfWorkoutPicker.layer.shadowOpacity = 0.5
        selfWorkoutPicker.delegate = self
        selfWorkoutPicker.dataSource = self
        selfWorkoutPicker.tag = sender.tag
        selfWorkoutPicker.selectRow(selfWorkoutSelected, inComponent: 0, animated: true)
        self.view.addSubview(selfWorkoutPicker)
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var value:Int = 0
        if(pickerView.tag == 1){
            value = categoryList.count
        }else{
            value = workoutList.count
        }
        return value
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        var str:String = ""
        if(pickerView.tag == 1){
            let categoryT: CategoryT = categoryList.object(at: row) as! CategoryT
            str = categoryT.categoryName
        }else{
            let workoutT: WorkOutT = workoutList.object(at: row) as! WorkOutT
            str = workoutT.workOUtName
        }

        return str
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            categorySelected = row
            let categoryT: CategoryT = categoryList.object(at: row) as! CategoryT
            categoryBtn.setTitle(categoryT.categoryName, for: UIControlState())
            workoutSet(categoryT.categoryID)
            let wkWorkoutT: WorkOutT = workoutList.object(at: 0) as! WorkOutT
            selfWorkoutBtn.setTitle("\(wkWorkoutT.workOUtName)", for: UIControlState())
            selfWorkoutSelected = 0
            self.displayWorkout(wkWorkoutT, x: 50, y: 250, w: 300, h: 100)
        }else if(pickerView.tag == 2){
            selfWorkoutSelected = row
            let workoutT: WorkOutT = workoutList.object(at: row) as! WorkOutT
            selfWorkoutBtn.setTitle(workoutT.workOUtName, for: UIControlState())
            self.displayWorkout(workoutT, x: 50, y: 250, w: 300, h: 100)
        }
    }
    
    func displayWorkout(_ workoutT:WorkOutT, x:CGFloat, y:CGFloat, w:CGFloat, h:CGFloat){
        
        //vw.backgroundColor = UIColor(red:0.00 , green:0.00, blue:0.55,alpha:1.0)
        /*
        if vw != nil {
            vw.removeFromSuperview()
            vw = nil
        }
        vw = UIView(frame:CGRect(x: x, y: y, width: w, height: h));
        vw.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0);
        self.view.addSubview(vw);*/
        
        //let y1: CGFloat = 10
        //let workOUtNameLabel: UILabel = UILabel(frame: CGRect(x: 30,y: y1,width: w/2,height: h/5))
        //workOUtNameLabel.text = workoutT.workOUtName
        //workOUtNameLabel.textColor = UIColor.black
        
        workOUtValueTextField.text = ""
        workOUtValueTextField.delegate = self
        workOUtValueTextField.tag = 1
        workOUtValueTextField.borderStyle = UITextBorderStyle.line
        workOUtValueTextField.keyboardType = .decimalPad
        //vw.addSubview(workOUtValueTextField)
        
        workOUtValueLabel.text = workoutT.workOutValueName
        //workOUtValueLabel.textColor = UIColor.black
        //vw.addSubview(workOUtValueLabel)

        //workOUtCalLabel = UILabel(frame: CGRect(x: w-(w/3),y: y1+(h/5)+y2+(h/7),width: w/3,height: h/7))
        workOUtCalLabel.text = String(0) + "kcal"
        
        
        //workOUtCalLabel.textColor = UIColor.black
        //vw.addSubview(workOUtCalLabel)
        
        addBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        addBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        addBtn.layer.cornerRadius = 3
        
        /*
        addBtn = UIButton(frame: CGRect(x: w-(30*1.3), y: y1, width: 30, height: 30))
        addBtn.backgroundColor = UIColor.lightGray
        addBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        addBtn.setTitle("追加", for: UIControlState())
        addBtn.tag = 1
        addBtn.addTarget(self, action:#selector(SelfMenuViewController.addWorkout(_:)), for: UIControlEvents.touchUpInside)
        vw.addSubview(addBtn)
         */
    }

    @IBAction func addWorkout(_ sender: UIButton){
        
        if workOUtValueTextField.text?.characters.count == 0 {
            self.alertView("", "ワークアウト実行時間を入力してください。")
            return
        }else{
            let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
            
            if predicate.evaluate(with: workOUtValueTextField.text) == false {
                self.alertView("", "ワークアウト実行時間に数字以外の文字が入力されています。")
                return
            }else{
                if Int(workOUtValueTextField.text!)! < 1 {
                    self.alertView("", "ワークアウト実行時間が不正です。")
                    return
                }
            }

        }
        
        let workoutT: WorkOutT = workoutList.object(at: selfWorkoutSelected) as! WorkOutT
        let workoutT2: WorkOutT = WorkOutT()
        workoutT2.workOUtID = workoutT.workOUtID
        workoutT2.workOUtName = workoutT.workOUtName
        workoutT2.workOUtValue = Int(workOUtValueTextField.text!)!
        workoutT2.workOutValueName = workoutT.workOutValueName
        workoutT2.workOutSetsumei = workoutT.workOutSetsumei
        workoutT2.categoryID = workoutT.categoryID
        workoutT2.workOUtCal = Util.getKcal(1.0, mets: workoutT.workOUtCal, weight: appDelegate.menuT.kaishiWeight)
        kekkaWorkoutList.add(workoutT2)
        
        zanCal = zanCal - Double(workOUtValueTextField.text!)! * workoutT2.workOUtCal
        calZanLabel.text = "あと" + String(format: "%.1f",zanCal) + "kcal"

        self.view.endEditing(true)
        
        workoutTableView.reloadData()
    }

    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kekkaWorkoutList.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        // Cellに値を設定する.
        let workoutT: WorkOutT = kekkaWorkoutList.object(at: indexPath.row) as! WorkOutT
        
        let width :CGFloat = self.view.frame.width
        
        let imgView = UIImageView(frame: CGRect(x: width*0.026, y: 10, width: width*0.08, height: 30))
        print("workoutT.categoryID \(workoutT.workOUtID.substring(to: workoutT.workOUtID.index(workoutT.workOUtID.startIndex, offsetBy: 2)))")
        let img = UIImage(named: workoutT.workOUtID.substring(to: workoutT.workOUtID.index(workoutT.workOUtID.startIndex, offsetBy: 2)))
        imgView.image = img
        cell.contentView.addSubview(imgView)
        
        let workOUtNameLabel: UILabel = UILabel(frame: CGRect(x: width*0.11,y: 10,width: width*0.343,height: 30))
        workOUtNameLabel.text = workoutT.workOUtName
        workOUtNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        workOUtNameLabel.textAlignment = .left
        workOUtNameLabel.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(workOUtNameLabel)
        
        let workOUtValueLabel: UILabel = UILabel(frame: CGRect(x: width*0.5,y: 10,width: width*0.133,height: 30))
        workOUtValueLabel.text = String(workoutT.workOUtValue) + workoutT.workOutValueName
        workOUtValueLabel.font = UIFont.systemFont(ofSize: 13)
        workOUtValueLabel.textAlignment = .left
        cell.contentView.addSubview(workOUtValueLabel)
        
        let workOUtCalLabel: UILabel = UILabel(frame: CGRect(x: width*0.6,y: 10,width: width*0.195,height: 30))
        workOUtCalLabel.text = String(format: "%.1f",Double(workoutT.workOUtValue)*workoutT.workOUtCal) + "kcal"
        workOUtCalLabel.textAlignment = .center
        workOUtCalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(13))
        workOUtCalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        workOUtCalLabel.layer.cornerRadius = 8
        workOUtCalLabel.clipsToBounds = true
        workOUtCalLabel.textColor = UIColor.white
        cell.contentView.addSubview(workOUtCalLabel)

        
        let btn: UIButton = UIButton()
        
        btn.frame = CGRect(x: width*0.83,y: 10,width: width*0.133,height: 30)
        btn.layer.masksToBounds = true
        btn.setTitle("削除", for: UIControlState())
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.tag = indexPath.row + 1
        btn.addTarget(self, action:#selector(self.workoutDel(_:)), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 3
        cell.contentView.addSubview(btn)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func viewTapped(_ sender: UIView){
        
        if(categoryPicker != nil){
            categoryPicker.removeFromSuperview()
            categoryPicker = nil
            pickerBackView.removeFromSuperview()
            print("categoryPickerをお掃除")
        }
        
        if(selfWorkoutPicker != nil){
            selfWorkoutPicker.removeFromSuperview()
            selfWorkoutPicker = nil
            pickerBackView.removeFromSuperview()
            print("selfWorkoutPickerをお掃除")
        }
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func fixMenu(_ sender: UIButton){
 
        MyAlertController.show(presentintViewController: self, title: "", message: "メニューを作成しますか？",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
            switch action {
            case .ok :  self.appDelegate.dbService.insertMenuT(self.appDelegate.menuT)
                        for i in 0..<self.kekkaWorkoutList.count {
                            let workoutT: WorkOutT = self.kekkaWorkoutList.object(at: i) as! WorkOutT
                            workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
                            workoutT.workOutNo = i + 1
                            self.appDelegate.dbService.insertWorkoutT(workoutT)
                        }
                        
                        Util.torokuDayWorkOutT(self.appDelegate)
                        
                        self.appDelegate.viewC.MenuListReload()
                        self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
                        break
            case .cancel :break
                
            }
        }
    }
    
    func workoutDel(_ sender: UIButton){
        let workoutT: WorkOutT = self.kekkaWorkoutList.object(at: sender.tag-1) as! WorkOutT
        zanCal = zanCal + (Double(workoutT.workOUtValue)*workoutT.workOUtCal)
        calZanLabel.text = "あと" + String(format: "%.1f",zanCal) + "kcal"
        kekkaWorkoutList.removeObject(at: sender.tag-1)
   
        workoutTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        let txtField = sender
        
        if let text = txtField.text {
            if text.characters.count > 2 {
                    txtField.text = text.substring(to: text.index(text.startIndex, offsetBy: 2))
                    return
            }

            if(Int(text) != nil){
                let workoutT: WorkOutT = workoutList.object(at: selfWorkoutSelected) as! WorkOutT
                //let cal = Int(Double(text)!*workoutT.workOUtCal)
                print("workoutT.workOUtCal = \(workoutT.workOUtCal)")
                workOUtCalLabel.text = String(format: "%.1f",Util.getKcal(Double(text)!, mets: workoutT.workOUtCal, weight: appDelegate.menuT.kaishiWeight)) + "kcal"
            }else{
                workOUtCalLabel.text = String(0) + "kcal"
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
}

