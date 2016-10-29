//
//  YWWeiBoCommon.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/16.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import Foundation

//MARK: - 应用程序信息
//应用程序 ID
let YWAppKey = "230399048"
//应用程序加密信息（开发者可以申请修改）
let YWAppSecret = "2300ebab467f68ded929aae3dfa2e659"
//回调地址 登录完成的跳转 URL 参数以 get 形式拼接
let YWRedirectURL = "https://www.baidu.com"

////应用程序 ID
//let YWAppKey = "147115757"
////应用程序加密信息（开发者可以申请修改）
//let YWAppSecret = "ab4a145e16dd1dceb74da938811a6822"
////回调地址 登录完成的跳转 URL 参数以 get 形式拼接
//let YWRedirectURL = "http://www.baidu.com"


//MARK: - 全局通知定义
/// 用户需要登录通知
let YWUserShouldLoginNotification = "YWUserShouldLoginNotification"

/// 成功登录通知
let YWuserLoginSuccessedNotification = "YWuserLoginSuccessedNotification"


//MARK: - 微博配图视图常量
/// 配图视图外侧的间距
let pictureOutterMargin = CGFloat(12)



/// 配图视图内侧的间距
let pictureInnerMargin = CGFloat(3)

/// 视图 总宽度
let YWStatusPictureViewWidth = UIScreen.yw_screenWidth() - 2 * pictureOutterMargin

/// 每个Item 默认的高宽度
let YWStatusPictureItemWith = (YWStatusPictureViewWidth - CGFloat(2) * pictureInnerMargin)/CGFloat(3)
