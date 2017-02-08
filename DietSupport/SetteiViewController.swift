//
//  SetteiViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit
import MessageUI

class SetteiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    fileprivate var setteiTableView: UITableView!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var list = ["プロフィール", "ヘルプ", "通知設定", "お問い合わせ", "利用規約", "プライバシーポリシー", "バージョン情報"]
    let tableHeight: CGFloat = 50.0
    var pushBtn: UIButton!
    var notificationTimeEditor: UIDatePicker!
    var notificationTime: Date?
    var pickerBackView: UIView = UIView()
    var swicth: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "設定";
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.viewTapped(_:))))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
        let setteiLabel: UILabel = UILabel(frame: CGRect(x: 20,y:((self.view.frame.height+Util.getStatusbarHight(self.navigationController!))/2)-((tableHeight*CGFloat(list.count))/2)-25,width: 100,height: 25))
        setteiLabel.text = "設定情報"
        setteiLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        setteiLabel.textColor = UIColor.gray
        self.view.addSubview(setteiLabel)
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        setteiTableView = UITableView(frame: CGRect(x: 0, y: ((self.view.frame.height+Util.getStatusbarHight(self.navigationController!))/2)-((tableHeight*CGFloat(list.count))/2), width: self.view.frame.width, height: tableHeight*CGFloat(list.count)))
        setteiTableView.isScrollEnabled = false
        
        // Cell名の登録をおこなう.
        setteiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        setteiTableView.dataSource = self
        
        // Delegateを設定する.
        setteiTableView.delegate = self
        setteiTableView.backgroundColor = UIColor.blue
        
        // Viewに追加する.
        self.view.addSubview(setteiTableView)
        
        let ud = UserDefaults.standard
        
        let date: String? = ud.object(forKey: "push_time") as? String
        
        if date == nil {
            ud.set(Util.stringFromDate(Date(), format: "HH:mm"), forKey: "push_time_text" )
            ud.set(Util.stringFromDate(Date(), format: "yyyyMMddHHmm"), forKey: "push_time" )
            ud.synchronize()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ABC")
        if indexPath.row == 0 {
            let userTorokuViewController = UserTorokuViewController()
            self.navigationController?.pushViewController(userTorokuViewController, animated: true)
        }else if indexPath.row == 3 {
            //メールを送信できるかチェック
            if MFMailComposeViewController.canSendMail()==false {
                print("Email Send Failed")
                MyAlertController.show(presentintViewController: self, title: "", message:"メールを送信できません。メールアカウントの設定を確認してください。", buttonTitle: "OK")
                { action in
                    switch action {
                    case .ok :break
                    case .cancel :break
                    }
                }
                return
            }
            
            let mailViewController = MFMailComposeViewController()
            let toRecipients = ["munbai7777@gmail.com"]
            
            mailViewController.mailComposeDelegate = self
            mailViewController.setSubject("お問い合わせ")
            mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
            let version: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            let iosVersion: String? = UIDevice.current.systemVersion
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let userT = appDelegate.dbService.selectUserT()
            let mailBody: String = "【ご使用のiOSバージョン】" + iosVersion! + "\n" + "【ご利用のアプリバージョン】" + version! + "\n" + "【ユーザーID】" + String(userT.userID) + "\n" + "お問い合わせ内容"
            mailViewController.setMessageBody(mailBody, isHTML: false)
            mailViewController.navigationBar.tintColor = UIColor.white
            
            present(mailViewController, animated: true, completion: nil)
 
        }else if indexPath.row == 4 {
            self.performSegue(withIdentifier: "riyoKiyakuViewController", sender:self)
        }else if indexPath.row == 5 {
            self.performSegue(withIdentifier: "privacyPolicyViewController", sender:self)
        }
    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("list.count \(list.count)")
        return list.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let workOUtNameLabel: UILabel = UILabel(frame: CGRect(x: 20,y: (tableHeight/2)-(20/2),width: 200,height: 20))
        workOUtNameLabel.text = list[indexPath.row]
        workOUtNameLabel.textColor = UIColor.black
        cell.contentView.addSubview(workOUtNameLabel)
        
        if indexPath.row == 2 {
            
            pushBtn = UIButton(frame: CGRect(x: self.view.frame.width*0.35, y: 0, width: self.view.frame.width*0.3, height: tableHeight))
            pushBtn.backgroundColor = UIColor.white
            pushBtn.setTitleColor( UIColor.black, for: UIControlState())
            pushBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            pushBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            
            /*
            let ud = UserDefaults.standard
            
            // キーがidの値をとります。
            let dateText: String? = ud.object(forKey: "push_time_text") as? String
            let date: String? = ud.object(forKey: "push_time") as? String
            
            if date == nil{
                pushBtn.setTitle("毎日　"+Util.stringFromDate(date: Date(), format: "HH:mm"), for: UIControlState())
                notificationTime = Date()
            }else{
                print("dateText = \(dateText)")
                pushBtn.setTitle("毎日　"+dateText!, for: UIControlState())
                 notificationTime = Util.dateFromISOString3(date!)
                print("date = \(date) notificationTime \(notificationTime)")
            }*/
            
            let ud = UserDefaults.standard
            
            // キーがidの値をとります。
            let dateText: String? = ud.object(forKey: "push_time_text") as? String
            let date: String? = ud.object(forKey: "push_time") as? String
            
            pushBtn.setTitle("毎日　"+dateText!, for: UIControlState())
            notificationTime = Util.dateFromISOString3(date!)
            print("date = \(date) notificationTime \(notificationTime)")
            
            pushBtn.addTarget(self, action:#selector(self.pushSelected(_:)), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(pushBtn)
            
            swicth = UISwitch()
            swicth.layer.position = CGPoint(x:self.view.frame.width*0.8, y: tableHeight/2)
            // Swicthの枠線を表示する.
            //mySwicth.tintColor = UIColor.black
                
            // SwitchをOnに設定する.
            let switchIson: String? = ud.object(forKey: "switch_ison") as? String
            if switchIson == nil {
                swicth.isOn = false
            }else{
                if switchIson!.compare("0") == ComparisonResult.orderedSame {
                    swicth.isOn = false
                }else{
                    swicth.isOn = true
                }
            }

            // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
            swicth.addTarget(self, action:#selector(self.onClickSwitch(_:)), for: UIControlEvents.touchUpInside)
            // SwitchをViewに追加する.
            cell.contentView.addSubview(swicth)
            
        }else if indexPath.row == 6 {
            let version: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            let versionLabel: UILabel = UILabel(frame: CGRect(x: self.view.frame.width*0.7,y: (tableHeight/2)-(20/2),width: self.view.frame.width*0.13,height: 20))
            versionLabel.text = version
            versionLabel.textColor = UIColor.black
            versionLabel.textAlignment = .right
            cell.contentView.addSubview(versionLabel)
        }
        
        return cell
    }
    
    func onClickSwitch(_ sender: UISwitch){

        if sender.isOn == true {
            

            let notification: UILocalNotification = UILocalNotification()
            
            notification.alertBody = "ワークアウトの時間です！"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.autoupdatingCurrent
            notification.fireDate =  notificationTime
            
            UIApplication.shared.scheduleLocalNotification(notification)
            notification.repeatInterval = .day

            let ud = UserDefaults.standard
            if notificationTimeEditor != nil{
                print("notificationTime \(notificationTime)  " + Util.stringFromDate(notificationTime!, format: "HH:mm"))
                ud.set(Util.stringFromDate(notificationTime!, format: "HH:mm"), forKey: "push_time_text" )
                ud.set(Util.stringFromDate(notificationTime!, format: "yyyyMMddHHmm"), forKey: "push_time" )
            }
            
            ud.set("1", forKey: "switch_ison" )
            ud.synchronize()
            
        }else{
            //現在のノーティフケーションを削除
            UIApplication.shared.cancelAllLocalNotifications()
            let ud = UserDefaults.standard
            ud.set("0", forKey: "switch_ison" )
            ud.synchronize()
        }
    }
    
    func pushSelected(_ sender: UIButton){
        
        if(notificationTimeEditor != nil){
            notificationTimeEditor.removeFromSuperview()
            notificationTimeEditor = nil
            pickerBackView.removeFromSuperview()
        }
        
        pickerBackView.frame = self.view.bounds
        pickerBackView.backgroundColor = UIColor.black
        pickerBackView.alpha = 0.5
        self.view.addSubview(pickerBackView)
        
        // 通知時間を設定する
        notificationTimeEditor = UIDatePicker()
        notificationTimeEditor.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        notificationTimeEditor.setDate(Date(),animated: true)
        notificationTimeEditor.datePickerMode = UIDatePickerMode.time
        notificationTimeEditor.backgroundColor = UIColor.white
        //notificationTimeEditor.layer.position = CGPoint(x:self.view.bounds.width/2, y: 240)
        notificationTimeEditor.minimumDate = Date()
        notificationTimeEditor.timeZone = TimeZone(abbreviation: "ja_JP")
            notificationTimeEditor.addTarget(self, action:#selector(self.fixNotificationTime(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(notificationTimeEditor)
    }
    
    func viewTapped(_ sender: UIView){
        
        if(notificationTimeEditor != nil){
            notificationTimeEditor.removeFromSuperview()
            notificationTimeEditor = nil
            pickerBackView.removeFromSuperview()
        }
    }
    
    // 通知時間の確定
    func fixNotificationTime(_ sender: UIDatePicker) {
        notificationTime = sender.date
        pushBtn.setTitle("毎日　"+Util.stringFromDate(notificationTime!, format: "HH:mm"), for: UIControlState())
        
        if swicth.isOn == true {
            let notification: UILocalNotification = UILocalNotification()
            
            notification.alertBody = "ワークアウトの時間です！"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.autoupdatingCurrent
            notification.fireDate =  notificationTime
            
            UIApplication.shared.scheduleLocalNotification(notification)
            notification.repeatInterval = .day
            
            let ud = UserDefaults.standard
            ud.set(Util.stringFromDate(notificationTime!, format: "HH:mm"), forKey: "push_time_text" )
            ud.set(Util.stringFromDate(notificationTime!, format: "yyyyMMddHHmm"), forKey: "push_time" )
            ud.synchronize()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        print(" controller.dismiss****************")
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case MFMailComposeResult.cancelled:
            break
        case MFMailComposeResult.saved:
            print("Email Saved as a Draft")
            break
        case MFMailComposeResult.sent:
            print("Email Sent Successfully")
            MyAlertController.show(presentintViewController: self, title: "", message:"\nメールを送信しました。\n", buttonTitle: "OK")
            { action in
                switch action {
                case .ok :break
                case .cancel:break
                }
            }
            break
        case MFMailComposeResult.failed:
            print("Email Send Failed")
            MyAlertController.show(presentintViewController: self, title: "", message:"\nメールを送信に失敗しました。\n", buttonTitle: "OK")
            { action in
                switch action {
                case .ok :
                    controller.dismiss(animated: false, completion: nil)
                    break
                case .cancel :break
                }
            }
            break
        }
    }
}

