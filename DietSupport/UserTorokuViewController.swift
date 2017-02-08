//
//  UserTorokuViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit



class UserTorokuViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var infoView:UIView = UIView()
    fileprivate var nameTextField: UITextField = UITextField()
    fileprivate var ageTextField: UITextField = UITextField()
    fileprivate var weightTextField: UITextField = UITextField()
    fileprivate var metabolismTextField: UITextField = UITextField()
    fileprivate var userTorokuTableView: UITableView!
    fileprivate var rightButton: UIBarButtonItem!
    var sexBtn: UIButton!
    var sexPicker: UIPickerView! = nil
    var sexArr: NSArray = ["男性","女性"]
    var sexSyubetsu:Int = 0
    let tableHeight: CGFloat = 50.0
    var gUserT: UserT = UserT()
    var pickerBackView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "プロフィール編集";
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))
        
        self.automaticallyAdjustsScrollViewInsets = false
        //rightButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(UserTorokuViewController.onClickRightButton(_:)))
        //rightButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(UserTorokuViewController.onClickRightButton(_:)))
        //navigationItem.rightBarButtonItem = rightButton
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        gUserT = appDelegate.dbService.selectUserT()
        if gUserT.name.characters.count <= 0 {
            navigationItem.hidesBackButton = true
            self.infoMsgViewSet()
        }
        
        let profileLabel: UILabel = UILabel(frame: CGRect(x: 10,y: (self.view.frame.height/2)-((tableHeight*5)/2)-25,width: 100,height: 25))
        profileLabel.text = "プロフィール情報"
        profileLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        profileLabel.textColor = UIColor.gray
        self.view.addSubview(profileLabel)
        
        userTorokuTableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height*0.12, width: self.view.frame.width, height: (tableHeight*5)+2))
        //userTorokuTableView = UITableView(frame: CGRect(x: 0, y: (self.view.frame.height/2)-((tableHeight*5)/2), width: self.view.frame.width, height: (tableHeight*5)+2))
        //userTorokuTableView.backgroundColor = UIColor.blue
        userTorokuTableView.isScrollEnabled = false
        
        let version = NSString(string: UIDevice.current.systemVersion).doubleValue
        
        UITableView.appearance().separatorInset = UIEdgeInsets.zero
        UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
        if version >= 8 {
            UITableView.appearance().layoutMargins = UIEdgeInsets.zero
            UITableViewCell.appearance().layoutMargins = UIEdgeInsets.zero
        }
        
        // Cell名の登録をおこなう.
        userTorokuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        userTorokuTableView.dataSource = self
        
        // Delegateを設定する.
        userTorokuTableView.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: userTorokuTableView.frame.width, height: 0.3)
        userTorokuTableView.tableHeaderView = UIView(frame: frame)
        userTorokuTableView.tableFooterView = UIView(frame: frame)
        userTorokuTableView.tableHeaderView!.backgroundColor = UIColor.lightGray  //お好きな色に
        userTorokuTableView.tableFooterView!.backgroundColor = UIColor.lightGray
        
        // Viewに追加する.
        self.view.addSubview(userTorokuTableView)

        
        let ChangeBtn = UIButton(frame: CGRect(x: self.view.frame.width*0.1, y: userTorokuTableView.frame.height+userTorokuTableView.frame.origin.y+30, width: self.view.frame.width*0.8, height: self.view.frame.width*0.1))
        ChangeBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        ChangeBtn.addTarget(self, action:#selector(UserTorokuViewController.onClickRightButton(_:)), for: UIControlEvents.touchUpInside)
        
        if gUserT.name.characters.count <= 0 {
            ChangeBtn.setTitle("登録する", for: UIControlState())
        }else{
            ChangeBtn.setTitle("変更する", for: UIControlState())
        }
        
        ChangeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        ChangeBtn.layer.cornerRadius = 3
        self.view.addSubview(ChangeBtn)

    }
    
    func infoMsgViewSet(){
        
        MyAlertController.show(presentintViewController: self, title: "", message: "ダイエットログをインストールいただきありがとうございます。\n\nはじめにプロフィールを登録しましょう！", buttonTitle: "OK")
          { action in
            switch action {
            case .ok :break
            case .cancel :break
            }
        }
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let userTorokuViewController = UserTorokuViewController()
            self.navigationController?.pushViewController(userTorokuViewController, animated: true)
        }
    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        switch indexPath.row {
        case 0 :
            let label = UILabel(frame: CGRect(x: 10,y: (tableHeight/2)-(20/2),width: 100,height: 20))
            label.text = "ニックネーム";
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = NSTextAlignment.left
            label.textColor = UIColor.black
            cell.contentView.addSubview(label)
            
            nameTextField = UITextField(frame: CGRect(x: 130,y: (tableHeight/2)-(30/2),width: 200,height: 30))
            nameTextField.tag = 1
            nameTextField.delegate = self
            nameTextField.font = UIFont.systemFont(ofSize: 15)
            nameTextField.borderStyle = UITextBorderStyle.none
            nameTextField.returnKeyType = .done
            nameTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
            nameTextField.textColor =  UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
            nameTextField.placeholder = "ここをタップして入力"
            cell.contentView.addSubview(nameTextField)
            
            if gUserT.name.characters.count > 0 {
                nameTextField.text = gUserT.name
            }
            
            break
        case 1 :
            let label2 = UILabel(frame: CGRect(x: 10,y: (tableHeight/2)-(20/2),width: 100,height: 20))
            label2.text = "性別";
            label2.font = UIFont.systemFont(ofSize: 15)
            label2.textAlignment = NSTextAlignment.left
            label2.textColor = UIColor.black
            cell.contentView.addSubview(label2)
            
            sexBtn = UIButton(frame: CGRect(x: 130, y: (tableHeight/2)-(30/2), width: 150, height: 30))
            sexBtn.backgroundColor = UIColor.white
            sexBtn.setTitleColor( UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0), for: UIControlState())
            sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            sexBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            sexBtn.setTitle("男性", for: UIControlState())
            sexBtn.addTarget(self, action:#selector(UserTorokuViewController.sexSelected(_:)), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(sexBtn)
            
            if gUserT.name.characters.count > 0 {
                if gUserT.sex == 1 {
                    sexBtn.setTitle("男性", for: UIControlState())
                }else if gUserT.sex == 2 {
                    sexBtn.setTitle("女性", for: UIControlState())
                }
            }
            
            break
        case 2 :
            let label3 = UILabel(frame: CGRect(x: 10,y: (tableHeight/2)-(20/2),width: 100,height: 20))
            label3.text = "年齢";
            label3.font = UIFont.systemFont(ofSize: 15)
            label3.textAlignment = NSTextAlignment.left
            label3.textColor = UIColor.black
            cell.contentView.addSubview(label3)
            
            ageTextField = UITextField(frame: CGRect(x: 130,y: (tableHeight/2)-(30/2),width: 200,height: 30))
            ageTextField.tag = 2
            ageTextField.delegate = self
            ageTextField.font = UIFont.systemFont(ofSize: 15)
            ageTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
            ageTextField.textColor =  UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
            ageTextField.borderStyle = UITextBorderStyle.none
            ageTextField.keyboardType = .decimalPad
            ageTextField.placeholder = "ここをタップして入力"
            cell.contentView.addSubview(ageTextField)
            
            if gUserT.name.characters.count > 0 {
                ageTextField.text = String(gUserT.age)
            }
            
            break
        case 3 :
            let label4 = UILabel(frame: CGRect(x: 10,y: (tableHeight/2)-(20/2),width: 100,height: 20))
            label4.text = "体重";
            label4.font = UIFont.systemFont(ofSize: 15)
            label4.textAlignment = NSTextAlignment.left
            label4.textColor = UIColor.black
            cell.contentView.addSubview(label4)
            
            weightTextField = UITextField(frame: CGRect(x: 130,y: (tableHeight/2)-(30/2),width: 200,height: 30))
            weightTextField.tag = 3
            weightTextField.delegate = self
            weightTextField.font = UIFont.systemFont(ofSize: 15)
            weightTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
            weightTextField.textColor =  UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
            weightTextField.borderStyle = UITextBorderStyle.none
            weightTextField.keyboardType = .decimalPad
            weightTextField.placeholder = "ここをタップして入力"
            cell.contentView.addSubview(weightTextField)
            
            if gUserT.name.characters.count > 0 {
              weightTextField.text = String(format: "%.1f",gUserT.weight)
            }
            
            break
        case 4 :
            let label5 = UILabel(frame: CGRect(x: 10,y: (tableHeight/2)-(20/2),width: 200,height: 20))
            label5.text = "基礎代謝";
            label5.font = UIFont.systemFont(ofSize: 15)
            label5.textAlignment = NSTextAlignment.left
            label5.textColor = UIColor.black
            cell.contentView.addSubview(label5)
            
            metabolismTextField = UITextField(frame: CGRect(x: 130,y: (tableHeight/2)-(30/2),width: 200,height: 30))
            metabolismTextField.tag = 4
            metabolismTextField.delegate = self
            metabolismTextField.font = UIFont.systemFont(ofSize: 15)
            metabolismTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
            metabolismTextField.textColor =  UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
            metabolismTextField.borderStyle = UITextBorderStyle.none
            metabolismTextField.keyboardType = .decimalPad
            metabolismTextField.placeholder = "ここをタップして入力"
            cell.contentView.addSubview(metabolismTextField)
            
            if gUserT.name.characters.count > 0 {
                metabolismTextField.text = String(format: "%.0f",gUserT.metabolism)
            }
            
            break
        default :break
        }
        //cell.contentView.addSubview(workOUtNameLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight
    }

    func next(_ sender: UIButton){
        infoView.removeFromSuperview()
    }
    
    func sexSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(sexPicker != nil){
            sexPicker.removeFromSuperview()
            sexPicker = nil
            pickerBackView.removeFromSuperview()
            print("sexPickerをお掃除")
        }
        
        pickerBackView.frame = self.view.bounds
        pickerBackView.backgroundColor = UIColor.black
        pickerBackView.alpha = 0.5
        self.view.addSubview(pickerBackView)
        
        sexPicker = UIPickerView()
        sexPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        sexPicker.backgroundColor = UIColor.white
        sexPicker.layer.cornerRadius = 5.0
        sexPicker.layer.shadowOpacity = 0.5
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexPicker.selectRow(sexSyubetsu, inComponent: 0, animated: true)
        self.view.addSubview(sexPicker)
    }
    
    func onClickRightButton(_ sender: UIButton){
        
        if inputCheck() == false {
            return
        }
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let userT:UserT = UserT()
        userT.name = nameTextField.text!
        if self.sexSyubetsu == 0{
            userT.sex = 1
        } else if self.sexSyubetsu == 1 {
            userT.sex = 2
        }
        userT.age = Int(self.ageTextField.text!)!
        userT.weight = Double(self.weightTextField.text!)!
        userT.metabolism = Double(self.metabolismTextField.text!)!
        
        let seUserT = appDelegate.dbService.selectUserT()
        userT.userID = seUserT.userID
        if seUserT.name.characters.count > 0 {
            let rt = CloudSync.editUser(1, userT: userT)
            if rt.0 == true {
                appDelegate.dbService.updateUserT(rt.1)
                self.navigationController?.popViewController(animated: true)
            }else{
                MyAlertController.show(presentintViewController: self, title: "", message: "プロフィール更新に失敗しました。通信環境をご確認の上、再度お試しください。", buttonTitle: "OK")
                { action in
                    switch action {
                    case .ok :break
                    case .cancel:break
                    }
                }
            }
        } else {
            MyAlertController.show(presentintViewController: self, title: "", message: "この内容で登録してもよろしいですか？\n\nプロフィールはあとでも変更できます。",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
                switch action {
                case .ok :userT.userID = 0
                          let rt = CloudSync.editUser(0, userT: userT)
                          if rt.0 == true {
                            appDelegate.dbService.insertUserT(rt.1)
                            self.navigationController?.popViewController(animated: true)
                          }else{
                            MyAlertController.show(presentintViewController: self, title: "", message: "プロフィール更新に失敗しました。通信環境をご確認の上、再度お試しください。", buttonTitle: "OK")
                            { action in
                                switch action {
                                case .ok :break
                                case .cancel:break
                                }
                            }
                        }
                          break
                case .cancel :break
                }
            }
        }
    }
    
    func inputCheck() -> Bool{
        var rt: Bool = true
        
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        
        if nameTextField.text?.characters.count == 0{
            rt = false
            self.alertView("", "ニックネームを入力してください。")
            return rt
        }
        
        if ageTextField.text?.characters.count == 0{
            rt = false
            self.alertView("", "年齢を入力してください。")
            return rt
        }
        
        if weightTextField.text?.characters.count == 0{
            rt = false
            self.alertView("", "\n体重を入力してください。\n")
            return rt
        }else{
            if Double(weightTextField.text!) == nil{
                rt = false
                self.alertView("", "体重が不正です。")
                return rt
            }else{
                if Double(weightTextField.text!)! < 20 || Double(weightTextField.text!)! > 200 {
                    rt = false
                    self.alertView("", "体重が不正です。\n(体重：20~200)")
                    return rt
                }
            }
        }
        
        if predicate.evaluate(with: ageTextField.text) == false {
            rt = false
            self.alertView("", "年齢に数字以外の文字が入力されています。")
            return rt
        }else{
            if Int(ageTextField.text!)! < 1 {
                rt = false
                self.alertView("", "年齢が不正です。")
                return rt
            }
        }
        
        return rt
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return sexArr[row] as! String
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("値: \(sexArr[row])")
        sexBtn.setTitle(sexArr[row] as? String, for: UIControlState())
        if row == 0{
            sexSyubetsu = 0
        }else{
            sexSyubetsu = 1
        }
    }
    
    func viewTapped(_ sender: UIView){
        
        if(sexPicker != nil){
            sexPicker.removeFromSuperview()
            sexPicker = nil
            pickerBackView.removeFromSuperview()
            print("sexPickerをお掃除")
        }
        
        self.view.endEditing(true)
    }
    
    func textFieldChange(_ sender: UITextField) {
        let txtField = sender
        if let str = txtField.text {
            if txtField.tag == 1 {
                if str.characters.count > 10 {
                    txtField.text = str.substring(to: str.index(str.startIndex, offsetBy: 10))
                    
                }
            }else if txtField.tag == 2 {
                if str.characters.count > 2 {
                    txtField.text = str.substring(to: str.index(str.startIndex, offsetBy: 2))
                    
                }
            }else if txtField.tag == 3 {
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
                /*
                if str.characters.count > 5 {
                    txtField.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
                    
                }*/
            }else if txtField.tag == 4 {
                if str.characters.count > 4 {
                    txtField.text = str.substring(to: str.index(str.startIndex, offsetBy: 4))
                    
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
