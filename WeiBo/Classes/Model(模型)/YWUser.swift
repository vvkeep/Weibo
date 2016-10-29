
//
//  YWUser.swift
//  WeiBo
//
//  Created by yao wei on 16/9/20.
//  Copyright © 2016年 yao wei. All rights reserved.
//  微博用户模型

import UIKit

class YWUser: NSObject {

    /// 基本数据类型必须给初始值 否则不能使用KVC  private 也不可以使用KVC
    var id: Int64 = 0
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中国） 58 * 58 像素
    var profile_image_url: String?
    
    /// 认证类型 -1 没有认证 0 认证用户 235 企业用户 220 达人
    var verified_type: Int = 0
    
    /// 会员等级 0 - 6
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
}
