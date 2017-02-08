//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var menuTableView: UITableView!
    fileprivate var leftButton: UIBarButtonItem!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.viewC = self
        
        navigationItem.title = "すべてのメニュー";
        
        tableHeight = self.view.frame.height*0.2
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        leftButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(ViewController.onClickLeftButton(_:)))
        navigationItem.leftBarButtonItem = leftButton
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //var userT:UserT = UserT()
        let userT = appDelegate.dbService.selectUserT()
        let ud = UserDefaults.standard
        if(userT.name.characters.count > 0){
            let udId = ud.object(forKey: "id") as? String
            if udId == "0" {
                ud.set("toroku", forKey: "1")
                ud.synchronize()
                
                print("ユーザー名"+userT.name)
                let alert: UIAlertController = UIAlertController(title: "登録完了", message: "登録が完了しました。", preferredStyle:  UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
                
            }else{
                
                // Status Barの高さを取得する.
                var barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
                let barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
                
                barHeight = barHeight! + barHeight2!
                
                // Viewの高さと幅を取得する.
                let displayWidth: CGFloat = self.view.frame.width
                let displayHeight: CGFloat = self.view.frame.height
                
                let ud = UserDefaults.standard
                
                if(menuTableView == nil){
                    print("menuTableViewを生成")
                    appDelegate.menuList = appDelegate.dbService.selectMenuT()
                    
                    // TableViewの生成する(status barの高さ分ずらして表示).
                    menuTableView = UITableView(frame: CGRect(x: 0, y: barHeight!, width: displayWidth, height: displayHeight - barHeight!))
                    //menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight!))
                    
                    // Cell名の登録をおこなう.
                    menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                    
                    // DataSourceの設定をする.
                    menuTableView.dataSource = self
                    
                    // Delegateを設定する.
                    menuTableView.delegate = self
                    
                    // Viewに追加する.
                    self.view.addSubview(menuTableView)
                    
                    if appDelegate.menuList.count == 0 {
                        
                        let infoLabel: UILabel = UILabel(frame: CGRect(x: menuTableView.frame.width*0.1,y: (menuTableView.frame.height/2)-((menuTableView.frame.height*0.204)/2),width: menuTableView.frame.width*0.8,height: menuTableView.frame.height*0.204))
                        infoLabel.text = "メニューを作成しましょう。\n\n画面右上の追加ボタンを\nタップしてください。"
                        infoLabel.font = UIFont.boldSystemFont(ofSize: 17)
                        infoLabel.textAlignment = NSTextAlignment.center
                        infoLabel.textColor = UIColor.lightGray
                        infoLabel.numberOfLines = 4
                        infoLabel.tag = 1
                        menuTableView.addSubview(infoLabel)
                        
                        menuTableView.separatorColor = UIColor.clear
                        
                        let udId = ud.object(forKey: ConstStruct.ballon_1) as? String
                        if udId != "999" {
                            let tipsBalloon = BalloonView(frame: CGRect(x:self.view.frame.width*0.37,y: 0,width: self.view.frame.width*0.66,height: self.view.frame.height*0.149))
                            tipsBalloon.backgroundColor = UIColor.clear
                            tipsBalloon.setTrianglePosition(1, position: self.view.frame.width*0.5)
                            tipsBalloon.setText("タップしてメニューを作成しましょう。")
                            tipsBalloon.setEvent()
                            tipsBalloon.tag = 1
                            tipsBalloon.alpha = 0.0
                            menuTableView.addSubview(tipsBalloon)
                            
                            let hintBalloon = BalloonView(frame: CGRect(x:self.view.frame.width*0.05,y: view.frame.height*0.52,width: self.view.frame.width*0.9,height: self.view.frame.height*0.31))
                            hintBalloon.backgroundColor = UIColor.clear
                            hintBalloon.setTrianglePosition(0, position: 0)
                            hintBalloon.tag = 1
                            hintBalloon.setEvent()
                            hintBalloon.alpha = 0.0
                            //hintBalloon.setText(inText: "メニューはダイエット期間、開始体重、目標体重、日々のワークアウトからなる目標を達成するための道しるべのようなものです。")
                            hintBalloon.setText("メニューはダイエット期間、開始体重、目標体重、ワークアウトからなる目標を達成するための道しるべのようなものです。\n\n日々の体重とワークアウトを記録することにより身体の状態を把握しましょう。")
                            menuTableView.addSubview(hintBalloon)
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                tipsBalloon.alpha = 1.0
                                hintBalloon.alpha = 1.0
                            }, completion: { _ in})
                            
                        }
                    }else{
                        ud.set("999", forKey: ConstStruct.ballon_1)
                        ud.synchronize()
                        
                        let udId = ud.object(forKey: ConstStruct.ballon_2) as? String
                        if udId != "999" {
                            let tipsBalloon = BalloonView(frame: CGRect(x:(self.view.frame.width-(self.view.frame.width*0.66))/2,y: tableHeight,width: self.view.frame.width*0.66,height: self.view.frame.height*0.18))
                            tipsBalloon.backgroundColor = UIColor.clear
                            tipsBalloon.setTrianglePosition(1, position: self.view.frame.width*0.33)
                            tipsBalloon.setText("メニューが作成されました。メニューをタップしてメニューの詳細を見てみましょう。")
                            tipsBalloon.tag = 1
                            tipsBalloon.alpha = 0.0
                            tipsBalloon.setEvent()
                            menuTableView.addSubview(tipsBalloon)
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                tipsBalloon.alpha = 1.0
                            }, completion: { _ in})
                        }
                        
                        let udId2 = ud.object(forKey: ConstStruct.ballon_3) as? String
                        if udId2 != "999" {
                            let tipsBalloon = BalloonView(frame: CGRect(x:(self.view.frame.width-(self.view.frame.width*0.66))/2,y: self.view.frame.height*0.03,width: self.view.frame.width*0.66,height: self.view.frame.height*0.18))
                            tipsBalloon.backgroundColor = UIColor.clear
                            tipsBalloon.setTrianglePosition(2, position: self.view.frame.height*0.07)
                            tipsBalloon.setText("体重計をタップすると今日の結果入力画面に直接移動できます。")
                            tipsBalloon.tag = 1
                            tipsBalloon.alpha = 0.0
                            tipsBalloon.setEvent()
                            menuTableView.addSubview(tipsBalloon)
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                tipsBalloon.alpha = 1.0
                            }, completion: { _ in})
                        }
                    }
                    
                    let udId = ud.object(forKey: ConstStruct.info_1) as? String
                    if udId != "999" {
                        MyAlertController.show(presentintViewController: self, title: "", message: "ダイエットログは運動によるダイエットをサポートしてくれます。\n\n使い方は簡単！ダイエットメニューを作成し、日々の体重とワークアウトの結果を記録するだけ！\n\nあとはダイエットログが結果を分析し、アドバイスしてくれたり、グラフで経過を教えてくれます。\n\nダイエットログを活用して楽しいダイエットライフを送りましょう！", buttonTitle: "OK")
                        { action in
                            switch action {
                            case .ok :break
                            case .cancel:break
                            }
                        }
                        ud.set("999", forKey: ConstStruct.info_1)
                        ud.synchronize()
                    }
                    /*
                    if appDelegate.menuList.count == 0 {
                        MyAlertController.show(presentintViewController: self, title: "", message: "メニューを作成しましょう！\n\n画面右上の追加ボタンをタップしてください。", buttonTitle: "OK")
                        { action in
                            switch action {
                            case .ok :break
                            case .cancel:break
                            }
                        }
                    }*/
                }else{
                    print("menuTableViewがある")
                     appDelegate.menuList = appDelegate.dbService.selectMenuT()
                    print("menuTableViewがある2")
                    for subview in menuTableView.subviews{
                        if subview.tag == 1 {
                            subview.removeFromSuperview()
                            menuTableView.separatorColor = UIColor.lightGray
                        }
                    }
                    
                    menuTableView.reloadData()
                    print("menuTableViewがある3")
                    if appDelegate.menuList.count == 0 {
                        
                        let infoLabel: UILabel = UILabel(frame: CGRect(x: menuTableView.frame.width*0.1,y: (menuTableView.frame.height/2)-((menuTableView.frame.height*0.204)/2),width: menuTableView.frame.width*0.8,height: menuTableView.frame.height*0.204))
                        infoLabel.text = "メニューを作成しましょう。\n\n画面右上の追加ボタンを\nタップしてください。"
                        infoLabel.font = UIFont.boldSystemFont(ofSize: 17)
                        infoLabel.textAlignment = NSTextAlignment.center
                        infoLabel.textColor = UIColor.lightGray
                        infoLabel.numberOfLines = 4
                        infoLabel.tag = 1
                        menuTableView.addSubview(infoLabel)
                        
                        menuTableView.separatorColor = UIColor.clear
                    }else{
                        let udId = ud.object(forKey: ConstStruct.ballon_2) as? String
                        if udId != "999" {
                            let tipsBalloon = BalloonView(frame: CGRect(x:(self.view.frame.width-(self.view.frame.width*0.66))/2,y: tableHeight,width: self.view.frame.width*0.66,height: self.view.frame.height*0.18))
                            tipsBalloon.backgroundColor = UIColor.clear
                            tipsBalloon.setTrianglePosition(1, position: self.view.frame.width*0.33)
                            tipsBalloon.setText("メニューが作成されました。メニューをタップしてメニューの詳細を見てみましょう。")
                            tipsBalloon.tag = 1
                            tipsBalloon.alpha = 0.0
                            tipsBalloon.setEvent()
                            menuTableView.addSubview(tipsBalloon)
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                tipsBalloon.alpha = 1.0
                            }, completion: { _ in})
                        }
                        
                        let udId2 = ud.object(forKey: ConstStruct.ballon_3) as? String
                        if udId2 != "999" {
                            let tipsBalloon = BalloonView(frame: CGRect(x:(self.view.frame.width-(self.view.frame.width*0.66))/2,y: self.view.frame.height*0.03,width: self.view.frame.width*0.66,height: self.view.frame.height*0.18))
                            tipsBalloon.backgroundColor = UIColor.clear
                            tipsBalloon.setTrianglePosition(2, position: self.view.frame.height*0.07)
                            tipsBalloon.setText("体重計をタップすると今日の結果入力画面に直接移動できます。")
                            tipsBalloon.tag = 1
                            tipsBalloon.alpha = 0.0
                            tipsBalloon.setEvent()
                            menuTableView.addSubview(tipsBalloon)
                            
                            UIView.animate(withDuration: 2.0, animations: {
                                tipsBalloon.alpha = 1.0
                            }, completion: { _ in})
                        }

                    }
                }
            }
        
        }else{
            
            ud.register(defaults: ["toroku": "0"])
            
            super.viewDidDisappear(animated)
            let userTorokuViewController = UserTorokuViewController()

            self.navigationController?.pushViewController(userTorokuViewController, animated: true)
        }
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let ud = UserDefaults.standard
        let udId = ud.object(forKey: ConstStruct.ballon_2) as? String
        if udId != "999" {
            ud.set("999", forKey: ConstStruct.ballon_2)
            ud.synchronize()
        }
        
        appDelegate.selectedMenuT = appDelegate.menuList.object(at: indexPath.row) as! MenuT
        self.performSegue(withIdentifier: "menuSyosaiViewController", sender:self)

    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("appDelegate.menuList.count + \(appDelegate.menuList.count)")
        return appDelegate.menuList.count
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
        
        let menuT: MenuT = appDelegate.menuList.object(at: indexPath.row) as! MenuT
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        
        let imgView = UIImageView(frame: CGRect(x: width*0.013, y: height*0.0037, width: width*0.258, height: height*0.194))
        if menuT.gazo.count <= 0 {
            let img = UIImage(named: "person.png")
            imgView.image = img
        }else{
            imgView.image = UIImage(data: menuT.gazo)
        }
        
        cell.contentView.addSubview(imgView)
        
        let kaishiWeightLabel: UILabel = UILabel(frame: CGRect(x: width*0.292, y: height*0.097,width: width*0.3,height: height*0.029))
        kaishiWeightLabel.text = "開始体重　\(menuT.kaishiWeight)kg"
        kaishiWeightLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        kaishiWeightLabel.adjustsFontSizeToFitWidth = true
        kaishiWeightLabel.textColor = UIColor.gray
        cell.contentView.addSubview(kaishiWeightLabel)

        /*
        let kaishiWeightLabel2: UILabel = UILabel(frame: CGRect(x: width*0.425, y: height*0.022,width: width*0.2,height: height*0.052))
        kaishiWeightLabel2.text = "\(menuT.kaishiWeight)kg"
        kaishiWeightLabel2.font = UIFont.systemFont(ofSize: CGFloat(14))
        kaishiWeightLabel2.adjustsFontSizeToFitWidth = true
        kaishiWeightLabel2.textColor = UIColor.gray
        kaishiWeightLabel2.textAlignment = .left
        cell.contentView.addSubview(kaishiWeightLabel2)
        */
        let mokuhyoWeightLabel: UILabel = UILabel(frame: CGRect(x: width*0.292,y: height*0.127,width: width*0.3,height: height*0.029))
        mokuhyoWeightLabel.text = "目標体重　\(menuT.mokuHyoweight)kg"
        mokuhyoWeightLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        mokuhyoWeightLabel.adjustsFontSizeToFitWidth = true
        mokuhyoWeightLabel.textColor = UIColor.gray
        cell.contentView.addSubview(mokuhyoWeightLabel)
        /*
        let mokuhyoWeightLabel2: UILabel = UILabel(frame: CGRect(x: width*0.425,y: height*0.05,width: width*0.2,height: height*0.052))
        mokuhyoWeightLabel2.text = "\(menuT.mokuHyoweight)kg"
        mokuhyoWeightLabel2.font = UIFont.systemFont(ofSize: CGFloat(14))
        mokuhyoWeightLabel2.adjustsFontSizeToFitWidth = true
        mokuhyoWeightLabel2.textColor = UIColor.gray
        mokuhyoWeightLabel2.textAlignment = .left
        cell.contentView.addSubview(mokuhyoWeightLabel2)
        */
        
        let genzaiWeight = Util.getWeightLastDay(appDelegate, menuNo: menuT.menuNo)
        
        /*
        let genzaiWeightLabel: UILabel = UILabel(frame: CGRect(x: width*0.125,y: height*0.097,width: width*0.35,height: height*0.052))
        genzaiWeightLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        genzaiWeightLabel.textColor = UIColor.gray
        genzaiWeightLabel.baselineAdjustment = .alignCenters;
        genzaiWeightLabel.textAlignment = .center
        genzaiWeightLabel.backgroundColor = UIColor(red:0.95 , green:0.95, blue:0.95,alpha:1.0)
        //genzaiWeightLabel.layer.cornerRadius = 1
       // genzaiWeightLabel.clipsToBounds = true
        genzaiWeightLabel.adjustsFontSizeToFitWidth = true
        //cell.contentView.addSubview(genzaiWeightLabel)
        */
        
        let genzaiWeightLabel2: UILabel = UILabel(frame: CGRect(x: width*0.292,y: height*0.04,width: width*0.098,height: height*0.029))
        genzaiWeightLabel2.font = UIFont.systemFont(ofSize: CGFloat(14))
        genzaiWeightLabel2.textColor = UIColor.gray
        //genzaiWeightLabel2.textAlignment = .center
        genzaiWeightLabel2.adjustsFontSizeToFitWidth = true
        genzaiWeightLabel2.text = "現在"
        cell.contentView.addSubview(genzaiWeightLabel2)
        
        let genzaiWeightLabel3: UILabel = UILabel(frame: CGRect(x: width*0.38,y: height*0.021,width: width*0.32,height: height*0.06))
        genzaiWeightLabel3.font = UIFont.boldSystemFont(ofSize: CGFloat(25))
        genzaiWeightLabel3.textColor = UIColor.gray
        genzaiWeightLabel3.adjustsFontSizeToFitWidth = true
        //genzaiWeightLabel3.backgroundColor = UIColor.yellow
        if genzaiWeight > 0 {
            genzaiWeightLabel3.text = " \(genzaiWeight)kg"
        }else{
            genzaiWeightLabel3.text = "???kg"
        }

        cell.contentView.addSubview(genzaiWeightLabel3)
        

        
        /*
         let genzaiWeightLabel: UILabel = UILabel(frame: CGRect(x: width*0.625,y: height*0.043,width: width*0.35,height: height*0.052))
         genzaiWeightLabel.font = UIFont.systemFont(ofSize: CGFloat(26))
         genzaiWeightLabel.textColor = UIColor.gray
         genzaiWeightLabel.baselineAdjustment = .alignCenters;
         genzaiWeightLabel.textAlignment = .center
         //genzaiWeightLabel.backgroundColor = UIColor(red:0.95 , green:0.95, blue:0.95,alpha:1.0)
         //genzaiWeightLabel.layer.cornerRadius = 3
         //genzaiWeightLabel.clipsToBounds = true
         genzaiWeightLabel.adjustsFontSizeToFitWidth = true
         cell.contentView.addSubview(genzaiWeightLabel)
         genzaiWeightLabel.text = "体重を計測"
         */
        
        let kikanLabel: UILabel = UILabel(frame: CGRect(x: width*0.63,y: height*0.16,width: width*0.35,height: height*0.044))
        kikanLabel.text = "\(Util.ISOStringFromDate2(Util.convertDateFormat(menuT.kaishi))) 〜 \(Util.ISOStringFromDate2(Util.convertDateFormat(menuT.syuryo)))"
        kikanLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        kikanLabel.textColor = UIColor.gray
        kikanLabel.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(kikanLabel)
        
        let todayBtn = UIButton(frame: CGRect(x: width*0.865,y: (height*0.2/2)-(height*0.059/2),width: width*0.1,height: height*0.059))
        todayBtn.backgroundColor = .clear
        let btnImage:UIImage = UIImage(named: "keisoku.png")!
        todayBtn.setBackgroundImage(btnImage, for: UIControlState())
        todayBtn.tag = indexPath.row
        //todayBtn.alpha = 0.5
        todayBtn.addTarget(self, action:#selector(ViewController.onClickTodayBtn(_:)), for: UIControlEvents.touchUpInside)
        cell.contentView.addSubview(todayBtn)
        
        let sa: CGFloat = CGFloat(menuT.kaishiWeight) - CGFloat(menuT.mokuHyoweight)
        let sa2 = CGFloat(menuT.kaishiWeight) - genzaiWeight

        //print("menuT.mokuHyoweight = \(menuT.mokuHyoweight) genzaiWeight = \(genzaiWeight) sa = \(sa) sa2 = \(sa2)")
        
        var tasseido: CGFloat = 0.0
        
        if genzaiWeight != CGFloat(menuT.kaishiWeight) {
            if genzaiWeight == 0 {
                tasseido = 0
            }else{
                if genzaiWeight > CGFloat(menuT.kaishiWeight) {
                        tasseido = 0
                }else{
                    if CGFloat(menuT.mokuHyoweight) > genzaiWeight {
                        tasseido = 1.0
                    }else{
                        tasseido = sa2/sa
                    }
                }
            }
        }
        
        /*
        let shintyokuLabel2: UILabel = UILabel(frame: CGRect(x: width*0.292,y: height*0.166,width: tasseido*(width*0.68),height: height*0.034))
        shintyokuLabel2.text = ""
        shintyokuLabel2.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        shintyokuLabel2.layer.borderColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0).cgColor
        shintyokuLabel2.layer.borderWidth = 1
        //shintyokuLabel2.layer.cornerRadius = 3
        //shintyokuLabel2.clipsToBounds = true
        cell.contentView.addSubview(shintyokuLabel2)
        
        let shintyokuLabel: UILabel = UILabel(frame: CGRect(x: width*0.292,y: height*0.164,width: width*0.68,height: height*0.037))
        shintyokuLabel.text = "達成度".appendingFormat("%.1f", tasseido*100) + "%"
        //shintyokuLabel.text = "達成度 \(tasseido*100)%"
        shintyokuLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(15))
        shintyokuLabel.textColor = UIColor.darkGray
        shintyokuLabel.textAlignment = .center
        //shintyokuLabel.backgroundColor = UIColor.clear
        shintyokuLabel.layer.cornerRadius = 2
        shintyokuLabel.clipsToBounds = true
        shintyokuLabel.layer.borderColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0).cgColor
        shintyokuLabel.layer.borderWidth = 1
        cell.contentView.addSubview(shintyokuLabel)
         */
        
        print("menuTableViewがある----")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight
    }
    
    func MenuListReload(){
        appDelegate.menuList = appDelegate.dbService.selectMenuT()
        
        print("テーブル更新")
        
        menuTableView.reloadData()
    }
    
    func onClickLeftButton(_ sender: UIButton){
         self.performSegue(withIdentifier: "setteiViewController", sender:self)
    }
    
    func onClickTodayBtn(_ sender: UIButton){
        
        let ud = UserDefaults.standard
        let udId = ud.object(forKey: ConstStruct.ballon_3) as? String
        if udId != "999" {
            ud.set("999", forKey: ConstStruct.ballon_3)
            ud.synchronize()
        }
        
        let date: Date = Date()
        self.appDelegate.selectedDay = Util.ISOStringFromDate(date)
        appDelegate.selectedMenuT = appDelegate.menuList.object(at: sender.tag) as! MenuT
        appDelegate.workoutKekkaSenimoto = 0
        print("選択された日 \(self.appDelegate.selectedDay)　メニューNO \(appDelegate.selectedMenuT.menuNo)")
        self.performSegue(withIdentifier: "WorkoutKekkaViewController", sender:nil)
    }
    
    @IBAction func onClickMenuAdd(_ sender: UIButton){
              self.performSegue(withIdentifier: "menuMakeViewController", sender:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

