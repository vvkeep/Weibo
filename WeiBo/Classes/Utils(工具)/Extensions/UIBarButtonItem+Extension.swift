//
//  UIBarButtonItem+Extension.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/11.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    
    /// 创建 UINavgationBarButtonItem
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize = 16
    /// - parameter target:   target
    /// - parameter action:   action
    ///
    /// - returns: UIBarButtonItem
    convenience init(title: String,fontSize :CGFloat = 16,target: AnyObject,action: Selector,isBack: Bool = false) {
          //Swift 调用 OC 返回 instancetype 的方法 判断不出是否可选
        let btn :UIButton = UIButton.yw_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        let imageName = "navigationbar_back_withtext"
        if isBack {
            btn.setImage(UIImage(named:imageName), for: .normal)
            btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
    }
}
