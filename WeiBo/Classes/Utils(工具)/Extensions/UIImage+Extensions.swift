//
//  UIImage+Extensions.swift
//  WeiBo
//
//  Created by yaowei on 2016/7/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 创建头像图像
    ///
    /// - parameter size:      尺寸
    /// - parameter backColor: 背景颜色
    ///
    /// - returns: 裁切后的图像
    func yw_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil || size?.width == 0 {
            size = CGSize(width: 34, height: 34)
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 1
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// 生成指定大小的不透明图象
    ///
    /// - parameter size:      尺寸
    /// - parameter backColor: 背景颜色
    ///
    /// - returns: 图像
    func yw_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}
