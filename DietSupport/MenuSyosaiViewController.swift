//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class MenuSyosaiViewController: UIViewController {

    //@IBOutlet weak var fixBtn: UIButton!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "メニュー";
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        self.view.backgroundColor = UIColor.white
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "削除", style: .plain, target: self, action: #selector(MenuSyosaiViewController.onClickRightButton(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
        
        /*
        let label = UILabel(frame:CGRect(x: 30, y: 100, width: 330, height: 25))
        label.text = "ダイエット期間　　" + appDelegate.selectedMenuT.kaishi + " 〜 " + appDelegate.selectedMenuT.syuryo;
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        let label2 = UILabel(frame:CGRect(x: 30, y: 135, width: 250, height: 25))
        label2.text = "目標体重　　 " + String(appDelegate.selectedMenuT.mokuHyoweight) + "Kg";
        label2.font = UIFont.systemFont(ofSize: 13)
        label2.textAlignment = NSTextAlignment.left
        label2.textColor = UIColor.black
        self.view.addSubview(label2)

        let fixBtn = UIButton()
        fixBtn.frame = CGRect(x: 300, y: 500, width: 50, height: 50)
        fixBtn.backgroundColor = UIColor.blue
        fixBtn.setTitle("通信テスト", for: UIControlState())
        fixBtn.setTitleColor(UIColor.white, for: UIControlState())
        fixBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        fixBtn.addTarget(self, action:#selector(MenuSyosaiViewController.test(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(fixBtn)
        */
    }

    @IBAction func workout(_ sender: UIButton){
        //let calViewController = CalViewController()
        //self.navigationController?.pushViewController(calViewController, animated: true)
        //let mySecondViewController = UIStoryboard(name: "calViewController", bundle: nil).instantiateViewControllerWithIdentifier("next") as UIViewController
        //let _view2 = self.storyboard!.instantiateViewControllerWithIdentifier("calViewController") as UIViewController
        //self.navigationController?.pushViewController(_view2, animated: true)
        
        //let nex : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("calViewController")
        //self.presentViewController(nex as! UIViewController, animated: true, completion: nil)
        
        //let pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("calViewController") as! CalViewController
        //self.navigationController?.pushViewController(pageViewController, animated: true)
        //self.performSegueWithIdentifier("calViewController", sender:self)
        self.performSegue(withIdentifier: "B", sender:nil)
    }
    
    func onClickRightButton(_ sender: UIButton){
        MyAlertController.show(presentintViewController: self, title: "", message: "このメニューを削除してもよろしいですか？\n\n削除したメニューを元に戻すことはできません。",cancelTitle: "いいえ", acceptTitle: "はい"){ action in
            switch action {
            case .ok :  self.appDelegate.dbService.deleteMenuT(self.appDelegate.selectedMenuT.menuNo)
                        self.appDelegate.dbService.deleteWorkoutT(self.appDelegate.selectedMenuT.menuNo)
                        self.appDelegate.dbService.deleteDayWorkoutT(self.appDelegate.selectedMenuT.menuNo)
                        self.navigationController?.popViewController(animated: true)
                        break
            case .cancel :break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

