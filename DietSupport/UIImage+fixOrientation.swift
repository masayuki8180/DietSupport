//
//  UIImage+fixOrientation.swift
//  DietSupport
//
//  Created by kenji imoto on 2017/02/06.
//  Copyright © 2017年 TMS. All rights reserved.
//

import UIKit

extension UIImage {
    func fixOrientation () -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform()
        let width = self.size.width
        let height = self.size.height
        
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
        default: // o.Up, o.UpMirrored:
            break
        }
        
        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: // o.Up, o.Down, o.Left, o.Right
            break
        }
        let cgimage = self.cgImage
        
        let ctx = CGContext(data: nil, width: Int(width), height: Int(height),
                                        bitsPerComponent: (cgimage?.bitsPerComponent)!, bytesPerRow: 0,
                                        space: (cgimage?.colorSpace!)!,
                                        bitmapInfo: (cgimage?.bitmapInfo.rawValue)!)
        
        ctx?.concatenate(transform)
        
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgimage!, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            ctx?.draw(cgimage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        let cgimg = ctx?.makeImage()
        let img = UIImage(cgImage: cgimg!)
        return img
    }
}
