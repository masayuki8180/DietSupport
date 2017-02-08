//
//  LineDraw.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/12/13.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class LineDraw: UIView {
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    var endX: CGFloat = 0.0
    var endY: CGFloat = 0.0
    
    override func draw(_ rect: CGRect){
    
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        // 起点
        line.move(to: CGPoint(x: startX, y: startY));
        // 帰着点
        line.addLine(to: CGPoint(x: endX, y: endY));
        // ラインを結ぶ
        line.close()
        // 色の設定
        UIColor(red:ConstStruct.back_color_red , green:ConstStruct.back_color_green, blue:ConstStruct.back_color_blue,alpha:1.0).setStroke()
        // ライン幅
        line.lineWidth = 1
        // 描画
        line.stroke();
    }
}
