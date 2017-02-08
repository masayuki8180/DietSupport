//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import Foundation

class MenuT: NSObject {    
    var menuNo:Int = 0
    var sakuseibi:String = ""
    var kaishi:String = ""
    var syuryo:String = ""
    var kaishiWeight:Double = 0
    var mokuHyoweight:Double = 0
    var jyutenSyubetsu:Int = 0
    var kiboCategory:String = ""
    var workOut:NSMutableArray? = nil
    var gazo:Data = Data()
}
