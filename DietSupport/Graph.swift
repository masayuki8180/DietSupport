//
//  Graph.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/08/12.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class Graph: UIView {
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var lineWidth:CGFloat = 3.0 //グラフ線の太さ
    var lineWidth2:CGFloat = 0.5 //背景線の太さ
    var lineColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:0.7) //グラフ線の色
    var circleWidth:CGFloat = 4.0 //円の半径
    var circleColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:0.7) //円の色
    
    var lineColor2:UIColor = UIColor(red:0.80,  green:0.00,  blue:0.00, alpha:1) //グラフ線の色
    var circleColor2:UIColor = UIColor(red:0.80,  green:0.00,  blue:0.00, alpha:1) //円の色
    var lineColor3:UIColor = UIColor(red:0.10,  green:0.10,  blue:0.10, alpha:0.3) //背景線の色
    var memoriMargin: CGFloat = 40 //横目盛の感覚
    var graphHeight: CGFloat = 400 //グラフの高さ
    var graphPoints: [String] = []
    var dayWorkList:NSMutableArray = []
    var graphDatas: [CGFloat] = []
    var superviewWidth: CGFloat = 0
    var superviewHeight: CGFloat = 0
    var maxWidth: CGFloat = 0
    var nowX: CGFloat = 0
    var scrollPoint: CGFloat = 0
    
    func initialize()
    {
        dayWorkList = appDelegate.dbService.selectDayWorkoutT(appDelegate.selectedMenuT.menuNo)
        //graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
        //graphDatas = [100, 30, 10, -50, 90, 12, 40]
        
        //graphHeight = superviewHeight*0.5997
        graphHeight = superviewHeight*0.85
        memoriMargin = graphHeight/10.0
        circleWidth = graphHeight/100.0
        maxWidth = CGFloat(dayWorkList.count+1)*memoriMargin
        print("グラフのmaxWidth----- = \(maxWidth)")
    }
    
    func drawLineGraph()
    {
   
        GraphFrame()
        MemoriGraphDraw()
    }
    
    //グラフを描画するviewの大きさ
    func GraphFrame(){
        self.backgroundColor = UIColor(red:0.95 , green:0.95, blue:0.95,alpha:1.0)
        self.frame = CGRect(x: 0 , y: 0, width: maxWidth, height: graphHeight)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    //横目盛・グラフを描画する
    func MemoriGraphDraw() {
        
        var count:CGFloat = 0
        for memori in dayWorkList {
            
            let label = UILabel()
            let dayWorkOutT : DayWorkOutT = memori as! DayWorkOutT
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let date: Date! = formatter.date(from: dayWorkOutT.day)
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "M/d"
            //let dateString = formatter.stringFromDate(date)

            label.text = formatter2.string(from: date)
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.darkGray
            
            //ラベルのサイズを取得
            let frame = CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude)
            let rect = label.sizeThatFits(frame)
            
            //ラベルの位置
            var lebelX = (count * memoriMargin)-rect.width/2
            
            //最初のラベル
            if Int(count) == 0{
                lebelX = (count * memoriMargin)
            }else{
                
            }
            
            //最後のラベル
            /*
            if Int(count+1) == dayWorkList.count{
                lebelX = (count * memoriMargin)-rect.width
                svWidth = lebelX
                print("横幅 \(svWidth)")
            }*/
            
            label.frame = CGRect(x: lebelX , y: graphHeight, width: rect.width, height: rect.height)
            self.addSubview(label)
            
            let dateNow: Date! = formatter.date(from: Util.ISOStringFromDate(Date()))
            print("dateだよ = \(date) lebelX = \(lebelX)")
            if (dateNow.compare(date) == ComparisonResult.orderedSame) {
                //print("dateだよ = \(date)")
                print("dateが今日 = \(date) lebelX = \(lebelX)")
                if count == 0 {
                    nowX = 0
                }else{
                    nowX = lebelX + (rect.width/2)
                }
                
                if lebelX > 190 {
                    scrollPoint = nowX
                }

            }
            
            count += 1
            

        }
    }
    
    override func draw(_ rect: CGRect) {
        
        var count:CGFloat = 0
        var weightSa:CGFloat = 0
        var ruisekiWeightSa:CGFloat = 0
        let linePath = UIBezierPath()
        var myCircle = UIBezierPath()
        
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        
        let memori: CGFloat = (CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(appDelegate.selectedMenuT.mokuHyoweight))/10.0
        let kaishi: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) + (memori*2.0)
        let mokuhyo: CGFloat = CGFloat(appDelegate.selectedMenuT.mokuHyoweight) - (memori*2.0)
        

        //let weightRange: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(appDelegate.selectedMenuT.mokuHyoweight)
        let weightRange2: CGFloat = kaishi - mokuhyo
        //print("全体の範囲 \(weightRange)")
        for datapoint in dayWorkList {
            if Int(count+1) < dayWorkList.count {
                let dayWorkOutT : DayWorkOutT = datapoint as! DayWorkOutT
                let nowY: CGFloat = ((kaishi - CGFloat(dayWorkOutT.mokuhyoWeight))/weightRange2) * (graphHeight - circleWidth)
                
                //次のポイントを計算
                var nextY: CGFloat = 0
                //nextY = ((CGFloat(kaishi) - CGFloat(dayWorkOutT.mokuhyoWeight))/weightRange2) * (graphHeight - circleWidth)
                
                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if Int(count) == 0 {
                    linePath.move(to: CGPoint(x: count * memoriMargin + circleWidth, y: nowY))
                    circlePoint = CGPoint(x: count * memoriMargin + circleWidth, y: nowY)
                    //print("円の位置 \(nextY)")
                    myCircle = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                    circleColor.setFill()
                    myCircle.fill()
                    myCircle.stroke()
                    
                    weightSa = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.mokuhyoWeight)
                    //ruisekiWeightSa = weightSa
                    nextY = nowY + ((weightSa/weightRange2) * (graphHeight - circleWidth))

                }else{
                    //ruisekiWeightSa = ruisekiWeightSa+weightSa
                    nextY = nowY + ((weightSa/weightRange2) * (graphHeight - circleWidth))
                    //nextY = (ruisekiWeightSa/weightRange2) * (graphHeight - circleWidth)
                }
                
                //描画ポイントを指定
                linePath.addLine(to: CGPoint(x: (count+1) * memoriMargin, y: nextY))
                //円をつくる
                //print("円の位置 x \((count+1) * memoriMargin) y \(nextY)")
                circlePoint = CGPoint(x: (count+1) * memoriMargin, y: nextY)
                myCircle = UIBezierPath(arcCenter: circlePoint,
                                        // 半径
                    radius: circleWidth,
                    // 初角度
                    startAngle: 0.0,
                    // 最終角度
                    endAngle: CGFloat(M_PI*2),
                    // 反時計回り
                    clockwise: false)
                circleColor.setFill()
                myCircle.fill()
                myCircle.stroke()

                let weightLabel: UILabel = UILabel(frame: CGRect(x: (count * memoriMargin)+5,y: nextY-15,width: self.frame.width*0.053,height: self.frame.height*0.015))
                weightLabel.text = String(format: "%.1f",dayWorkOutT.mokuhyoWeight)
                weightLabel.textColor = UIColor.black
                weightLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
                weightLabel.adjustsFontSizeToFitWidth = true
                self.addSubview(weightLabel)
                
                if Int(count+2) == dayWorkList.count {
                    print("最後\(dayWorkOutT.mokuhyoWeight) ")
                    let weightLabel: UILabel = UILabel(frame: CGRect(x: ((count+1) * memoriMargin)+5,y: nextY-15,width: self.frame.width*0.053,height: self.frame.height*0.015))
                    weightLabel.text = String(format: "%.1f",dayWorkOutT.mokuhyoWeight)
                    weightLabel.textColor = UIColor.black
                    weightLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
                    weightLabel.adjustsFontSizeToFitWidth = true
                    self.addSubview(weightLabel)
                }
                
            }
            
            count += 1
            
        }
        linePath.stroke()
        
        //実績の描画
        var count2:CGFloat = 0
        let linePath2 = UIBezierPath()
        var myCircle2 = UIBezierPath()
        
        linePath2.lineWidth = lineWidth
        lineColor2.setStroke()
        
        for i in 0..<dayWorkList.count {
            let dayWorkOutT : DayWorkOutT = dayWorkList.object(at: i) as! DayWorkOutT
            //print("\(i)番目のdayWorkOutT.weight \(dayWorkOutT.weight)")
            var circlePoint:CGPoint = CGPoint()
            
            if i == 0 {
                var nowY: CGFloat = 0.0
                if dayWorkOutT.weight > 0 {
                    print("点だけ描画　体重あり")
                    nowY = ((CGFloat(kaishi) - CGFloat(dayWorkOutT.weight))/weightRange2) * (graphHeight - circleWidth)
                    linePath2.move(to: CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY))
                    circlePoint = CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY)
                    myCircle2 = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                    circleColor2.setFill()
                    myCircle2.fill()
                    myCircle2.stroke()
                    
                    let weightLabel: UILabel = UILabel(frame: CGRect(x: (count2 * memoriMargin),y: nowY+10,width: self.frame.width*0.053,height: self.frame.height*0.015))
                    weightLabel.text = String(dayWorkOutT.weight)
                    weightLabel.textColor = UIColor.black
                    weightLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
                    weightLabel.adjustsFontSizeToFitWidth = true
                    self.addSubview(weightLabel)
                    
                }else{
                    print("点だけ描画　体重なし")
                    nowY = ((CGFloat(kaishi) - CGFloat(dayWorkOutT.mokuhyoWeight))/weightRange2) * (graphHeight - circleWidth)
                    linePath2.move(to: CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY))
                    circlePoint = CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY)
                    myCircle2 = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                    circleColor2.setFill()
                    myCircle2.fill()
                    myCircle2.stroke()
                }
            } else {
                if dayWorkOutT.weight > 0 {
                    //let nowY: CGFloat = ((CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.weight))/weightRange) * (graphHeight - circleWidth)
                    //次のポイントを計算
                    var nextY: CGFloat = 0
                    nextY = ((CGFloat(kaishi) - CGFloat(dayWorkOutT.weight))/weightRange2) * (graphHeight - circleWidth)
                    
                    //描画ポイントを指定
                    print("線をひく \((count2) * memoriMargin) 更新 \(nextY)")
                    linePath2.addLine(to: CGPoint(x: (count2) * memoriMargin, y: nextY))
                    
                    //円をつくる
                    let circlePoint = CGPoint(x: (count2) * memoriMargin, y: nextY)
                    myCircle2 = UIBezierPath(arcCenter: circlePoint,
                                             // 半径
                        radius: circleWidth,
                        // 初角度
                        startAngle: 0.0,
                        // 最終角度
                        endAngle: CGFloat(M_PI*2),
                        // 反時計回り
                        clockwise: false)
                    circleColor2.setFill()
                    myCircle2.fill()
                    myCircle2.stroke()
                    
                    let weightLabel: UILabel = UILabel(frame: CGRect(x: (count2 * memoriMargin)-5,y: nextY+5,width: self.frame.width*0.053,height: self.frame.height*0.015))
                    weightLabel.text = String(dayWorkOutT.weight)
                    weightLabel.textColor = UIColor.black
                    weightLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
                    weightLabel.adjustsFontSizeToFitWidth = true
                    self.addSubview(weightLabel)
                }
            }
            count2 = count2 + 1
        }
        
        linePath2.stroke()
        
        let linePath3 = UIBezierPath()
        
        linePath3.lineWidth = lineWidth2
        lineColor3.setStroke()
        
        
        //let dayWorkOutTo: DayWorkOutT = dayWorkList.object(at: dayWorkList.count-1) as! DayWorkOutT
        //let weightRange: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutTo.mokuhyoWeight)
        var yPoint: CGFloat = 0
        //var memori: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight)
        
        for i in 0..<14 {
            yPoint = yPoint + (graphHeight/14.0)
            linePath3.move(to: CGPoint(x: 0, y: yPoint-7))
            linePath3.addLine(to: CGPoint(x: self.frame.width, y: yPoint-7))
            /*
             let memoriLabel = UILabel(frame:CGRect(x: 0, y: y, width: 40, height: 15))
             memoriLabel.text = "".appendingFormat("%.1f", memori) + "kg";
             memoriLabel.font = UIFont.systemFont(ofSize: 12)
             memoriLabel.textAlignment = NSTextAlignment.left
             memoriLabel.textColor = UIColor.black
             self.addSubview(memoriLabel)
             print("表示位置 \(y)　　メモリ値　\(memori)")
             */
            //memori = memori - (weightRange/10.0)
            
            
        }
        
        linePath3.stroke()
        
        //今日の縦線を描画
        let linePath4 = UIBezierPath()
        
        linePath4.lineWidth = lineWidth2
        lineColor2.setStroke()
        
        linePath4.move(to: CGPoint(x: nowX, y: 0))
        linePath4.addLine(to: CGPoint(x: nowX, y: self.frame.height))
        
        linePath4.stroke()
        
        
        
        
    }
    
    var yAxisMax: CGFloat {
        let dayWorkOutFrom: DayWorkOutT = dayWorkList.object(at: 0) as! DayWorkOutT
        let dayWorkOutTo: DayWorkOutT = dayWorkList.object(at: dayWorkList.count-1) as! DayWorkOutT
        //print("最大 \(CGFloat(dayWorkOutFrom.mokuhyoWeight)) 最小 \(CGFloat(dayWorkOutTo.mokuhyoWeight))")
        return CGFloat(dayWorkOutFrom.mokuhyoWeight)-CGFloat(dayWorkOutTo.mokuhyoWeight)
    }
    
    
    //グラフ横幅を算出
    func checkWidth() -> CGFloat{
        print("dayWorkList.count \(dayWorkList.count)  \(memoriMargin) \(circleWidth)")
        print("最大 \(CGFloat(dayWorkList.count) * memoriMargin)")
        //return CGFloat(dayWorkList.count) * (memoriMargin + (circleWidth ))
        return CGFloat(dayWorkList.count) * memoriMargin
    }
    
    //グラフ縦幅を算出
    func checkHeight() -> CGFloat{
        return graphHeight
    }
        
    /*
    //メモリ値を表示
    func drawMemori()
    {
        let dayWorkOutTo: DayWorkOutT = dayWorkList.object(at: dayWorkList.count-1) as! DayWorkOutT
        let weightRange: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutTo.mokuhyoWeight)
        var y: CGFloat = -15
        var memori: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight)
        
        for i in 0..<15 {
        
            let memoriLabel = UILabel(frame:CGRect(x: -40, y: y, width: 40, height: 15))
            memoriLabel.text = "".appendingFormat("%.1f", memori) + "kg";
            memoriLabel.font = UIFont.systemFont(ofSize: 12)
            memoriLabel.textAlignment = NSTextAlignment.left
            memoriLabel.textColor = UIColor.black
            self.addSubview(memoriLabel)
            print("表示位置 \(y)　　メモリ値　\(memori)")
            y = y + graphHeight/10.0
            memori = memori - (weightRange/14.0)


        }
    }*/
    
}
