//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var scview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "体重の推移"
        
        //self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        self.view.backgroundColor = UIColor.white
        
        scview = UIScrollView()
        //scview.backgroundColor = UIColor.white
  
        var barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
        let barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
        
        barHeight = barHeight! + barHeight2!
    
        let dayWorkList: NSMutableArray = appDelegate.dbService.selectDayWorkoutT(appDelegate.selectedMenuT.menuNo)
        let maxWidth: CGFloat = ((((self.view.frame.height-barHeight!)*0.85)/10))*CGFloat((dayWorkList.count+1))
        print("スクロールビューのmaxWidth \(maxWidth)")
        scview.frame = CGRect(x: 40, y: barHeight!+10, width: self.view.frame.width, height: ((self.view.frame.height-barHeight!)*0.85)*1.05)
        //scview.frame = CGRect(x: 40, y: ((self.view.frame.height-barHeight!)/2)-(((self.view.frame.height-barHeight!)*0.7)/2), width: self.view.frame.width, height: ((self.view.frame.height-barHeight!)*0.9)*1.05)
        
        //scview.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200)
        
        //print(" graphview.frame.width \(graphview.frame.width)  \(graphview.frame.height) graphview.maxWidth---+++ = \(graphview.maxWidth)")
        
        scview.contentSize = CGSize(width:maxWidth+40, height:((self.view.frame.height-barHeight!)*0.85)) //スクロールビュー内のコンテンツサイズ設定
        self.view.addSubview(scview);
        let graphview = Graph() //グラフを表示するクラス
        graphview.superviewWidth = self.view.frame.width
        graphview.superviewHeight = self.view.frame.height-barHeight!
        graphview.initialize()
        
        graphview.drawLineGraph() //グラフ描画開始
        //graphview.drawMemori()
        self.drawMemori()
        
        //scview.layer.borderColor = UIColor.black.cgColor
        //scview.layer.borderWidth = 1
        
        scview.addSubview(graphview) //グラフをスクロールビューに配置
        
        if graphview.scrollPoint > 0 {
            print("スクロール位置を調整！ graphview.scrollPoint = \(graphview.scrollPoint)")
            if graphview.scrollPoint-(scview.frame.width/2) > 0 {
                scview.contentOffset = CGPoint(x: graphview.scrollPoint-(scview.frame.width/2),y: 0.0)
            }
        }
        
        let hanreiView: UIView = UIView(frame: CGRect(x: 40, y: barHeight!+10+(((self.view.frame.height-barHeight!)*0.85)*1.05), width: self.view.frame.width*0.7, height: self.view.frame.height*0.0443))
        hanreiView.backgroundColor = UIColor.clear
        hanreiView.layer.cornerRadius = 5
        self.view.addSubview(hanreiView)
        
        let yoteiView: UIView = UIView(frame: CGRect(x: view.frame.width*0.08, y: 13, width: view.frame.width*0.1, height: 3))
        yoteiView.backgroundColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:0.7)
        hanreiView.addSubview(yoteiView)
        
        let yoteiLabel = UILabel(frame:CGRect(x: view.frame.width*0.2, y: 5, width: view.frame.width*0.133, height: 20))
        yoteiLabel.text = "予定体重"
        yoteiLabel.font = UIFont.boldSystemFont(ofSize: 13)
        yoteiLabel.textAlignment = NSTextAlignment.left
        yoteiLabel.textColor = UIColor.black
        yoteiLabel.adjustsFontSizeToFitWidth = true
        hanreiView.addSubview(yoteiLabel)
        
        let kekkaView: UIView = UIView(frame: CGRect(x: view.frame.width*0.386, y: 13, width: view.frame.width*0.1, height: 3))
        kekkaView.backgroundColor = UIColor(red:0.80,  green:0.00,  blue:0.00, alpha:1)
        hanreiView.addSubview(kekkaView)
        
        let kekkaLabel = UILabel(frame:CGRect(x: view.frame.width*0.5, y: 5, width: view.frame.width*0.133, height: 20))
        kekkaLabel.text = "結果体重"
        kekkaLabel.font = UIFont.boldSystemFont(ofSize: 13)
        kekkaLabel.textAlignment = NSTextAlignment.left
        kekkaLabel.textColor = UIColor.black
        kekkaLabel.adjustsFontSizeToFitWidth = true
        hanreiView.addSubview(kekkaLabel)

    
    }
    
    func drawMemori()
    {
        let memori: Double = Double((appDelegate.selectedMenuT.kaishiWeight - appDelegate.selectedMenuT.mokuHyoweight)/10)
        let kaishi: Double = Double(appDelegate.selectedMenuT.kaishiWeight + (memori*2))
        let mokuhyo: Double = Double(appDelegate.selectedMenuT.mokuHyoweight - (memori*2))
        
        
        
        //let dayWorkOutTo: DayWorkOutT = dayWorkList.object(at: dayWorkList.count-1) as! DayWorkOutT
        let weightRange: CGFloat = CGFloat(kaishi) - CGFloat(mokuhyo)
        var y: CGFloat = scview.frame.origin.y-15
        var memori2: CGFloat = CGFloat(kaishi)
        
        for i in 0..<15 {
            
            if i == 0 {
                let memoriLabel = UILabel(frame:CGRect(x: 10, y: y+10, width: 40, height: 15))
                memoriLabel.text = "".appendingFormat("%.1f", memori2) + "";
                memoriLabel.font = UIFont.systemFont(ofSize: 12)
                memoriLabel.textAlignment = NSTextAlignment.left
                memoriLabel.textColor = UIColor.darkGray
                memoriLabel.adjustsFontSizeToFitWidth = true
                self.view.addSubview(memoriLabel)
            }else{
                let memoriLabel = UILabel(frame:CGRect(x: 10, y: y, width: 40, height: 15))
                memoriLabel.text = "".appendingFormat("%.1f", memori2) + "";
                memoriLabel.font = UIFont.systemFont(ofSize: 12)
                memoriLabel.textAlignment = NSTextAlignment.left
                memoriLabel.textColor = UIColor.darkGray
                memoriLabel.adjustsFontSizeToFitWidth = true
                self.view.addSubview(memoriLabel)
            }
            
            var barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
            let barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
            
            barHeight = barHeight! + barHeight2!
            
            y = y + CGFloat(((self.view.frame.height-barHeight!)*0.85)/14.0)
            memori2 = memori2 - (weightRange/14.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

