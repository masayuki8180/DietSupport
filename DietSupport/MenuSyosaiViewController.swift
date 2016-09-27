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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let label = UILabel(frame:CGRectMake(30, 100, 330, 25))
        label.text = "ダイエット期間　　" + appDelegate.selectedMenuT.kaishi + " 〜 " + appDelegate.selectedMenuT.syuryo;
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        self.view.addSubview(label)
        
        let label2 = UILabel(frame:CGRectMake(30, 135, 250, 25))
        label2.text = "目標体重　　 " + String(appDelegate.selectedMenuT.mokuHyoweight) + "Kg";
        label2.font = UIFont.systemFontOfSize(13)
        label2.textAlignment = NSTextAlignment.Left
        label2.textColor = UIColor.blackColor()
        self.view.addSubview(label2)

        /*
        fixBtn.backgroundColor = UIColor.blueColor()
        fixBtn.setTitle("ワークアウト結果の入力・確認", forState: UIControlState.Normal)
        fixBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fixBtn.titleLabel?.adjustsFontSizeToFitWidth = true
         */
    }

    @IBAction func workout(sender: UIButton){
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
        self.performSegueWithIdentifier("B", sender:nil)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

