//
//  RiyoKiyakuViewController.swift
//  DietSupport
//
//  Created by TMS on 2017/01/18.
//  Copyright © 2017年 TMS. All rights reserved.
//

import UIKit

class RiyoKiyakuViewController: UIViewController {
    
    @IBOutlet weak var kiyakuTV: UITextView!
    var mode:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "利用規約";
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        kiyakuTV.text = ConstStruct.kiyaku
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

