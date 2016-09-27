//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuSelectViewController: UIViewController {

    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var json:NSDictionary!
    private var menuScrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame:CGRectMake(30, 145, 330, 25))
        label.text = "ダイエット期間　　" + appDelegate.menuT.kaishi + " 〜 " + appDelegate.menuT.syuryo;
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        self.view.addSubview(label)
        
        let label2 = UILabel(frame:CGRectMake(30, 180, 250, 25))
        label2.text = "目標体重　　 " + String(appDelegate.menuT.mokuHyoweight) + "Kg";
        label2.font = UIFont.systemFontOfSize(13)
        label2.textAlignment = NSTextAlignment.Left
        label2.textColor = UIColor.blackColor()
        self.view.addSubview(label2)
        
        let alert: UIAlertController = UIAlertController(title: "", message: "好みのメニューを選びましょう！\n\n自分好みのメニューを作成することもできます。", preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
        })

        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)


        let fixBtn = UIButton(frame: CGRectMake(self.view.frame.width/2-(30) , 600, 50, 30))
        fixBtn.backgroundColor = UIColor.lightGrayColor()
        fixBtn.setTitle("決定", forState: UIControlState.Normal)
        fixBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fixBtn.addTarget(self, action:#selector(MenuSelectViewController.fixMenu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(fixBtn)
        

        
        
        
        
        /*ここからはダミーのメニューリストなので、実際はクラウドから返却されてきたものを使用*/
        let workoutList = NSMutableArray(array: [])
        var workoutList2 = NSMutableArray(array: [])
    
        var workoutT:WorkOutT = WorkOutT()
        workoutT.workOUtName = "ジョギング"
        workoutT.workOUtValue = 5
        workoutT.workOutValueName = "km"
        workoutT.workOUtCal = 300
        workoutList2.addObject(workoutT)
        
        workoutT = WorkOutT()
        workoutT.workOUtName = "ヨガ"
        workoutT.workOUtValue = 10
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 200
        workoutList2.addObject(workoutT)
        workoutList.addObject(workoutList2)
        
        workoutList2 = NSMutableArray(array: [])
        workoutT = WorkOutT()
        workoutT.workOUtName = "ジョギング2"
        workoutT.workOUtValue = 5
        workoutT.workOutValueName = "km"
        workoutT.workOUtCal = 300
        workoutList2.addObject(workoutT)
        
        workoutT = WorkOutT()
        workoutT.workOUtName = "ヨガ2"
        workoutT.workOUtValue = 10
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 200
        workoutList2.addObject(workoutT)
        workoutList.addObject(workoutList2)
        
        workoutList2 = NSMutableArray(array: [])
        workoutT = WorkOutT()
        workoutT.workOUtName = "ジョギング3"
        workoutT.workOUtValue = 5
        workoutT.workOutValueName = "km"
        workoutT.workOUtCal = 300
        workoutList2.addObject(workoutT)
        
        workoutT = WorkOutT()
        workoutT.workOUtName = "ヨガ3"
        workoutT.workOUtValue = 10
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 200
        workoutList2.addObject(workoutT)
        workoutList.addObject(workoutList2)
        
        
        // ScrollViewを生成.
        menuScrollView = UIScrollView()
        
        // ScrollViewの大きさを設定する.
        menuScrollView.frame = CGRectMake(self.view.frame.width*0.1 , self.view.frame.height*0.4, self.view.frame.width*0.8, self.view.frame.height*0.4)
        menuScrollView.pagingEnabled = true
        //menuScrollView.backgroundColor = UIColor.blueColor()
        menuScrollView.contentSize = CGSizeMake((self.view.frame.width*0.8)*CGFloat(workoutList.count), self.view.frame.height*0.4)
        self.view.addSubview(menuScrollView)
        
        
        
        
        var x:CGFloat = 20
        var y:CGFloat = 30
        for i in 0..<workoutList.count {
            print("i = \(i)")
            y = 30
            let woList: NSMutableArray = workoutList.objectAtIndex(i) as! NSMutableArray
            for i2 in 0..<woList.count {
                print("i2 = \(i2)")
                let workoutT: WorkOutT = woList.objectAtIndex(i2) as! WorkOutT
                
                let label = UILabel(frame:CGRectMake(x, y, 200, 25))
                label.text = workoutT.workOUtName + "　　" + String(workoutT.workOUtValue) + workoutT.workOutValueName + "　　" + String(workoutT.workOUtCal) + "kcal";
                label.font = UIFont.systemFontOfSize(13)
                label.textAlignment = NSTextAlignment.Left
                label.textColor = UIColor.blackColor()
                menuScrollView.addSubview(label)
                y = y + 35
            }
            x = x + (self.view.frame.width*0.8)
        }
        
        
        
        

    }

    func fixMenu(sender: UIButton){
        let alert: UIAlertController = UIAlertController(title: "メニュー作成", message: "この内容でメニューを作成しますか？", preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let URL = NSURL(string: "http://eserve.sakura.ne.jp/diet/")
            let req = NSURLRequest(URL: URL!)
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
            
            var json:NSDictionary = NSDictionary()
            
            let task = session.dataTaskWithRequest(req, completionHandler: {
                (data, response, error) -> Void in
                do {
                    
                    //let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments ) as! NSDictionary
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print(json)
                    //let workout_name: String = json["workout_name"] as! String
                    //print(workout_name)
                    self.workoutDataSave(json)
                    
                } catch {
                    print("エラー")
                    //エラー処理
                    
                }
                
            })
            
            task.resume()
            
            
            //self.workoutDataSave(json)
            
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func workoutDataSave(json: NSDictionary){
    
        self.appDelegate.dbService.insertMenuT(self.appDelegate.menuT)
        
        //ここから下は仮
        let workoutT:WorkOutT = WorkOutT()
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 1
        workoutT.workOUtID = 1000
        print(json["workout_name"] as! String)
        workoutT.workOUtName = json["workout_name"] as! String
        workoutT.workOUtValue = Int(json["workout_value"] as! String)!
        workoutT.workOutValueName = json["workout_value_name"] as! String
        workoutT.workOUtCal = Int(json["workout_cal"] as! String)!
        
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 2
        workoutT.workOUtID = 2000
        workoutT.workOUtName = "筋トレ"
        workoutT.workOUtValue = 10
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 400
        
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        
        workoutT.menuNo = self.appDelegate.dbService.selectMaxMenuNo()
        workoutT.workOutNo = 3
        workoutT.workOUtID = 3000
        workoutT.workOUtName = "ヨガ"
        workoutT.workOUtValue = 15
        workoutT.workOutValueName = "分"
        workoutT.workOUtCal = 250
        
        self.appDelegate.dbService.insertWorkoutT(workoutT)
        
        self.torokuDayWorkOutT()
        
        //ここまで仮
        
        self.appDelegate.viewC.MenuListReload()
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)

    }
    
    func torokuDayWorkOutT(){
        let datefrom: NSDate = Util.dateFromISOString(self.appDelegate.menuT.kaishi) as NSDate
        //let datefrom = Util.stringFromDate(self.appDelegate.menuT.kaishi, format: "yyyy年MM月dd日"), forState: .Normal)
        let dateto: NSDate = Util.dateFromISOString(self.appDelegate.menuT.syuryo) as NSDate
        
        let span = datefrom.timeIntervalSinceDate(dateto) // 1209600秒差
        var daySpan: Int = abs(Int(span/60/60/24))
        
        daySpan = daySpan + 1
        print("期間 \(daySpan)")
        
        var wkDate :NSDate
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
            dayWorkoutT.workOutNo1 = 1
            genWeight = genWeight - sa
            print("genWeight \(genWeight) sa \(sa)")
            dayWorkoutT.mokuhyoWeight = genWeight
            dayWorkoutT.jissekiValue1 = 0
            dayWorkoutT.jissekiCal1 = 0
            dayWorkoutT.workOutNo2 = 0
            dayWorkoutT.jissekiValue2 = 0
            dayWorkoutT.jissekiCal2 = 0
            dayWorkoutT.workOutNo3 = 0
            dayWorkoutT.jissekiValue3 = 0
            dayWorkoutT.jissekiCal3 = 0
            dayWorkoutT.workOutNo4 = 0
            dayWorkoutT.jissekiValue4 = 0
            dayWorkoutT.jissekiCal4 = 0
            dayWorkoutT.workOutNo5 = 0
            dayWorkoutT.jissekiValue5 = 0
            dayWorkoutT.jissekiCal5 = 0
            
            self.appDelegate.dbService.insertDayWorkoutT(dayWorkoutT)
            
            wkDate = NSDate(timeInterval: 60*60*24, sinceDate: wkDate) as NSDate
            print("\(i)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

