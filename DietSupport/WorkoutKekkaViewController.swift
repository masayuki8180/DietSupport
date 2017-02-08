//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class WorkoutKekkaViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var wTableView: UITableView!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var mokuhyoWeightLabel: UILabel!
    @IBOutlet weak var zanKcalLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var compareBtn: UIButton!
    //@IBOutlet weak var adviceBtn: UIButton!
    @IBOutlet weak var adviceTV: UITextView!
    var workoutList = NSMutableArray(array: [])
    //var dayWorkoutT: DayWorkOutT!
    var newDayWorkoutT: DayWorkOutT!
    var tableHeight: CGFloat = 0
    var zanCal: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.workoutKekkaVC = self
        self.view.backgroundColor = UIColor.white
        
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(WorkoutKekkaViewController.viewTapped(_:))))

        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        print("appDelegate.selectedDay = \(appDelegate.selectedDay)")
        navigationItem.title = Util.ISOStringFromDate2(Util.dateFromISOString2(appDelegate.selectedDay));
        
        workoutList = appDelegate.dbService.selectWorkoutT(appDelegate.selectedMenuT.menuNo)
        
        // Cell名の登録をおこなう.
        //wTableView = UITableView(frame: CGRect(x: 0, y: 200 , width: self.view.frame.width, height: 259))
        tableHeight = wTableView.frame.height/4
        wTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        wTableView.delegate = self
        wTableView.dataSource = self
        //self.view.addSubview(wTableView)

        wTableView.layer.borderColor = UIColor.lightGray.cgColor
        wTableView.layer.borderWidth = 1

        adviceTV.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        adviceTV.layer.borderWidth = 1
        adviceTV.font = UIFont.systemFont(ofSize: CGFloat(17))
        
        appDelegate.cameraMode = .dayWorkout
        appDelegate.selectedDayWorkOutT = appDelegate.dbService.selectDayWorkoutTByDay(appDelegate.selectedMenuT.menuNo, inDay: appDelegate.selectedDay)
        newDayWorkoutT = appDelegate.dbService.selectDayWorkoutTByDay(appDelegate.selectedMenuT.menuNo, inDay: appDelegate.selectedDay)
        //print("体重 \(dayWorkoutT.weight) 実績１ \(dayWorkoutT.jissekiValue1) 目標体重 \(dayWorkoutT.mokuhyoWeight) appDelegate.selectedDay \(appDelegate.selectedDay)")

        if appDelegate.selectedDayWorkOutT.gazo.count <= 0 {
            let image = UIImage(named: "person.png")!
            UIGraphicsBeginImageContext(cameraBtn.frame.size)
            image.draw(in: CGRect(x: 0, y: 0, width: cameraBtn.frame.size.width, height:  cameraBtn.frame.size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cameraBtn.setImage(resizeImage, for: .normal)
            compareBtn.isEnabled = false
            compareBtn.alpha = 0.5
            
        }else{
            cameraBtn.imageView?.contentMode = .scaleAspectFit
            cameraBtn.setImage(UIImage(data: appDelegate.selectedDayWorkOutT.gazo), for: .normal)
            cameraBtn.setImage(UIImage(data: appDelegate.selectedDayWorkOutT.gazo), for: .highlighted)
        }
        
   
        
        //cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        weight.keyboardType = .decimalPad
        weight.placeholder = "体重を入力"
        weight.tag = 1
        weight.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        
        mokuhyoWeightLabel.text = String(format: "%.1f",appDelegate.selectedDayWorkOutT.mokuhyoWeight)
        mokuhyoWeightLabel.textAlignment = .center
        mokuhyoWeightLabel.adjustsFontSizeToFitWidth = true
        //mokuhyoWeightLabel.textColor = UIColor(red:0.39 , green:0.58, blue:0.93,alpha:1.0)
        mokuhyoWeightLabel.textColor = UIColor(red:ConstStruct.main2_color_red , green:ConstStruct.main2_color_green, blue:ConstStruct.main2_color_blue,alpha:1.0)
        
        let daySpan: Int = Int((Util.convertDateFormat(appDelegate.selectedMenuT.syuryo).timeIntervalSince(Util.convertDateFormat(appDelegate.selectedMenuT.kaishi)))/60/60/24)+1
        

        zanCal = (((appDelegate.selectedMenuT.kaishiWeight-appDelegate.selectedMenuT.mokuHyoweight)*1000)*9)/Double(daySpan)
        print("daySpan = \(daySpan) appDelegate.selectedMenuT.kaishiWeight = \(appDelegate.selectedMenuT.kaishiWeight) appDelegate.selectedMenuT.mokuHyoweight = \(appDelegate.selectedMenuT.mokuHyoweight) zanCal = \(zanCal)")
        let workoutT: WorkOutT = WorkOutT()
        workoutT.workOUtValue = 0
        var cal: Double = 0.0
        for i in 0 ..< 5 {
            cal = cal + self.getWorkoutCal(i)
            print("cal = \(cal)")
        }
        
        if appDelegate.selectedDayWorkOutT.weight != 0 {
            weight.text = String(format: "%.1f",appDelegate.selectedDayWorkOutT.weight)
            
            let jyokenList = NSMutableArray(array: [])
            jyokenList.add("0")
            jyokenList.add(String(format: "%.1f",appDelegate.selectedDayWorkOutT.mokuhyoWeight))
            jyokenList.add(String(format: "%.1f",appDelegate.selectedDayWorkOutT.weight))
            jyokenList.add(String(zanCal))
            jyokenList.add(String(cal))
            let rt = CloudSync.demandAdvice(jyokenList)
            
            if rt.0 == true {
                adviceTV.text = rt.1
            }else{
                adviceTV.text = rt.1
            }
        }else{
            adviceTV.text = "体重を入力してアドバイスをもらいましょう。"
            
        }
        
        zanKcalLabel.text = "     " + String(format: "%.1f", zanCal-cal) + "kcal"
        
        zanKcalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        zanKcalLabel.adjustsFontSizeToFitWidth = true
        zanKcalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        zanKcalLabel.layer.cornerRadius = 8
        zanKcalLabel.clipsToBounds = true
        zanKcalLabel.textColor = UIColor.white

        weight.layer.borderColor = UIColor.lightGray.cgColor
        weight.layer.borderWidth = 1
        
        saveBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        saveBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        saveBtn.layer.cornerRadius = 3
        
        adviceLabel.textColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        adviceLabel.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        adviceLabel.layer.borderWidth = 1

        for i in 0..<workoutList.count {
            let workoutT: WorkOutT = workoutList.object(at: i) as! WorkOutT
            let value = self.getWorkOUtValue(i,workOut: workoutT)
            
            switch i {
            case 0:
                print("0 value = \(value)")
                newDayWorkoutT.jissekiValue1 = value
                newDayWorkoutT.jissekiCal1 = workoutT.workOUtCal * Double(value)
            case 1:
                print("1 value = \(value)")
                newDayWorkoutT.jissekiValue2 = value
                newDayWorkoutT.jissekiCal2 = workoutT.workOUtCal * Double(value)
            case 2:
                newDayWorkoutT.jissekiValue3 = value
                newDayWorkoutT.jissekiCal3 = workoutT.workOUtCal * Double(value)
            case 3:
                newDayWorkoutT.jissekiValue4 = value
                newDayWorkoutT.jissekiCal4 = workoutT.workOUtCal * Double(value)
            case 4:
                newDayWorkoutT.jissekiValue5 = value
                newDayWorkoutT.jissekiCal5 = workoutT.workOUtCal * Double(value)
            default:
                break
            }
        }
        //adviceBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        //adviceBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        //adviceBtn.layer.cornerRadius = 3
    }
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("workoutList.count　\(workoutList.count)")
        return workoutList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        //let cell = tableView.dequeueReusableCellWithIdentifier("workCell", forIndexPath: indexPath) as UITableViewCell
        print("cell.tag === \(cell.tag)")

        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        // Labelを作成.
        //print("workoutT.workOutValueName \(indexPath.row)")
        let workoutT: WorkOutT = workoutList.object(at: indexPath.row) as! WorkOutT
        
        let imgView = UIImageView(frame: CGRect(x: wTableView.frame.width*0.026, y: (tableHeight/2)-(20/2), width: wTableView.frame.width*0.053, height: 20))
        let img = UIImage(named: workoutT.workOUtID.substring(to: workoutT.workOUtID.index(workoutT.workOUtID.startIndex, offsetBy: 2)))
        imgView.image = img
        cell.contentView.addSubview(imgView)
        
        let workOUtNameLabel: UILabel = UILabel(frame: CGRect(x: wTableView.frame.width*0.093,y: (tableHeight/2)-(20/2),width: wTableView.frame.width/2.3,height: 20))
        workOUtNameLabel.text = workoutT.workOUtName
        workOUtNameLabel.textColor = UIColor.black
        workOUtNameLabel.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(workOUtNameLabel)
        
        let workOUtValueTextField: UITextField = UITextField(frame: CGRect(x: (wTableView.frame.width/1.8),y: (tableHeight/2)-(30/2),width: wTableView.frame.width/12.5,height: 30))
        
        workOUtValueTextField.text = String(self.getWorkOUtValue(indexPath.row,workOut: workoutT))
        workOUtValueTextField.delegate = self
        workOUtValueTextField.tag = (indexPath.row + 1) * 10
        workOUtValueTextField.borderStyle = UITextBorderStyle.none
        workOUtValueTextField.textAlignment = .center
        workOUtValueTextField.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        workOUtValueTextField.layer.borderWidth = 1
        workOUtValueTextField.keyboardType = .numberPad
        workOUtValueTextField.addTarget(self, action:#selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        cell.contentView.addSubview(workOUtValueTextField)
        
        let workOutValueNameLabel: UILabel = UILabel(frame: CGRect(x: wTableView.frame.width/1.56,y: (tableHeight/2)-(15/2),width: wTableView.frame.width/18.75,height: 15))
        workOutValueNameLabel.text = workoutT.workOutValueName
        //print("workoutT.workOutValueName \(workoutT.workOutValueName)")
        workOutValueNameLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        workOutValueNameLabel.textColor = UIColor.black
        cell.contentView.addSubview(workOutValueNameLabel)
        
        let workOutcalLabel: UILabel = UILabel(frame: CGRect(x: wTableView.frame.width/1.44,y: (tableHeight/2)-(20/2),width: wTableView.frame.width/5.35,height: 20))
        workOutcalLabel.text = "未確定"
        workOutcalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(13))
        workOutcalLabel.textAlignment = .center
        workOutcalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        //workOutcalLabel.backgroundColor = UIColor(red:ConstStruct.main2_color_red , green:ConstStruct.main2_color_green, blue:ConstStruct.main2_color_blue,alpha:1.0)
        //workOutcalLabel.backgroundColor = UIColor(red:0.39 , green:0.58, blue:0.93,alpha:1.0)
        workOutcalLabel.layer.cornerRadius = 5
        workOutcalLabel.clipsToBounds = true
        workOutcalLabel.textColor = UIColor.white
        cell.contentView.addSubview(workOutcalLabel)
        
        let btn: UIButton = UIButton()
        btn.frame = CGRect(x: wTableView.frame.width/1.1,y: (tableHeight/2)-(20/2),width: wTableView.frame.width/18.75,height: 20)
        btn.addTarget(self, action: #selector(self.onClickBtn(_:)), for: .touchUpInside)
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.viewTapped(_:))))
        // ボタンに画像セット
        btn.tag = indexPath.row
        btn.setImage(UIImage(named: "check.png"), for: UIControlState.selected)
        btn.setImage(UIImage(named: "nocheck.png"), for: UIControlState.normal)
        
        cell.contentView.addSubview(btn)
        
        let workoutCal = getWorkoutCal(indexPath.row)
        if workoutCal > -1 {
            workOutcalLabel.text = String(format: "%.1f",workoutCal) + "kcal"
            self.onClickBtn(btn)
        }
        /*
        let btn: UIButton = UIButton()
        btn.frame = CGRect(x: 400,y: 45,width: 50,height: 30)
        btn.backgroundColor = UIColor.blue
        btn.layer.masksToBounds = true
        btn.setTitle("保存", for: UIControlState())
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.tag = indexPath.row + 1
        //btn.addTarget(self, action: "dayWorkoutSave:", forControlEvents: .TouchUpInside)
        btn.addTarget(self, action:#selector(self.dayWorkoutSave(_:)), for: UIControlEvents.touchUpInside)
        //cell.contentView.addSubview(btn)
        */
        
        cell.tag = 99
        
        /*
        for subview in cell.subviews {
            print("subview.tag = \(subview.tag) \(indexPath) \(cell.tag)")
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight
    }

    func onClickBtn(_ sender: UIButton){
        let btn: UIButton = sender as UIButton
        btn.isSelected = !btn.isSelected;
        
        if btn.isSelected == true {
            switch btn.tag {
                case 0:
                    newDayWorkoutT.check1 = true
                case 1:
                    newDayWorkoutT.check2 = true
                case 2:
                    newDayWorkoutT.check3 = true
                case 3:
                    newDayWorkoutT.check4 = true
                case 4:
                    newDayWorkoutT.check5 = true
                default:
                    break
            }
        }else{
            switch btn.tag {
            case 0:
                newDayWorkoutT.check1 = false
            case 1:
                newDayWorkoutT.check2 = false
            case 2:
                newDayWorkoutT.check3 = false
            case 3:
                newDayWorkoutT.check4 = false
            case 4:
                newDayWorkoutT.check5 = false
            default:
                break
            }
        }
    }
    
    @IBAction func save(){
        if weight.text?.characters.count != 0 {
            
            if Double(weight.text!) == nil{
                self.alertView("", "目標体重が不正です。")
                return
            }
            
            newDayWorkoutT.weight = Double(weight.text!)!
        }
        
        newDayWorkoutT.menuNo = appDelegate.selectedMenuT.menuNo
        newDayWorkoutT.day = appDelegate.selectedDay
        
      
        if newDayWorkoutT.check1 == false {
            newDayWorkoutT.jissekiCal1 = -1
            newDayWorkoutT.jissekiValue1 = -1
        }
        if newDayWorkoutT.check2 == false {
            newDayWorkoutT.jissekiCal2 = -1
            newDayWorkoutT.jissekiValue2 = -1
        }
        if newDayWorkoutT.check3 == false {
            newDayWorkoutT.jissekiCal3 = -1
            newDayWorkoutT.jissekiValue3 = -1
        }
        if newDayWorkoutT.check4 == false {
            newDayWorkoutT.jissekiCal4 = -1
            newDayWorkoutT.jissekiValue4 = -1
        }
        if newDayWorkoutT.check5 == false {
            newDayWorkoutT.jissekiCal5 = -1
            newDayWorkoutT.jissekiValue5 = -1
        }
        
        if appDelegate.workoutKekkaSenimoto == 1 {
            appDelegate.dbService.updateDayWorkoutT(newDayWorkoutT)
            appDelegate.calviewController.reload()
            navigationController?.popViewController(animated: true)
        }else{
            appDelegate.dbService.updateDayWorkoutT(newDayWorkoutT)
            navigationController?.popViewController(animated: true)
        }

    }
    
    func getWorkOUtValue(_ index: Int,workOut: WorkOutT) -> Int{
    
        var rt: Int = 0
        
        switch index {
            case 0:
                if appDelegate.selectedDayWorkOutT.jissekiValue1 > -1 {
                    rt = appDelegate.selectedDayWorkOutT.jissekiValue1
                }else{
                    rt = workOut.workOUtValue
                }
            case 1:
                if appDelegate.selectedDayWorkOutT.jissekiValue2 > -1 {
                    rt = appDelegate.selectedDayWorkOutT.jissekiValue2
                }else{
                    rt = workOut.workOUtValue
                }
            case 2:
                if appDelegate.selectedDayWorkOutT.jissekiValue3 > -1 {
                    rt = appDelegate.selectedDayWorkOutT.jissekiValue3
                }else{
                    rt = workOut.workOUtValue
                }
            case 3:
                if appDelegate.selectedDayWorkOutT.jissekiValue4 > -1 {
                    rt = appDelegate.selectedDayWorkOutT.jissekiValue4
                }else{
                    rt = workOut.workOUtValue
                }
            case 4:
                if appDelegate.selectedDayWorkOutT.jissekiValue5 > -1 {
                    rt = appDelegate.selectedDayWorkOutT.jissekiValue5
                }else{
                    rt = workOut.workOUtValue
                }
            default:
                break
        }
        return rt
    
    }
    
    func getWorkoutCal(_ index: Int) -> Double{
        
        var rt: Double = -1
        
        switch index {
        case 0:
            if appDelegate.selectedDayWorkOutT.jissekiCal1 > -1{
                rt = appDelegate.selectedDayWorkOutT.jissekiCal1
            }
        case 1:
            if appDelegate.selectedDayWorkOutT.jissekiCal2 > -1{
                rt = appDelegate.selectedDayWorkOutT.jissekiCal2
            }
        case 2:
            if appDelegate.selectedDayWorkOutT.jissekiCal3 > -1{
                rt = appDelegate.selectedDayWorkOutT.jissekiCal3
            }
        case 3:
            if appDelegate.selectedDayWorkOutT.jissekiCal4 > -1{
                rt = appDelegate.selectedDayWorkOutT.jissekiCal4
            }
        case 4:
            if appDelegate.selectedDayWorkOutT.jissekiCal5 > -1{
                rt = appDelegate.selectedDayWorkOutT.jissekiCal5
            }
        default:
            break
        }
        return rt
    }
    
    func setCameraBtnImg(_ img: UIImage, data: Data){
        cameraBtn.imageView?.contentMode = .scaleAspectFit
        cameraBtn.setImage(img, for: .normal)
        newDayWorkoutT.gazo = data
    }
    /*
    @IBAction func onCameraBtnClick(_ sender: UIButton){
        //self.performSegue(withIdentifier: "cameraViewController", sender:self)
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){



            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            if appDelegate.selectedMenuT.gazo.count > 0 {
                let barHeight: CGFloat? = self.navigationController?.navigationBar.frame.size.height
                let imgView = UIImageView(frame: CGRect(x: 0, y: barHeight!, width: self.view.frame.width, height: self.view.frame.height*0.749))
                imgView.image = UIImage(data: appDelegate.selectedMenuT.gazo)
                imgView.alpha = 0.3
                imgView.transform = imgView.transform.scaledBy(x: -1.0, y: 1.0)
                cameraPicker.cameraOverlayView = imgView
            }
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }*/
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("撮影が完了")
        if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //cameraBtn.contentMode = .scaleAspectFit
            //cameraView.image = pickedImage
            
            UIGraphicsBeginImageContext(pickedImage.size);
            pickedImage.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
            pickedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
            

            
            if let data = UIImagePNGRepresentation(pickedImage) {
                newDayWorkoutT.gazo = data
                cameraBtn.imageView?.contentMode = .scaleAspectFit
                cameraBtn.setImage(pickedImage, for: .normal)
            }
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func viewTapped(_ sender: UIView){
        self.view.endEditing(true)
    }

    func textFieldChange(_ sender: UITextField) {
        let txtField = sender
        if let text = txtField.text {
            
            if txtField.tag == 1 {
                let arr = text.components(separatedBy:".")
                if arr.count > 2 {
                    if text.characters.count > 5 {
                        txtField.text = text.substring(to: text.index(text.startIndex, offsetBy: 5))
                        
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
            }else{
                
                if text.characters.count > 2 {
                    txtField.text = text.substring(to: text.index(text.startIndex, offsetBy: 2))
                    return
                }
                
                print("txtField = \(text)")
                var value: Int = 0
                let workoutT: WorkOutT = workoutList.object(at: (txtField.tag/10)-1) as! WorkOutT
                if(Int(text) != nil){
                    value = Int(txtField.text!)!
                }else{
                    value = 0
                }
                
                switch txtField.tag {
                case 10:
                    newDayWorkoutT.jissekiValue1 = value
                    newDayWorkoutT.jissekiCal1 = workoutT.workOUtCal * Double(value)
                    appDelegate.selectedDayWorkOutT.jissekiValue1 = value
                case 20:
                    newDayWorkoutT.jissekiValue2 = value
                    newDayWorkoutT.jissekiCal2 = workoutT.workOUtCal * Double(value)
                    appDelegate.selectedDayWorkOutT.jissekiValue2 = value
                case 30:
                    newDayWorkoutT.jissekiValue3 = value
                    newDayWorkoutT.jissekiCal3 = workoutT.workOUtCal * Double(value)
                    appDelegate.selectedDayWorkOutT.jissekiValue3 = value
                case 40:
                    newDayWorkoutT.jissekiValue4 = value
                    newDayWorkoutT.jissekiCal4 = workoutT.workOUtCal * Double(value)
                    appDelegate.selectedDayWorkOutT.jissekiValue4 = value
                case 50:
                    newDayWorkoutT.jissekiValue5 = value
                    newDayWorkoutT.jissekiCal5 = workoutT.workOUtCal * Double(value)
                    appDelegate.selectedDayWorkOutT.jissekiValue5 = value
                default:
                    break
                }
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

