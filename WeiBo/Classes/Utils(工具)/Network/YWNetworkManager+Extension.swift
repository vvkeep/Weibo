//
//  YWNetworkManager+Extension.swift
//  WeiBo
//
//  Created by yao wei on 16/9/14.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import Foundation
// MARK: - 封装微博的网络请求
extension YWNetworkManager {
    
    /// - parameter since_id:   返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - parameter max_id:     返回ID小于或等于max_id的微博，默认为0
    /// - parameter completion: 完成回调
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion:@escaping (_ list:[[String: AnyObject]]?,_ isSuccess: Bool)->()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id": since_id, "max_id": max_id > 0 ?max_id - 1 : 0]
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            //从json 中获取 statues 字典数组  如果 as？ 失败 result = nil
            let result = json?["statuses"] as? [[String:AnyObject]]
            
            completion(result, isSuccess)
        }
    }
    //未读数量
    func unreadCount(completion:@escaping (_ unreadCount:Int) ->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlStr = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            let dic = json as? [String: AnyObject]
            let unreadCount = dic?["status"] as? Int
            completion(unreadCount ?? 0)
            
        }
        
    }
}

// MARK: - 发布微博
extension YWNetworkManager{
    
    ///  发布微博
    ///
    /// - parameter text:       要发布的文本
    /// - parameter image:      要上传的图像可以为nil，为nil时候，发布纯文本
    /// - parameter completion: 完成回调
    func postStatus(text: String, image: UIImage?, completion:@escaping (_ result:[String:AnyObject]?,_ isSuccess:Bool)->()) ->(){
        let urlString: String
        
        if image == nil {
             urlString = "https://api.weibo.com/2/statuses/update.json"
        } else{
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        let params = ["status":text]
        
        var name: String?
        var data :Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]?, name: name, data: data) { (json, isSuccess) in
             completion(json as? [String: AnyObject], isSuccess)
        }
    }
}

// MARK: - 用户信息
extension YWNetworkManager {
    
    func loadUserInfo(completion:@escaping (_ json: [String: AnyObject]) ->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        let  params = ["uid":uid]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
           //完成回调
            completion(json as? [String: AnyObject] ?? [:])
        }
    }
}

// MARK: - OAuth 授权相关方法
extension YWNetworkManager {
    
    func loadAccessToken(code: String,completion:@escaping (_ isSuccess: Bool)->()) {
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":YWAppKey,"client_secret":YWAppSecret,"grant_type":"authorization_code","code":code,"redirect_uri":YWRedirectURL]
        
        //发起网络请求
        request(method: .POST, URLString: urlStr, parameters: params as [String: AnyObject]?) { (json, isSuccess) in
            //设置模型
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])

            //加载当前用户信息
            self.loadUserInfo(completion: { (json) in
//                print(json)
                self.userAccount.yy_modelSet(with: json)
                //本地化数据
                self.userAccount.saveAccount()
                completion(isSuccess)
            })
            
          
        }
    }
    
}
