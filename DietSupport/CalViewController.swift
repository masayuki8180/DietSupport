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
        return UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor.red
    }
}

class CalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let calManager = CalManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 0
    var selectedDate = Date()
    var today: Date!
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    var totalHeight: CGFloat = 500.0
    var beforeDay: Date!
    
    @IBOutlet weak var headerPrevBtn: UIButton!//①
    @IBOutlet weak var headerNextBtn: UIButton!//②
    @IBOutlet weak var headerTitle: UILabel!    //③
    @IBOutlet weak var headerTitle2: UILabel!    //③
    @IBOutlet weak var calenderHeaderView: UIView! //④
    @IBOutlet weak var calenderCollectionView: UICollectionView!//⑤
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        appDelegate.calviewController = self
        
        navigationItem.title = "結果の入力・確認";
        
        self.view.backgroundColor = UIColor.white
        self.calenderCollectionView.delegate = self
        self.calenderCollectionView.dataSource = self
        self.calenderCollectionView.isScrollEnabled = false
        //self.calenderCollectionView.backgroundColor = UIColor(red:0.69 , green:0.77, blue:0.87,alpha:1.0)
        //self.calenderCollectionView.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        //self.calenderCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        //self.calenderCollectionView.layer.borderWidth = 1
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(sender:)))
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        //self.calenderCollectionView.backgroundColor = UIColor.green
        
        self.headerTitle2.font = UIFont.boldSystemFont(ofSize: CGFloat(18))
        self.headerTitle2.textColor = UIColor.lightGray
        
        let str = changeHeaderTitle(selectedDate)
        self.headerTitle2.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
        
        self.headerTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(35))
        self.headerTitle.textColor = UIColor(red:ConstStruct.btn_color_red , green:ConstStruct.btn_color_green, blue:ConstStruct.btn_color_blue,alpha:1.0)
        self.headerTitle.text = str.substring(with: str.index(str.startIndex, offsetBy: 5)..<str.index(str.endIndex, offsetBy: 0))
        
        //let str: String = changeHeaderTitle(selectedDate) + "01日"
        
        //setEnabledBtn(headerPrevBtn, date: str, mode: 0)
        //setEnabledBtn(headerNextBtn, date: Util.ISOStringFromDate2(Util.endOfMonth(Util.convertDateFormat(str))), mode: 1)
    }
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return calManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        //cell.contentView.layer.borderColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0).cgColor
  

        //テキスト配置
        if indexPath.section == 0 {
            //cell.textLabel.text = weekArray[indexPath.row]
            cell.backgroundColor = .white
            
            let yobiLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: cell.frame.width,height: cell.frame.height))
            yobiLabel.textAlignment = .center
            yobiLabel.text = weekArray[indexPath.row]
            yobiLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(12))
            yobiLabel.textColor = UIColor.gray
            cell.contentView.addSubview(yobiLabel)
            
            cell.contentView.layer.borderWidth = 0
            
        } else {
            
            cell.contentView.layer.borderColor = UIColor(red:0.90 , green:0.90, blue:0.90,alpha:1.0).cgColor
            cell.contentView.layer.borderWidth = 0.5
            
            //print("******************** indexPath \(indexPath.row)")
            let rt = calManager.conversionDateFormat(indexPath)
            //cell.textLabel.text = rt.0
            cell.tag = Int(rt.2)!
            
            let dateLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: cell.frame.width/2,height: (cell.frame.height/4)-5))
            dateLabel.textAlignment = .center
            dateLabel.text = rt.0
            dateLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(12))
            
            //テキストカラー
            if (indexPath.row % 7 == 0) {
                dateLabel.textColor = UIColor.lightRed()
            } else if (indexPath.row % 7 == 6) {
                dateLabel.textColor = UIColor.lightBlue()
            } else {
                dateLabel.textColor = UIColor.darkGray
            }
            
            cell.contentView.addSubview(dateLabel)
            
            if(rt.1 == true){
                //print("cell.textLabel.text \(cell.textLabel.text!)はwhite")
                //cell.tag = 0
                cell.backgroundColor = UIColor.white
                
                let dayWorkOutT: DayWorkOutT = appDelegate.dbService.selectDayWorkoutTByDay(appDelegate.selectedMenuT.menuNo, inDay: String(cell.tag))
                
                let weihtCompleteLabel: UILabel = UILabel(frame: CGRect(x: 1,y: (cell.frame.height/1.8)-(self.view.frame.height/44.46),width: cell.frame.width-2,height: self.view.frame.height/44.46))
                weihtCompleteLabel.textAlignment = .center
                
                
                weihtCompleteLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
                cell.contentView.addSubview(weihtCompleteLabel)
                
                if dayWorkOutT.weight > 0 {
                    weihtCompleteLabel.text = String(dayWorkOutT.weight) + "kg"
                    weihtCompleteLabel.backgroundColor = UIColor(red:0.03 , green:0.22, blue:0.43,alpha:1.0)
                    weihtCompleteLabel.textColor = UIColor.white
                    weihtCompleteLabel.layer.cornerRadius = 3
                    weihtCompleteLabel.clipsToBounds = true
                    
                    let mokuhyo: Double = dayWorkOutT.weight - dayWorkOutT.mokuhyoWeight
                    let kijyun1: Double = dayWorkOutT.mokuhyoWeight*0.04
                    let kijyun2: Double = dayWorkOutT.mokuhyoWeight*0.08
                    if mokuhyo <= kijyun2 {
                        var imgFileName: String = "copper_t.png"
                        if mokuhyo <= kijyun1 {
                            imgFileName = "silver_t.png"
                        }
                        if mokuhyo <= 0 {
                            imgFileName = "gold_t.png"
                        }
                        let imgView = UIImageView(frame: CGRect(x: cell.frame.width/2, y: self.view.frame.height/133.4, width: cell.frame.width/2.3, height: cell.frame.width/2.3))
                        let img = UIImage(named: imgFileName)
                        imgView.image = img
                        cell.contentView.addSubview(imgView)
                    }
                    
                    
                }else{
                    weihtCompleteLabel.text = "未測定"
                    weihtCompleteLabel.textColor = UIColor.blue
                }
                
                let jissekiCal: Double = dayWorkOutT.jissekiCal1 + dayWorkOutT.jissekiCal2 + dayWorkOutT.jissekiCal3 + dayWorkOutT.jissekiCal4 + dayWorkOutT.jissekiCal5
                if jissekiCal > 0 {
                    let jissekiCalLabel: UILabel = UILabel(frame: CGRect(x: 1,y: (cell.frame.height/1.8)+5,width: cell.frame.width-2,height: self.view.frame.height/44.46))
                    jissekiCalLabel.textAlignment = .center
                    jissekiCalLabel.text = String(format: "%.1f", jissekiCal) + "kcal"
                    jissekiCalLabel.layer.cornerRadius = 3
                    jissekiCalLabel.clipsToBounds = true
                    jissekiCalLabel.backgroundColor = UIColor(red:0.93 , green:0.22, blue:0.31,alpha:1.0)
                    jissekiCalLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
                    jissekiCalLabel.textColor = UIColor.white
                    cell.contentView.addSubview(jissekiCalLabel)
                }

            }else{
                //print("cell.textLabel.text \(cell.textLabel.text!)はGray")
                cell.backgroundColor = UIColor(red:0.95 , green:0.95, blue:0.95,alpha:1.0)
                //cell.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
                cell.tag = 1
            }
            
          }
        return cell
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = collectionView.frame.size.width / CGFloat(daysPerWeek)
        //width = round(width)
        var height: CGFloat = 0
        
        if calManager.getNumberOfWeeks() > 5 {
            height = width * 1.5
        }else{
            height = width * 1.8
        }
        
        if indexPath.section == 0 {
            height = (width * 1.5) * 0.3
        }
        
        totalHeight = totalHeight + height
        
        return CGSize(width: width, height: height)
        
    }
    
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    
    /*
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var rtCellMargin: CGFloat = 0.0
        if section == 0 {
            rtCellMargin = 0.0
        }else {
            rtCellMargin = 0.0
        }
        
        return rtCellMargin
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //ここに処理を記述
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        let cell = collectionView.cellForItem(at: indexPath)!
        //print("タップされたよ　\(Int(cell.textLabel.text!)!) \(indexPath.row)")
        
        if(cell.tag == 1){
            print("タップ無視")
        }else{
            /*
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMM"
            let selectMonth = formatter.stringFromDate(selectedDate)
            var str:String = ""
            if cell.textLabel.text?.characters.count < 2 {
                str = "0" + cell.textLabel.text!
            }else{
                str = cell.textLabel.text!
            }*/
            //self.appDelegate.selectedDay = selectMonth.stringByAppendingString(str)
            appDelegate.selectedDay = String(cell.tag)
            print("選択された日 \(self.appDelegate.selectedDay)")
            appDelegate.workoutKekkaSenimoto = 1
            self.performSegue(withIdentifier: "WorkoutKekkaViewController", sender:nil)
        }
    }
    
    
    //headerの月を変更
    func changeHeaderTitle(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }
    
    func setEnabledBtn (_ btn: UIButton,date: String,mode: Int){
        if !calManager.isMonthRange(Util.convertDateFormat(date), mode: mode){
            btn.isEnabled = false
            btn.alpha = 0.3
        }else{
            btn.isEnabled = true
            btn.alpha = 1.0
        }
    }

    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            selectedDate = calManager.prevMonth(selectedDate)
        }
        else if sender.direction == .left {
            print("Left")
            selectedDate = calManager.nextMonth(selectedDate)
        }
        
        let str = changeHeaderTitle(selectedDate)
        self.headerTitle2.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
        self.headerTitle.text = str.substring(with: str.index(str.startIndex, offsetBy: 5)..<str.index(str.endIndex, offsetBy: 0))
        
        calenderCollectionView.reloadData()
    }
    
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        
        selectedDate = calManager.prevMonth(selectedDate)
        let str = changeHeaderTitle(selectedDate)
        self.headerTitle2.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
        self.headerTitle.text = str.substring(with: str.index(str.startIndex, offsetBy: 5)..<str.index(str.endIndex, offsetBy: 0))
        
        calenderCollectionView.reloadData()

    }

    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {

        selectedDate = calManager.nextMonth(selectedDate)
        
        let str = changeHeaderTitle(selectedDate)
        self.headerTitle2.text = str.substring(to: str.index(str.startIndex, offsetBy: 5))
        self.headerTitle.text = str.substring(with: str.index(str.startIndex, offsetBy: 5)..<str.index(str.endIndex, offsetBy: 0))
        
        calenderCollectionView.reloadData()

    }

    func reload(){
        self.calenderCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.calenderCollectionView.frame = CGRect(x: self.calenderCollectionView.frame.origin.x, y: self.calenderCollectionView.frame.origin.y, width: self.calenderCollectionView.frame.width, height: totalHeight+200);
        
        //print("self.calenderCollectionView.contentSize = CGSize(width: self.calenderCollectionView.frame.width, height: calenderCollectionView.frame.he)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

