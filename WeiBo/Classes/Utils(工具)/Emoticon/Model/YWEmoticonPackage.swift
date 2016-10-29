//
//  YWEmoticonPackage.swift
//  表情包Demo
//
//  Created by 姚巍 on 16/10/15.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//  表情包模型

import UIKit
import YYModel
class YWEmoticonPackage: NSObject {
    
    /// 表情包的分组名
    var groupName: String?
    
    /// 表情包目录，从目录下加载info.plist 可以创建表情模型数组
    var directory: String?{
        //当设置目录时候，从目录下加载 info.plist
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info", ofType: "plist", inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String: String]],
                let modelArr = NSArray.yy_modelArray(with: YWEmoticon.self, json: array) as? [YWEmoticon]else {
                    return
            }
            //遍历modelArr 数组，设置每一个表情符号的目录
            for m in modelArr {
                m.directory = directory;
            }
            //设置表情模型数组
            emoticonArr += modelArr
            print(emoticonArr.count)
        }
    }
    
    /// 懒加载表情模型空数组，使用懒加载可以避免后续的解包
    lazy var emoticonArr = [YWEmoticon]()
    
    override var description: String{
        return yy_modelDescription()
    }
}
