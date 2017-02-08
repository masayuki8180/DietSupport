//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuSelectViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate    var json:NSDictionary!
    @IBOutlet weak var menuScrollView:UIScrollView!
    fileprivate    var indicatorView: UIView!
    @IBOutlet weak var calByDaylabel: UILabel!
    @IBOutlet weak var menuRetryBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var fixBtn: UIButton!
    @IBOutlet weak var selfMenuBtn: UIButton!
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        navigationItem.title = "メニュー選択"
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.onClickRightButton(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
        self.view.backgroundColor = UIColor.white

        appDelegate.menuSelectVC = self
        
        let gUserT: UserT = appDelegate.dbService.selectUserT()
        
        var sexStr: String = ""
        if gUserT.sex == 1 {
            sexStr = "男性"
        }else if gUserT.sex == 2 {
            sexStr = "女性"
        }
        let strMsg: String = "　　性別：" + sexStr + "\n" + "　　年齢：" + String(gUserT.age) + "\n" + "　　体重：" + String(gUserT.weight) + "\n" +  "　　新陳代謝：" + String(gUserT.metabolism) + "\n\n上記の情報をもとにおすすめメニューを作成しました。\n\n自分好みのメニューを作成することもできます。"
        
        //let strMsg: String = "上記の情報をもとにおすすめメニューを作成しました。"
        
        MyAlertController.show(presentintViewController: self, title: "", message:strMsg, buttonTitle: "OK")
        { action in
            switch action {
            case .ok :break
            case .cancel :break
            }
        }
        
        menuScrollView.isPagingEnabled = true
        menuScrollView.backgroundColor = UIColor.clear
        menuScrollView.contentSize = CGSize(width: (self.view.frame.width*0.9)*CGFloat(appDelegate.cloudmenuList.count), height: self.view.frame.height*0.35)
        
        menuScrollView.flashScrollIndicators()
        menuScrollView.delegate = self
        self.view.bringSubview(toFront: menuScrollView)
        self.view.bringSubview(toFront: menuRetryBtn)
        self.view.bringSubview(toFront: fixBtn)
        self.view.bringSubview(toFront: selfMenuBtn)
        
        self.showMenu()
        
        menuRetryBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        menuRetryBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        menuRetryBtn.layer.cornerRadius = 3
        
        fixBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        fixBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        fixBtn.layer.cornerRadius = 3
        
        selfMenuBtn.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        selfMenuBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        selfMenuBtn.layer.cornerRadius = 3
    }

    func reviewMenu(_ indicator: UIActivityIndicatorView){
        for subview in menuScrollView.subviews{
            subview.removeFromSuperview()
        }
        
        self.menuScrollView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func showMenu(){
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        for subview in menuScrollView.subviews{
            subview.removeFromSuperview()
        }
        
        for i in 0..<appDelegate.cloudmenuList.count {
            print("i = \(i)")
            y = 60
            let woList: NSMutableArray = appDelegate.cloudmenuList.object(at: i) as! NSMutableArray
            
            let menuNameLabel = UILabel(frame:CGRect(x: x+(self.view.frame.width*0.9)*0.01, y: y-35, width: (self.view.frame.width*0.9)*0.98, height: 35))
            menuNameLabel.text = "おすすめメニュー" + String(i+1)
            menuNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            menuNameLabel.textAlignment = NSTextAlignment.center
            menuNameLabel.textColor = UIColor.white
            menuNameLabel.backgroundColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
            //menuNameLabel.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
            //menuNameLabel.layer.borderWidth = 1
            menuNameLabel.layer.cornerRadius = 2
            menuNameLabel.clipsToBounds = true
            menuScrollView.addSubview(menuNameLabel)
            
            let menubackView: UIView = UIView(frame: CGRect(x: x+(self.view.frame.width*0.9)*0.01, y: y, width: (self.view.frame.width*0.9)*0.98, height: self.view.frame.height*0.27))
            //backView.frame = self.view.bounds
            menubackView.backgroundColor = UIColor.white
            menubackView.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
            menubackView.layer.borderWidth = 1
            menubackView.layer.cornerRadius = 2
            menuScrollView.addSubview(menubackView)
            
            var totalCal: Double = 0
            
            for i2 in 0..<woList.count {
                print("i2 = \(i2)")
                let workoutT: WorkOutT = woList.object(at: i2) as! WorkOutT
                
                let backView: UIView = UIView(frame: CGRect(x: x, y: y, width: self.view.frame.width*0.9, height: self.view.frame.height*0.052))
                backView.backgroundColor = UIColor.clear
                menuScrollView.addSubview(backView)
                
                let imgView = UIImageView(frame: CGRect(x: 15, y: self.view.frame.height*0.015, width: 20, height: self.view.frame.height*0.03))
                let img = UIImage(named: workoutT.workOUtID.substring(to: workoutT.workOUtID.index(workoutT.workOUtID.startIndex, offsetBy: 2)))
                imgView.image = img
                backView.addSubview(imgView)
                
                let workOUtNameLabel = UILabel(frame:CGRect(x: 40, y: self.view.frame.height*0.0075, width: backView.frame.width/2.2, height: self.view.frame.height*0.0374))
                workOUtNameLabel.text = workoutT.workOUtName
                workOUtNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
                workOUtNameLabel.textAlignment = NSTextAlignment.left
                workOUtNameLabel.adjustsFontSizeToFitWidth = true
                workOUtNameLabel.textColor = UIColor.black
                backView.addSubview(workOUtNameLabel)
                
                let workOUtValueLabel = UILabel(frame:CGRect(x: backView.frame.width/2, y: self.view.frame.height*0.0075, width: backView.frame.width/4, height: self.view.frame.height*0.0374))
                workOUtValueLabel.text = String(workoutT.workOUtValue) + workoutT.workOutValueName
                workOUtValueLabel.font = UIFont.systemFont(ofSize: 13)
                workOUtValueLabel.textAlignment = NSTextAlignment.center
                workOUtValueLabel.textColor = UIColor.black
                //workOUtValueLabel.backgroundColor = UIColor(red:0.47 , green:0.53, blue:0.60,alpha:1.0)
                //workOUtValueLabel.layer.cornerRadius = 2
                // workOUtValueLabel.clipsToBounds = true
                //workOUtValueLabel.textColor = UIColor.white
                backView.addSubview(workOUtValueLabel)
                
                let workOUtCalLabel = UILabel(frame:CGRect(x: (backView.frame.width/3)*2+10, y: self.view.frame.height*0.0075, width: backView.frame.width/4, height: self.view.frame.height*0.0374))
                workOUtCalLabel.text = String(format: "%.1f", workoutT.workOUtCal * Double(workoutT.workOUtValue)) + "kcal"
                totalCal = totalCal + workoutT.workOUtCal * Double(workoutT.workOUtValue)
                workOUtCalLabel.textAlignment = NSTextAlignment.center
                workOUtCalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(13))
                workOUtCalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
                //workOUtCalLabel.backgroundColor = UIColor(red:0.39 , green:0.58, blue:0.93,alpha:1.0)
                workOUtCalLabel.layer.cornerRadius = 8
                workOUtCalLabel.clipsToBounds = true
                workOUtCalLabel.textColor = UIColor.white
                backView.addSubview(workOUtCalLabel)
                
                y = y + self.view.frame.height*0.052
            }
            
            let backView: UIView = UIView(frame: CGRect(x: x, y: y, width: self.view.frame.width*0.9, height: self.view.frame.height*0.052))
            backView.backgroundColor = UIColor.clear
            menuScrollView.addSubview(backView)
            
            let totalCalLabel = UILabel(frame:CGRect(x: (backView.frame.width/1.6), y: self.view.frame.height*0.0075, width: backView.frame.width/3, height: self.view.frame.height*0.0374))
            totalCalLabel.text = String(format: "合計　%.1f", totalCal) + "kcal"
            totalCalLabel.textAlignment = NSTextAlignment.right
            totalCalLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(13))
            totalCalLabel.textColor = UIColor.black
            backView.addSubview(totalCalLabel)
            
            x = x + self.view.frame.width*0.9
        }
        
        let daySpan: Int = Int((Util.convertDateFormat(appDelegate.menuT.syuryo).timeIntervalSince(Util.convertDateFormat(appDelegate.menuT.kaishi)))/60/60/24)+1
        
        calByDaylabel.text = String(format: "1日あたり%.1f",(((appDelegate.menuT.kaishiWeight-appDelegate.menuT.mokuHyoweight)*1000)*9)/Double(daySpan)) + "kcal"
    }
    
    @IBAction func menuRetry(_ sender: UIButton){
        MyAlertController.show(presentintViewController: self, title: "", message: "メニューを再検索しますか？",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
            switch action {
            case .ok :
                    self.menuKensaku()
                    break
            case .cancel :break
                
            }
        }
    }
    
    func menuKensaku(){
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = CGPoint(x: self.menuScrollView.bounds.midX, y: self.menuScrollView.bounds.midY)
        
        for subview in self.menuScrollView.subviews{
            subview.removeFromSuperview()
        }
        
        self.menuScrollView.addSubview(indicator)
        indicator.startAnimating()
        
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        globalQueue.async {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let seUserT = appDelegate.dbService.selectUserT()
            let rt = CloudSync.demandMenu(appDelegate.menuT, userT: seUserT)
            
            DispatchQueue.main.async {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                if rt.1 == "" {
                    appDelegate.cloudmenuList.removeAllObjects()
                    appDelegate.cloudmenuList = rt.0
                    self.showMenu()
                }else{
                    self.alertView("", rt.1)
                    return
                }
            }
        }
    }
    
    @IBAction func fixMenu(_ sender: UIButton){
        
        MyAlertController.show(presentintViewController: self, title: "", message: "メニューを作成しますか？",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
            switch action {
            case .ok :  self.workoutDataSave()
                        break
            case .cancel :break
                
            }
        }
    }

    func workoutDataSave(){
    
        self.appDelegate.dbService.insertMenuT(self.appDelegate.menuT)
        
        let woList: NSMutableArray = appDelegate.cloudmenuList.object(at: page) as! NSMutableArray
        let menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        for i in 0..<woList.count {
            let workoutT: WorkOutT = woList.object(at: i) as! WorkOutT
            workoutT.menuNo = menuNo
            workoutT.workOutNo = i + 1
            self.appDelegate.dbService.insertWorkoutT(workoutT)
        }
        /*
        //ここから下は仮
        let workoutT:WorkOutT = WorkOutT()
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 1
        workoutT.workOUtID = "W990"
        //print(json["workout_name"] as! String)
        //workoutT.workOUtName = json["workout_name"] as! String
        workoutT.workOUtName = "ランニング"
        workoutT.workOUtValue = 5
        workoutT.workOutValueName = "Km"
        workoutT.workOUtCal = 300
        workoutT.workOutSetsumei = "必死のランニングです。かなりきついので怪我をしないように。"
        
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 2
        workoutT.workOUtID = "W991"
        workoutT.workOUtName = "筋トレ"
        workoutT.workOUtValue = 10
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 400
        workoutT.workOutSetsumei = "筋トレです。かなりきついので怪我をしないように。"
        
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 3
        workoutT.workOUtID = "W992"
        workoutT.workOUtName = "ヨガ"
        workoutT.workOUtValue = 15
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 250
        workoutT.workOutSetsumei = "ヨガです。ゆっくりリラックスしながらやりましょう。"
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        */
        self.torokuDayWorkOutT()
        
        //ここまで仮
        
        self.appDelegate.viewC.MenuListReload()
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)

    }
    
    func torokuDayWorkOutT(){
        let datefrom: Date = Util.dateFromISOString(self.appDelegate.menuT.kaishi) as Date
        //let datefrom = Util.stringFromDate(self.appDelegate.menuT.kaishi, format: "yyyy年MM月dd日"), forState: .Normal)
        let dateto: Date = Util.dateFromISOString(self.appDelegate.menuT.syuryo) as Date
        
        let span = datefrom.timeIntervalSince(dateto) // 1209600秒差
        var daySpan: Int = abs(Int(span/60/60/24))
        
        daySpan = daySpan + 1
        print("期間 \(daySpan)")
        
        var wkDate :Date
        wkDate = datefrom
        let dayWorkoutT:DayWorkOutT = DayWorkOutT()
        let sa: Double = (appDelegate.menuT.kaishiWeight - appDelegate.menuT.mokuHyoweight)/Double(daySpan)
        //let sa: Double = appDelegate.selectedMenuT.kaishiWeight - appDelegate.selectedMenuT.mokuHyoweight
        var genWeight: Double = appDelegate.menuT.kaishiWeight
        print("appDelegate.menuT.kaishiWeight \(appDelegate.menuT.kaishiWeight) appDelegate.menuT.mokuHyoweight \(appDelegate.menuT.mokuHyoweight) sa \(sa)")
        for i in 0..<daySpan {
            dayWorkoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
            dayWorkoutT.day = Util.ISOStringFromDate(wkDate)
            //print("作成する日付 \(dayWorkoutT.day)")
            dayWorkoutT.workOutNo1 = 0
            genWeight = genWeight - sa
            print("genWeight \(genWeight) sa \(sa)")
            dayWorkoutT.mokuhyoWeight = genWeight
            dayWorkoutT.jissekiValue1 = -1
            dayWorkoutT.jissekiCal1 = -1
            dayWorkoutT.workOutNo2 = 0
            dayWorkoutT.jissekiValue2 = -1
            dayWorkoutT.jissekiCal2 = -1
            dayWorkoutT.workOutNo3 = 0
            dayWorkoutT.jissekiValue3 = -1
            dayWorkoutT.jissekiCal3 = -1
            dayWorkoutT.workOutNo4 = 0
            dayWorkoutT.jissekiValue4 = -1
            dayWorkoutT.jissekiCal4 = -1
            dayWorkoutT.workOutNo5 = 0
            dayWorkoutT.jissekiValue5 = -1
            dayWorkoutT.jissekiCal5 = -1
            
            self.appDelegate.dbService.insertDayWorkoutT(dayWorkoutT)
            
            wkDate = Date(timeInterval: 60*60*24, since: wkDate) as Date
            print("\(i)")
        }
    }
    
    @IBAction func selfMenu(_ sender: UIButton){
        self.performSegue(withIdentifier: "selfMenuViewController", sender:self)
    }
    
    /*
    @IBAction func onCameraBtnClick(_ sender: UIButton){
        //self.performSegue(withIdentifier: "cameraViewController", sender:self)
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }*/
    
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
    
    func alertView(_ title: String, _ msg: String) {
        MyAlertController.show(presentintViewController: self, title: "", message:msg, buttonTitle: "OK")
        { action in
            switch action {
            case .ok :break
            default  :break
            }
        }
    }
    
    func setCameraBtnImg(_ img: UIImage, data: Data){
        cameraBtn.imageView?.contentMode = .scaleAspectFit
        cameraBtn.setImage(img, for: .normal)
        cameraBtn.setImage(img, for: .highlighted)
        appDelegate.menuT.gazo = data
    }
    
    /*
    //　撮影が完了
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("撮影が完了")
        if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //cameraBtn.contentMode = .scaleAspectFit
            //cameraView.image = pickedImage
            
            UIGraphicsBeginImageContext(pickedImage.size);
            pickedImage.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
            pickedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
            
            cameraBtn.setBackgroundImage(pickedImage, for: .normal)
            
            if let data = UIImagePNGRepresentation(pickedImage) {
                appDelegate.menuT.gazo = data
            }
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // 撮影がキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    */
    
    /*
    // 書き込み完了結果の受け取り
    func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        print("保存成功")
        if error != nil {
            print(error.code)
        }
        else{
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        let offset = scrollView.contentOffset
        let pageWidth = menuScrollView.frame.width
        page = Int(round(offset.x / pageWidth))
        print("スクロールストップ \(page)")
    }


}

