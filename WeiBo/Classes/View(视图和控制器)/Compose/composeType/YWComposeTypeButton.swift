//
//  YWComposeTypeButton.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/5.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    //点击按钮展示控制器的类型
    var clsName: String?
    
    /// 使用图像名称、标题创建按钮， 按钮布局从xib加载
    class func composeTypeButton(imageName:String, title: String) ->YWComposeTypeButton {
      let btn = UINib(nibName: "YWComposeTypeButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YWComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLab.text = title
        
        return btn
    }

}
