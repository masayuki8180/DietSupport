//
//  PrivacyPolicyViewController.swift
//  DietSupport
//
//  Created by TMS on 2017/01/18.
//  Copyright © 2017年 TMS. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var poricyTV: UITextView!
    var mode:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "プライバシーポリシー";
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        self.view.backgroundColor = UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0)
        
        poricyTV.text = ConstStruct.privacy_policy
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

