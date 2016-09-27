//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class CalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let calManager = CalManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    
    @IBOutlet weak var headerPrevBtn: UIButton!//①
    @IBOutlet weak var headerNextBtn: UIButton!//②
    @IBOutlet weak var headerTitle: UILabel!    //③
    @IBOutlet weak var calenderHeaderView: UIView! //④
    @IBOutlet weak var calenderCollectionView: UICollectionView!//⑤
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calenderCollectionView.delegate = self
        self.calenderCollectionView.dataSource = self
        self.calenderCollectionView.backgroundColor = UIColor.whiteColor()
        
        self.headerTitle.text = changeHeaderTitle(selectedDate) //追記
    }
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return calManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.grayColor()
        }
        //テキスト配置
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            let rt = calManager.conversionDateFormat(indexPath)
            cell.textLabel.text = rt.0
            if(rt.1 == true){
                cell.tag = 0
                cell.backgroundColor = UIColor.whiteColor()
            }else{
                cell.backgroundColor = UIColor.lightGrayColor()
                cell.tag = 1
            }
            
            //print("*　\(cell.textLabel.text)")
            
            //月によって1日の場所は異なる(後ほど説明します)
        }
        return cell
    }
    
    //セルのサイズを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSizeMake(width, height)
        
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //ここに処理を記述
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarCell
        print("タップされたよ　\(Int(cell.textLabel.text!)!) \(indexPath.row)")
        
        if(cell.tag == 1){
            print("タップ無視")
        }else{
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMM"
            let selectMonth = formatter.stringFromDate(selectedDate)
            var str:String = ""
            if cell.textLabel.text?.characters.count < 2 {
                str = "0" + cell.textLabel.text!
            }else{
                str = cell.textLabel.text!
            }
            self.appDelegate.selectedDay = selectMonth.stringByAppendingString(str)
            print("選択された日 \(self.appDelegate.selectedDay)")
            self.performSegueWithIdentifier("WorkoutKekkaViewController", sender:nil)
        }
    }
    
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    
    //①タップ時
    @IBAction func tappedHeaderPrevBtn(sender: UIButton) {
        selectedDate = calManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    //②タップ時
    @IBAction func tappedHeaderNextBtn(sender: UIButton) {
        selectedDate = calManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

