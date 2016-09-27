//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var menuTableView: UITableView!
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.viewC = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //var userT:UserT = UserT()
        let userT = appDelegate.dbService.selectUserT()
        let ud = NSUserDefaults.standardUserDefaults()
        if(userT.name.characters.count > 0){
            let udId = ud.objectForKey("id") as? String
            if udId == "0" {
                ud.setObject("toroku", forKey: "1")
                ud.synchronize()
                
                print("ユーザー名"+userT.name)
                let alert: UIAlertController = UIAlertController(title: "登録完了", message: "登録が完了しました。", preferredStyle:  UIAlertControllerStyle.Alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                
                alert.addAction(defaultAction)
                presentViewController(alert, animated: true, completion: nil)
                
            }else{
                
                // Status Barの高さを取得する.
                var barHeight: CGFloat? = UIApplication.sharedApplication().statusBarFrame.size.height
                var barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
                
                barHeight = barHeight! + barHeight2!
                
                // Viewの高さと幅を取得する.
                let displayWidth: CGFloat = self.view.frame.width
                let displayHeight: CGFloat = self.view.frame.height
                
                if(menuTableView == nil){
                    
                    appDelegate.menuList = appDelegate.dbService.selectMenuT()
                    
                    // TableViewの生成する(status barの高さ分ずらして表示).
                    menuTableView = UITableView(frame: CGRect(x: 0, y: barHeight!, width: displayWidth, height: displayHeight - barHeight!))
                    //menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight!))
                    
                    // Cell名の登録をおこなう.
                    menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                    
                    // DataSourceの設定をする.
                    menuTableView.dataSource = self
                    
                    // Delegateを設定する.
                    menuTableView.delegate = self
                    
                    // Viewに追加する.
                    self.view.addSubview(menuTableView)
                }else{
                }
                
            }
        
        }else{
            
            ud.registerDefaults(["toroku": "0"])
            
            super.viewDidDisappear(animated)
            let userTorokuViewController = UserTorokuViewController()
            self.navigationController?.pushViewController(userTorokuViewController, animated: true)
        }
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("Num: \(indexPath.row)")
        //print("Value: \(myItems[indexPath.row])")
        appDelegate.selectedMenuT = appDelegate.menuList.objectAtIndex(indexPath.row) as! MenuT

        //let menuSyosaiViewController = MenuSyosaiViewController()
        //self.navigationController?.pushViewController(menuSyosaiViewController, animated: true)
        self.performSegueWithIdentifier("menuSyosaiViewController", sender:self)

    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("appDelegate.menuList.count + \(appDelegate.menuList.count)")
        return appDelegate.menuList.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        
        // Cellに値を設定する.
        let menuT: MenuT = appDelegate.menuList.objectAtIndex(indexPath.row) as! MenuT
        print("開始　\(menuT.menuNo) \(indexPath.row)")
        cell.textLabel!.text = "期間　" + menuT.kaishi + " 〜 " + menuT.syuryo
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func MenuListReload(){
        appDelegate.menuList = appDelegate.dbService.selectMenuT()
        
        print("テーブル更新")
        
        menuTableView.reloadData()
    }
    
    @IBAction func onClickMenuAdd(sender: UIButton){
        let menuMakeViewController = MenuMakeViewController()
        self.navigationController?.pushViewController(menuMakeViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

