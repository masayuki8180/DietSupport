//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuMake2ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var jyutenBtn: UIButton!
    var jyutenBtn2: UIButton!
    var jyutenBtn3: UIButton!
    var jyutenPicker: UIPickerView! = nil
    var jyutenArr: NSArray = ["お腹","腰周り","太もも"]
    var jyutenSelected:Int = 0
    var jyutenSelected2:Int = 0
    var jyutenSelected3:Int = 0
    
    var workGroupBtn: UIButton!
    var workGroupBtn2: UIButton!
    var workGroupBtn3: UIButton!
    var workGroupPicker: UIPickerView! = nil
    var workGroupArr: NSArray = ["筋トレ","ヨガ","ジョギング"]
    var workGroupSelected:Int = 0
    var workGroupSelected2:Int = 0
    var workGroupSelected3:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        self.view.backgroundColor = UIColor.white
        
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MenuMakeViewController.viewTapped(_:))))

        let button = UIButton(frame: CGRect(x: 260, y: 100, width: 30, height: 30))
        let buttonImage:UIImage = UIImage(named: "nextBtn.png")!
        button.setBackgroundImage(buttonImage, for: UIControlState())
        button.addTarget(self, action:#selector(MenuMakeViewController.next(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        let label = UILabel(frame:CGRect(x: 50, y: 140, width: 200, height: 25))
        label.text = "重点的に改善したい部位";
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        jyutenBtn = UIButton(frame: CGRect(x: 50, y: 170, width: 150, height: 30))
        jyutenBtn.backgroundColor = UIColor.lightGray
        jyutenBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        jyutenBtn.setTitle("\(jyutenArr[0])", for: UIControlState())
        jyutenBtn.tag = 1
        jyutenBtn.addTarget(self, action:#selector(MenuMake2ViewController.jyutenSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(jyutenBtn)
        
        jyutenBtn2 = UIButton(frame: CGRect(x: 50, y: 210, width: 150, height: 30))
        jyutenBtn2.backgroundColor = UIColor.lightGray
        jyutenBtn2.titleLabel?.adjustsFontSizeToFitWidth = true
        jyutenBtn2.setTitle("\(jyutenArr[0])", for: UIControlState())
        jyutenBtn2.tag = 2
        jyutenBtn2.addTarget(self, action:#selector(MenuMake2ViewController.jyutenSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(jyutenBtn2)
        
        jyutenBtn3 = UIButton(frame: CGRect(x: 50, y: 250, width: 150, height: 30))
        jyutenBtn3.backgroundColor = UIColor.lightGray
        jyutenBtn3.titleLabel?.adjustsFontSizeToFitWidth = true
        jyutenBtn3.setTitle("\(jyutenArr[0])", for: UIControlState())
        jyutenBtn3.tag = 3
        jyutenBtn3.addTarget(self, action:#selector(MenuMake2ViewController.jyutenSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(jyutenBtn3)
        
        
        let label2 = UILabel(frame:CGRect(x: 50, y: 300, width: 250, height: 25))
        label2.text = "希望するワークアウトの種類";
        label2.font = UIFont.systemFont(ofSize: 17)
        label2.textAlignment = NSTextAlignment.left
        label2.textColor = UIColor.black
        self.view.addSubview(label2)
        
        workGroupBtn = UIButton(frame: CGRect(x: 50, y: 330, width: 150, height: 30))
        workGroupBtn.backgroundColor = UIColor.lightGray
        workGroupBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        workGroupBtn.setTitle("\(workGroupArr[0])", for: UIControlState())
        workGroupBtn.tag = 1
        workGroupBtn.addTarget(self, action:#selector(MenuMake2ViewController.workGroupSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(workGroupBtn)
        
        workGroupBtn2 = UIButton(frame: CGRect(x: 50, y: 370, width: 150, height: 30))
        workGroupBtn2.backgroundColor = UIColor.lightGray
        workGroupBtn2.titleLabel?.adjustsFontSizeToFitWidth = true
        workGroupBtn2.setTitle("\(workGroupArr[0])", for: UIControlState())
        workGroupBtn2.tag = 2
        workGroupBtn2.addTarget(self, action:#selector(MenuMake2ViewController.workGroupSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(workGroupBtn2)
        
        workGroupBtn3 = UIButton(frame: CGRect(x: 50, y: 410, width: 150, height: 30))
        workGroupBtn3.backgroundColor = UIColor.lightGray
        workGroupBtn3.titleLabel?.adjustsFontSizeToFitWidth = true
        workGroupBtn3.setTitle("\(workGroupArr[0])", for: UIControlState())
        workGroupBtn3.tag = 3
        workGroupBtn3.addTarget(self, action:#selector(MenuMake2ViewController.workGroupSelected(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(workGroupBtn3)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func next(_ sender: UIButton){
        let menuSelectViewController = MenuSelectViewController()
        self.navigationController?.pushViewController(menuSelectViewController, animated: true)
    }
    
    func jyutenSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(jyutenPicker != nil){
            jyutenPicker.removeFromSuperview()
            jyutenPicker = nil
            print("jyutenPickerをお掃除")
        }
        
        jyutenPicker = UIPickerView()
        jyutenPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        jyutenPicker.backgroundColor = UIColor.white
        jyutenPicker.layer.cornerRadius = 5.0
        jyutenPicker.layer.shadowOpacity = 0.5
        jyutenPicker.delegate = self
        jyutenPicker.dataSource = self
        jyutenPicker.tag = sender.tag
        if(sender.tag == 1){
            jyutenPicker.selectRow(jyutenSelected, inComponent: 0, animated: true)
        }else if(sender.tag == 2){
            jyutenPicker.selectRow(jyutenSelected2, inComponent: 0, animated: true)
        }else if(sender.tag == 3){
            jyutenPicker.selectRow(jyutenSelected3, inComponent: 0, animated: true)
        }
        self.view.addSubview(jyutenPicker)
    }
    
    func workGroupSelected(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if(workGroupPicker != nil){
            workGroupPicker.removeFromSuperview()
            workGroupPicker = nil
            print("workGroupPickerをお掃除")
        }
        
        workGroupPicker = UIPickerView()
        workGroupPicker.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        workGroupPicker.backgroundColor = UIColor.white
        workGroupPicker.layer.cornerRadius = 5.0
        workGroupPicker.layer.shadowOpacity = 0.5
        workGroupPicker.delegate = self
        workGroupPicker.dataSource = self
        workGroupPicker.tag = sender.tag + 3
        if(sender.tag == 1){
            workGroupPicker.selectRow(workGroupSelected, inComponent: 0, animated: true)
        }else if(sender.tag == 2){
            workGroupPicker.selectRow(workGroupSelected2, inComponent: 0, animated: true)
        }else if(sender.tag == 3){
            workGroupPicker.selectRow(workGroupSelected3, inComponent: 0, animated: true)
        }
        self.view.addSubview(workGroupPicker)
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var value:Int = 0
        if(pickerView.tag <= 3){
            value = 3
        }else{
            value = 3
        }
        return value
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        var str:String = ""
        if(pickerView.tag <= 3){
            str = jyutenArr[row] as! String
        }else{
            str = workGroupArr[row] as! String
        }

        return str
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("値: \(jyutenArr[row])")
        if(pickerView.tag <= 3){
            if(pickerView.tag == 1){
                jyutenSelected = row
                jyutenBtn.setTitle(jyutenArr[row] as? String, for: UIControlState())
            }else if(pickerView.tag == 2){
                jyutenSelected2 = row
                jyutenBtn2.setTitle(jyutenArr[row] as? String, for: UIControlState())
            }else if(pickerView.tag == 3){
                jyutenSelected3 = row
                jyutenBtn3.setTitle(jyutenArr[row] as? String, for: UIControlState())
            }
        }else{
            if(pickerView.tag == 4){
                workGroupSelected = row
                workGroupBtn.setTitle(workGroupArr[row] as? String, for: UIControlState())
            }else if(pickerView.tag == 5){
                workGroupSelected2 = row
                workGroupBtn2.setTitle(workGroupArr[row] as? String, for: UIControlState())
            }else if(pickerView.tag == 6){
                workGroupSelected3 = row
                workGroupBtn3.setTitle(workGroupArr[row] as? String, for: UIControlState())
            }
        }
    }
    
    func viewTapped(_ sender: UIView){
        
        if(jyutenPicker != nil){
            jyutenPicker.removeFromSuperview()
            jyutenPicker = nil
            print("jyutenPickerをお掃除")
        }
        
        if(workGroupPicker != nil){
            workGroupPicker.removeFromSuperview()
            workGroupPicker = nil
            print("workGroupPickerをお掃除")
        }
    }

}

