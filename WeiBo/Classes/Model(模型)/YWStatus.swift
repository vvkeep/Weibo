//
//  YWStatus.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/15.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit
import YYModel

class YWStatus: NSObject {

    /// Int 类型 在64位的机器上是64位 在32位的机器上是32位的
    ///如果不写 Int64 在iPad 2/iphone5/5c/4s/4 都是无法正常运行的
    var id: Int64 = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博用户
    var user: YWUser?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 点赞数
    var attitudes_count: Int = 0
    
    /// 创建时间
    var created_at: String?
    
    /// 微博来源 - 发布的客户端
    var source: String? {
        didSet {
            ///设置微博来源
            source = "来自" + (source?.yw_href()?.text ?? "未知")
        }
    }
    
    /// 微博配图模型数组
    var pic_urls: [YWStatusPictures]?
    
    /// 被转发微博
    var retweeted_status: YWStatus?
    
    ///重写 description 的计算性属性
    override var description: String {
        return yy_modelDescription()
    }
    
    //容器类（如果遇到数组类型的属性，告诉YY_model 数组中存放的对象是什么类）
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": YWStatusPictures.self]
    }
}


/// 微博配图模型
class YWStatusPictures: NSObject {
    
    /// 缩略图地址
    var thumbnail_pic: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
