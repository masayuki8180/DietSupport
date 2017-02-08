//
//  BalloonView.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/12/20.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

class BalloonView: UIView {
    
    let triangleLength: CGFloat = UIScreen.main.bounds.size.width*0.053
    let labelRange: CGFloat = UIScreen.main.bounds.size.width*0.0266
    fileprivate var trianglePosition: CGFloat = 0.0
    fileprivate var trianglePositionMode = 0
    fileprivate var text: String = ""
    //let triangleHeight: CGFloat = 17.3
    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        
        
        let context = UIGraphicsGetCurrentContext()
        //context?.setFillColor(UIColor(red:0.12 , green:0.56, blue:1.0,alpha:1.0).cgColor)
        context?.setFillColor(UIColor.gray.cgColor)
        contextBalloonPath(context!, rect: rect)
        
        if trianglePositionMode != 0 {
            let balloonLabel: UILabel = UILabel(frame: CGRect(x: triangleLength+labelRange,y: triangleLength+labelRange,width: rect.width-((triangleLength*2)+(labelRange*2)),height: rect.height-((triangleLength*2)+(labelRange*2))))
            balloonLabel.textAlignment = .left
            balloonLabel.text = text
            balloonLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(15))
            balloonLabel.numberOfLines = 0
            balloonLabel.textColor = UIColor.white
            balloonLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(balloonLabel)
        }else{
            //let balloonLabel: UILabel = UILabel(frame: CGRect(x: triangleLength+labelRange,y: triangleLength+(labelRange*2),width: rect.width-((triangleLength*2)+(labelRange*2)),height: rect.height-((triangleLength*2)+(labelRange*2))))
            let balloonLabel: UILabel = UILabel(frame: CGRect(x: triangleLength+triangleLength,y: triangleLength+triangleLength+(UIScreen.main.bounds.size.height*0.022),width: rect.width-((triangleLength*2)+(triangleLength*2)),height: rect.height-((triangleLength*2)+(triangleLength*2))))
            balloonLabel.textAlignment = .left
            balloonLabel.text = text
            balloonLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(15))
            balloonLabel.numberOfLines = 0
            balloonLabel.textColor = UIColor.white
            balloonLabel.adjustsFontSizeToFitWidth = true
            //balloonLabel.backgroundColor = UIColor.yellow
            self.addSubview(balloonLabel)
        }
    }
    
    func setTrianglePosition(_ mode: Int, position: CGFloat){
        trianglePositionMode = mode
        trianglePosition = position
    }
    
    func setText(_ inText: String){
        text = inText
    }
    
    func setEvent(){
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.viewTapped(_:))))
    }
    
    func viewTapped(_ sender: UIView){
        self.removeFromSuperview()
    }
    
    func contextBalloonPath(_ context: CGContext, rect: CGRect) {
        
        if trianglePositionMode != 0 {
            var triangleRightCorner: CGPoint = CGPoint()
            var triangleBottomCorner: CGPoint = CGPoint()
            var triangleLeftCorner: CGPoint = CGPoint()
            
            if trianglePositionMode == 1{
                triangleLeftCorner = CGPoint(x: trianglePosition, y: triangleLength)
                triangleBottomCorner = CGPoint(x: trianglePosition+(triangleLength/2), y: 0)
                triangleRightCorner = CGPoint(x: trianglePosition+triangleLength, y: triangleLength)
            }else if trianglePositionMode == 2{
                triangleLeftCorner = CGPoint(x: rect.width-triangleLength, y: trianglePosition)
                triangleBottomCorner = CGPoint(x: rect.width, y: trianglePosition+(triangleLength/2))
                triangleRightCorner = CGPoint(x: rect.width-triangleLength, y: trianglePosition+triangleLength)
            }else if trianglePositionMode == 3{
                triangleRightCorner = CGPoint(x: (rect.size.width + triangleLength) / 2, y: rect.height - triangleLength)
                triangleBottomCorner = CGPoint(x: rect.size.width / 2, y: rect.height)
                triangleLeftCorner = CGPoint(x: (rect.size.width - triangleLength) / 2, y: rect.height - triangleLength)
            }else if trianglePositionMode == 4{
                triangleLeftCorner = CGPoint(x: triangleLength, y: trianglePosition)
                triangleBottomCorner = CGPoint(x: 0, y: trianglePosition+(triangleLength/2))
                triangleRightCorner = CGPoint(x: triangleLength, y: trianglePosition+triangleLength)
            }
            
            context.move(to: CGPoint(x: triangleLeftCorner.x, y: triangleLeftCorner.y))
            context.addLine(to: CGPoint(x: triangleBottomCorner.x, y: triangleBottomCorner.y))
            context.addLine(to: CGPoint(x: triangleRightCorner.x, y: triangleRightCorner.y))
            context.setShadow(offset: CGSize(width: 2.0, height: 2.0), blur: 5.0)
            context.fillPath()
        }else{
            let hintLabel: UILabel = UILabel(frame: CGRect(x: triangleLength+labelRange,y: triangleLength+labelRange,width: UIScreen.main.bounds.size.width*0.14,height: UIScreen.main.bounds.size.height*0.025))
            hintLabel.textAlignment = .center
            hintLabel.text = "ヒント"
            hintLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(15))
            hintLabel.textColor = UIColor.gray
            hintLabel.backgroundColor = UIColor.white
            hintLabel.layer.cornerRadius = 5
            hintLabel.adjustsFontSizeToFitWidth = true
            hintLabel.clipsToBounds = true
            self.addSubview(hintLabel)
        }
        
        context.addRect(CGRect(x: triangleLength,y: triangleLength,width: rect.width-(triangleLength*2),height: rect.height-(triangleLength*2)))
        context.setShadow(offset: CGSize(width: 2.0, height: 2.0), blur: 5.0)
        context.fillPath()

    }
    
}
