//
//  YWNetworkManager.swift
//  WeiBo
//
//  Created by yao wei on 16/9/14.
//  Copyright © 2016年 yao wei. All rights reserved.
//  网络管理工具

import UIKit
import AFNetworking

//Swift的枚举支持任意数据类型
//switch /enum 在OC中都支持整数类型
enum WBHTTPMethod {
    case GET
    case POST
}

class YWNetworkManager: AFHTTPSessionManager {
    
    //静态区/常量/闭包  在第一次访问时 执行闭包 并且将结果保存在 shared 常量中
    //单例
//    static let shared = YWNetworkManager()
    static let shared: YWNetworkManager = {
    
        //实例化对象
        let instance = YWNetworkManager()
        //设置响应反序列化支持的类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //返回对象
        return instance
    }()
    

    /// 用户账户的懒加载属性
    lazy var userAccount = YWUserAccount()
    
    //用户登录标记
    var userLogon: Bool {
    
        return userAccount.access_token != nil
    }
    
    /// 专门负责拼接 token 的网络请求方法
    ///
    /// - parameter method:     GET/POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       上传文件使用的字段名，默认为nil，就不是上传文件
    /// - parameter data:       上传文件的二进制数据，默认为nil，不上传文件
    /// - parameter completion: 完成回调
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String:AnyObject]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) ->Void) {
        
        //处理 token 字典 程序执行过程中 一般 token 不会为nil 
        guard let token = userAccount.access_token else {
            //没有token 需要重新登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWUserShouldLoginNotification), object: nil, userInfo: nil)
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        
        if parameters == nil {
            //实例化字典
            parameters = [String: AnyObject]()
        }
        
        //设置参数字典,代码在此一定不会为nil
        parameters!["access_token"] = token as AnyObject?
        
        
        //判断name 和 data
        if let name = name ,
            let data = data{
            //上传文件
            upLoad(URLString: URLString, name: name, data: data, parameters: parameters, completion: completion)
        }else{
            //调用 request 发起真正的网络请求
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
    }
    
    
    /// 上传文件必须是POST方法，GET只能获取数据
    /// 封装AFN 的上传方法
    ///
    /// - parameter URLString:  URLString
    /// - parameter data:       参数字典
    /// - parameter name:       接收上传数据的服务器字段（name - 要咨询公司的后台）"pic"
    /// - parameter parameters: 要上传的二进制数据
    /// - parameter completion: 完成回调
    func upLoad(URLString: String,name: String, data: Data, parameters: [String:AnyObject]?, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool) ->Void){
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            //FIXME: 创建formData
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
            }, progress: nil, success: { (_, json) in
                completion(json as AnyObject?, true)
        }) { (task, error) in
            //针对 403 处理token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWUserShouldLoginNotification), object: "bad Token", userInfo: nil)
            }
            print("网络请求错误\(error)")
            completion(nil, false)
        }
    }
    
    
    
    
    /// 封装AFN 的的GET /POST请求
    ///
    /// - parameter method:     GET /POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 回调json、是否成功
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String:AnyObject]?, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool) ->Void) {
        
        //成功回调
        let success = {(task: URLSessionDataTask, json: Any?) ->() in
            completion(json as AnyObject?, true)
        }
        //失败回调
        let failure = {(task: URLSessionDataTask?, error: Error) ->() in
            
            //针对 403 处理token 过期
           if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
             
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWUserShouldLoginNotification), object: "bad Token", userInfo: nil)
            }
            print("网络请求错误\(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
