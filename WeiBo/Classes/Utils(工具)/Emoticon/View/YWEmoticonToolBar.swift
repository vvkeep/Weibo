//
//  CZEmoticonToolBar.swift
//  表情键盘
//
//  Created by 姚巍 on 16/11/6.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//  底部工具栏

import UIKit

class YWEmoticonToolBar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //重新布局按钮
        let count = subviews.count
        let w = bounds.width / CGFloat(count)

        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        for (i ,btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
    
}


fileprivate extension YWEmoticonToolBar {
    
    func setupUI() {
        let manager = YWEmoticonManager.shared
        
        for p in manager.packageArr {
            let btn = UIButton()
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            //设置按钮图片
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            guard let path = Bundle.main.path(forResource: "HMEmoticon", ofType: "bundle"),
                let bundle = Bundle(path: path) else {
                    return
            }
            let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
            let imageHL = UIImage(named: imageNameHL, in: bundle, compatibleWith: nil)

            //拉伸图像
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
            image?.resizableImage(withCapInsets: inset)
            imageHL?.resizableImage(withCapInsets: inset)
            
            
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)
            
            btn.sizeToFit()
            addSubview(btn)
        }
    }
}
