//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class WorkoutKakuninViewController: UIViewController {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var workoutList = NSMutableArray(array: [])
    fileprivate var scView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ワークアウトの確認"
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)

        
        workoutList = appDelegate.dbService.selectWorkoutT(appDelegate.selectedMenuT.menuNo)
        
        // ScrollViewを生成.
        scView = UIScrollView()
        
        // ScrollViewの大きさを設定する.
        scView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(scView)
        
        //let x:CGFloat = self.view.frame.width*0.1;
        let x:CGFloat = 0;
        var y:CGFloat = 10;
        let w:CGFloat = self.view.frame.width;
        let h:CGFloat = 200;
        for i in 0..<workoutList.count {
            let workoutT: WorkOutT = workoutList.object(at: i) as! WorkOutT
            self.displayWorkout(workoutT, x: x,y: y,w: w,h: h)
            y = y + 200 + 10
        }
        
        scView.contentSize = CGSize(width: self.view.frame.width, height: y)
        
        

    }
    
    func displayWorkout(_ workoutT:WorkOutT, x:CGFloat, y:CGFloat, w:CGFloat, h:CGFloat){
       
        let view:UIView = UIView(frame:CGRect(x: x, y: y, width: w, height: h));
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        view.layer.borderWidth = 1
        scView.addSubview(view);
        

        
        let y1: CGFloat = self.view.frame.height*0.014
        let workOUtNameLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: w,height: h/5))
        workOUtNameLabel.text = workoutT.workOUtName
        workOUtNameLabel.textAlignment = NSTextAlignment.center
        workOUtNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        workOUtNameLabel.textColor = UIColor.black
        workOUtNameLabel.layer.borderColor = UIColor(red:0.86 , green:0.86, blue:0.86,alpha:1.0).cgColor
        workOUtNameLabel.layer.borderWidth = 1
        view.addSubview(workOUtNameLabel)
        
        let imgView = UIImageView(frame: CGRect(x: w*0.08, y: y1+(h/4.5), width: w/8, height: w/8))
        let img = UIImage(named: workoutT.workOUtID.substring(to: workoutT.workOUtID.index(workoutT.workOUtID.startIndex, offsetBy: 2)))
        imgView.image = img
        view.addSubview(imgView)
        
        let y2: CGFloat = self.view.frame.height*0.014
        let workOUtValueLabel: UILabel = UILabel(frame: CGRect(x: w-(w/1.7),y: y1+(h/4),width: w/3,height: h/7))
        workOUtValueLabel.text = String(workoutT.workOUtValue) + workoutT.workOutValueName
        workOUtValueLabel.textColor = UIColor.black
        view.addSubview(workOUtValueLabel)
        
        //let y3: CGFloat = 10
        let workOUtCalLabel: UILabel = UILabel(frame: CGRect(x: w-(w/2.4),y: y1+(h/4),width: w/3,height: h/7))
        workOUtCalLabel.text = String(format: "%.1f", workoutT.workOUtCal * Double(workoutT.workOUtValue)) + "kcal"
        workOUtCalLabel.textAlignment = NSTextAlignment.center
        workOUtCalLabel.backgroundColor = UIColor(red:ConstStruct.cal_color_red , green:ConstStruct.cal_color_green, blue:ConstStruct.cal_color_blue,alpha:1.0)
        workOUtCalLabel.layer.cornerRadius = 8
        workOUtCalLabel.clipsToBounds = true
        workOUtCalLabel.textColor = UIColor.white
        view.addSubview(workOUtCalLabel)
        
        //let y4: CGFloat = 10
        let workOUtSetsumeiTV: UITextView = UITextView(frame: CGRect(x: w*0.05,y: y1+(h/5)+y2+(h/7)+(h/7),width: w*0.9,height: h/3))
        workOUtSetsumeiTV.text = workoutT.workOutSetsumei
        workOUtSetsumeiTV.font = UIFont.boldSystemFont(ofSize: CGFloat(17))
        workOUtSetsumeiTV.textColor = UIColor.darkGray
        view.addSubview(workOUtSetsumeiTV)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

