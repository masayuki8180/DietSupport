//
//  Graph.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/08/12.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class Graph: UIView {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var lineWidth:CGFloat = 3.0 //グラフ線の太さ
    var lineColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:0.7) //グラフ線の色
    var circleWidth:CGFloat = 4.0 //円の半径
    var circleColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:0.7) //円の色
    
    var lineColor2:UIColor = UIColor(red:0.80,  green:0.00,  blue:0.00, alpha:1) //グラフ線の色
    var circleColor2:UIColor = UIColor(red:0.80,  green:0.00,  blue:0.00, alpha:1) //円の色
    
    var memoriMargin: CGFloat = 40 //横目盛の感覚
    var graphHeight: CGFloat = 300 //グラフの高さ
    var graphPoints: [String] = []
    var dayWorkList:NSMutableArray = []
    var graphDatas: [CGFloat] = []
    var svWidth: CGFloat = 0
    
    func drawLineGraph()
    {
        dayWorkList = appDelegate.dbService.selectDayWorkoutT(appDelegate.selectedMenuT.menuNo)
        graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
        graphDatas = [100, 30, 10, -50, 90, 12, 40]
        
        GraphFrame()
        MemoriGraphDraw()
    }
    
    //グラフを描画するviewの大きさ
    func GraphFrame(){
        self.backgroundColor = UIColor(red:0.972,  green:0.973,  blue:0.972, alpha:1)
        self.frame = CGRectMake(40 , 0, checkWidth(), checkHeight())
    }
    
    //横目盛・グラフを描画する
    func MemoriGraphDraw() {
        
        var count:CGFloat = 0
        for memori in dayWorkList {
            
            let label = UILabel()
            let dayWorkOutT : DayWorkOutT = memori as! DayWorkOutT
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let date: NSDate! = formatter.dateFromString(dayWorkOutT.day)
            formatter.dateFormat = "M/d"
            //let dateString = formatter.stringFromDate(date)

            label.text = formatter.stringFromDate(date)
            label.font = UIFont.systemFontOfSize(9)
            
            //ラベルのサイズを取得
            let frame = CGSizeMake(250, CGFloat.max)
            let rect = label.sizeThatFits(frame)
            
            //ラベルの位置
            var lebelX = (count * memoriMargin)-rect.width/2
            
            //最初のラベル
            if Int(count) == 0{
                lebelX = (count * memoriMargin)
            }
            
            //最後のラベル
            if Int(count+1) == dayWorkList.count{
                lebelX = (count * memoriMargin)-rect.width
                svWidth = lebelX
                print("横幅 \(svWidth)")
            }
            
            label.frame = CGRectMake(lebelX , graphHeight, rect.width, rect.height)
            self.addSubview(label)
            
            count += 1
        }
    }
    

    //グラフの線を描画
    override func drawRect(rect: CGRect) {
        
        var count:CGFloat = 0
        var weightSa:CGFloat = 0
        var ruisekiWeightSa:CGFloat = 0
        let linePath = UIBezierPath()
        var myCircle = UIBezierPath()
        
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        
        //let dayWorkOutFrom: DayWorkOutT = dayWorkList.objectAtIndex(0) as! DayWorkOutT
        //let mokuhyoWeight: CGFloat = CGFloat(dayWorkOutFrom.mokuhyoWeight)
        let dayWorkOutTo: DayWorkOutT = dayWorkList.objectAtIndex(dayWorkList.count-1) as! DayWorkOutT
        let weightRange: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutTo.mokuhyoWeight)
        print("全体の範囲 \(weightRange)")
        for datapoint in dayWorkList {
            if Int(count+1) < dayWorkList.count {
                let dayWorkOutT : DayWorkOutT = datapoint as! DayWorkOutT
                let nowY: CGFloat = ((CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.mokuhyoWeight))/weightRange) * (graphHeight - circleWidth)
                //print("現在値 \(CGFloat(appDelegate.selectedMenuT.kaishiWeight)) \(CGFloat(dayWorkOutT.mokuhyoWeight)) nowY \(nowY)")
                //print("元 \(CGFloat(dayWorkOutT.mokuhyoWeight)) 更新 \(nowY) mokuhyoWeight \(mokuhyoWeight)")
                //nowY = graphHeight - nowY
                
                /*
                if(graphDatas.minElement()!<0){
                    nowY = (datapoint - graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY = graphHeight - nowY
                }*/
                
                //次のポイントを計算
                var nextY: CGFloat = 0
                //nextY = CGFloat(dayWorkOutT.mokuhyoWeight)/mokuhyoWeight * (graphHeight - circleWidth)
                nextY = ((CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.mokuhyoWeight))/weightRange) * (graphHeight - circleWidth)
                //nextY = graphHeight - nextY
                
                /*
                if(graphDatas.minElement()!<0){
                    nextY = (graphDatas[Int(count+1)] - graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                    nextY = graphHeight - nextY - circleWidth
                }*/
                
                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if Int(count) == 0 {
                    linePath.moveToPoint(CGPoint(x: count * memoriMargin + circleWidth, y: nowY))
                    circlePoint = CGPoint(x: count * memoriMargin + circleWidth, y: nowY)
                    print("円の位置 \(nextY)")
                    myCircle = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                    circleColor.setFill()
                    myCircle.fill()
                    myCircle.stroke()
                    
                    weightSa = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.mokuhyoWeight)
                    ruisekiWeightSa = weightSa*2
                    nextY = (ruisekiWeightSa/weightRange) * (graphHeight - circleWidth)
                }else{
                    ruisekiWeightSa = ruisekiWeightSa+weightSa
                    nextY = (ruisekiWeightSa/weightRange) * (graphHeight - circleWidth)
                }
                
                //描画ポイントを指定
                linePath.addLineToPoint(CGPoint(x: (count+1) * memoriMargin, y: nextY))
                //円をつくる
                print("円の位置 x \((count+1) * memoriMargin) y \(nextY)")
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
                
                if Int(count) == 0 {
                    
                }
                
            }
            
            count += 1
            
        }
        linePath.stroke()
 
        var count2:CGFloat = 0
        let linePath2 = UIBezierPath()
        var myCircle2 = UIBezierPath()
        
        linePath2.lineWidth = lineWidth
        lineColor2.setStroke()
        
        for datapoint in dayWorkList {
            //print("線をひく \(count2)")
            if Int(count2+1) < dayWorkList.count {
                //print("線をひく \(count2)")
                let dayWorkOutT : DayWorkOutT = datapoint as! DayWorkOutT
                if dayWorkOutT.weight > 0 {
                    /*
                    var nowY: CGFloat = CGFloat(dayWorkOutT.weight)/mokuhyoWeight * (graphHeight - circleWidth)
                    print("結果体重が1以上なので　元 \(CGFloat(dayWorkOutT.weight)) 更新 \(nowY)")
                    nowY = graphHeight - nowY
                    */
                    let nowY: CGFloat = ((CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.weight))/weightRange) * (graphHeight - circleWidth)
                    
                    /*
                     if(graphDatas.minElement()!<0){
                     nowY = (datapoint - graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                     nowY = graphHeight - nowY
                     }*/
                    
                    //次のポイントを計算
                    var nextY: CGFloat = 0
                    nextY = ((CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutT.weight))/weightRange) * (graphHeight - circleWidth)
                    
                    /*
                     if(graphDatas.minElement()!<0){
                     nextY = (graphDatas[Int(count+1)] - graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                     nextY = graphHeight - nextY - circleWidth
                     }*/
                    
                    //最初の開始地点を指定
                    var circlePoint:CGPoint = CGPoint()
                    print("線をひく \(count2)")
                    if Int(count2) == 0 {
                        linePath2.moveToPoint(CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY))
                        circlePoint = CGPoint(x: count2 * memoriMargin + circleWidth, y: nowY)
                        myCircle2 = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                        circleColor2.setFill()
                        myCircle2.fill()
                        myCircle2.stroke()
                    }
                    
                    //描画ポイントを指定
                    print("線をひく \((count2+1) * memoriMargin) 更新 \(nextY)")
                    linePath2.addLineToPoint(CGPoint(x: (count2+1) * memoriMargin, y: nextY))
                    
                    //円をつくる
                    circlePoint = CGPoint(x: (count2+1) * memoriMargin, y: nextY)
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
                    
                    count2 += 1
                }
                
            }
            

            
        }
        linePath2.stroke()
    }
 
    
    // 保持しているDataの中で最大値と最低値の差を求める
    
    var yAxisMax: CGFloat {
        let dayWorkOutFrom: DayWorkOutT = dayWorkList.objectAtIndex(0) as! DayWorkOutT
        let dayWorkOutTo: DayWorkOutT = dayWorkList.objectAtIndex(dayWorkList.count-1) as! DayWorkOutT
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
    
    func checkSvWidth() -> CGFloat{
        //print("最大 \(svWidth)")
        return svWidth
    }
    
    //グラフ縦幅を算出
    func checkHeight() -> CGFloat{
        return graphHeight
    }
    
    //メモリ値を表示
    func drawMemori()
    {
        let dayWorkOutTo: DayWorkOutT = dayWorkList.objectAtIndex(dayWorkList.count-1) as! DayWorkOutT
        let weightRange: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight) - CGFloat(dayWorkOutTo.mokuhyoWeight)
        var y: CGFloat = -15
        var memori: CGFloat = CGFloat(appDelegate.selectedMenuT.kaishiWeight)
        
        for i in 0..<11 {
        
            let memoriLabel = UILabel(frame:CGRectMake(-40, y, 40, 15))
            memoriLabel.text = "".stringByAppendingFormat("%.1f", memori) + "kg";
            memoriLabel.font = UIFont.systemFontOfSize(12)
            memoriLabel.textAlignment = NSTextAlignment.Left
            memoriLabel.textColor = UIColor.blackColor()
            self.addSubview(memoriLabel)
            print("表示位置 \(y)　　メモリ値　\(memori)")
            y = y + graphHeight/10.0
            memori = memori - (weightRange/10.0)


        }
    }
    
}