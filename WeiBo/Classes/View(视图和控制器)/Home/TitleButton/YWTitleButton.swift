





//
//  YWTitleButton.swift
//  WeiBo
//
//  Created by yao wei on 16/9/18.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWTitleButton: UIButton {
    
    //重载构造函数 title 如果是nil 就显示“首页” 否则显示title 和箭头图像
    init(title: String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            
            setTitle(title!, for: .normal)
        }
        
        //默认 17 粗细
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)

//        titleEdgeInsets = UIEdgeInsetsMake(0, -14.5, 0, 0)
//        //FIXME: 最后的值也有问题 不知什么原因
//        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -2*95)
        sizeToFit()

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //FIXME: 垃圾移动 bug 改不了
    //重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel,
            let imageView = imageView else {
                return
        }
        
        
        //OC中不可以修改结构体中的值
        //Swift中可以直接修改
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width + 2.0
        print("移动之前\(titleLabel,imageView)")
        
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        //
        print("移动之后\(titleLabel,imageView)")
    }
    
}
