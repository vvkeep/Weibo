//
//  YWComposeTextView.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/22.
//  Copyright © 2016年 yao wei. All rights reserved.
//  撰写微博的文本视图

import UIKit

class YWComposeTextView: UITextView {

    /// 占位label
    fileprivate lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        steupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
    
    @objc fileprivate func textChanged(){
    //如果有文本就不显示label
        placeholderLabel.isHidden = hasText
    }
}


fileprivate extension YWComposeTextView{
    func steupUI() {
        //1.设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
    }
}
