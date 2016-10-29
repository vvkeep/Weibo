//
//  YWUserAccount.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/17.
//  Copyright © 2016年 yao wei. All rights reserved.
//  用户账户信息

import UIKit

private let accountFile: NSString = "userAccount.json"

class YWUserAccount: NSObject {

    
    /// 访问令牌
    var access_token: String?
    
    /// 用户代号
    var uid: String?
    
    /// access_token 的生命周期 开发者5年 使用者3天
    var expires_in: TimeInterval = 0 {
    
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expiresDate: Date?
    //用户昵称
    var screen_name: String?
    //用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
    //从磁盘读取用户登录信息
    override init() {
        super.init()
        //从磁盘加载保存文件
       guard let path = accountFile.yw_appendDocumentDir(),
        let data = NSData(contentsOfFile: path),
             let dic = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
        else {
            return
        }
        //使用字典设置属性值
        yy_modelSet(with: dic ?? [:])
        
        //测试日期
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        //判断 token 是否过期
        if  expiresDate?.compare(Date()) == .orderedAscending {
            //账户过期 清空 token uid
            access_token = nil
            uid = nil
            //删除账户文件
            _ = try?FileManager.default.removeItem(atPath: path)
            
        }
        
    }
    
    
    
    //本地化用户数据模型
    func saveAccount(){
        // 模型转字典
        var dic = self.yy_modelToJSONObject() as?  [String: AnyObject] ?? [:]
        //删除expires_in 值
        dic.removeValue(forKey: "expires_in")
        //字典序列化 data
        guard  let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
            let filePath = accountFile.yw_appendDocumentDir() else {
        
            return
        }
        //写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功\(filePath)")

    }
}
