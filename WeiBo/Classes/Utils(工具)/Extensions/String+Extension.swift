
//
//  String+Extension.swift
//  正则体验
//
//  Created by 姚巍 on 16/10/7.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import Foundation
extension String {
    /// 从当前的字符串中，提取链接和文本
    /// Swift中提供了’元祖‘，同时返回多个值
    /// OC 中可以返回字典，或者自定义对象，也可以用指针的指针
    func yw_href() -> ((link: String, text: String))? {
        //匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        // 创建正则表达式
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result =  regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))else {
                return nil
        }
        //获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return(link,text)
    }
}
