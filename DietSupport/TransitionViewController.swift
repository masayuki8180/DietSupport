//
//  ViewController.swift
//  DietSupport
//
//  Created by TMS on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {

    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     @IBOutlet weak var scview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let graphview = Graph() //グラフを表示するクラス
        scview.addSubview(graphview) //グラフをスクロールビューに配置
        graphview.drawLineGraph() //グラフ描画開始
        graphview.drawMemori()
        
        scview.contentSize = CGSize(width:graphview.checkWidth()+250, height:graphview.checkHeight()) //スクロールビュー内のコンテンツサイズ設定
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

