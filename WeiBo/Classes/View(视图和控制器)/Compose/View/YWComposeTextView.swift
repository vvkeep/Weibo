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
    
    /// 计算型属性 返回 textview 对用的纯文本文字
    var emoticonText: String {
        //获取textView 的属性文本
        guard let attrStr = attributedText else {
            return ""
        }
        //需要获取属性文本的图片 [附件 attachment]
        /**
         1. 遍历的范围
         2. 选项数组
         3. 闭包
         */
        var result = String()
        attrStr.enumerateAttributes(in: NSRange(location: 0, length: attrStr.length), options: [], using: { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? YWEmoticonAttachment {
                result += attachment.chs ?? ""
            } else {
                let subStr = (attrStr.string as NSString).substring(with: range)
                result += subStr
            }
        })
        return result
    }
    
    override func awakeFromNib() {
        steupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
    
    @objc fileprivate func textChanged(){
    //如果有文本就不显示label
        placeholderLabel.isHidden = hasText
    }
}
///表情键盘专属
extension YWComposeTextView {
    /// 向文本视图插入表情符号
    func insterEmoticon(em: YWEmoticon?) {
        //1. em = nil 是删除按钮
        guard let em = em else {
            deleteBackward()
            return
        }
        
        // emoji 字符串
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        
        //图片
        let imageText = em.imageText(font: font!)
        
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        
        //重新设置属性文本
        //记录光标位置
        let range = selectedRange
        
        attributedText = attrStrM
        //恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
        //去除占位文本
        textChanged()
        //激活发送按钮
        delegate?.textViewDidChange?(self)
        
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
