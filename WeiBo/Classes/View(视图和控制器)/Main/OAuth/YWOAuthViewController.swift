//
//  YWOAuthViewController.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/16.
//  Copyright © 2016年 yao wei. All rights reserved.
//  通过webView加载新浪微博授权页面控制器

import UIKit
import WebKit
import SVProgressHUD

class YWOAuthViewController: UIViewController {
    
    fileprivate lazy var webView = UIWebView()
    
    
    override func loadView() {
        view = webView
        
        //是否webView 是否滚动
        webView.scrollView.isScrollEnabled = false
        view.backgroundColor  = UIColor.white
        //设置导航栏
        title = "登录微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(backAction), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFillAction))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(YWAppKey)&redirect_uri=\(YWRedirectURL)"
        guard let url = URL(string: urlString) else{
            return
        }
        let request = URLRequest(url: url)
//        webView.load(request)
//        webView.navigationDelegate = self
                webView.loadRequest(request)
                webView.delegate = self
    }
    
    //MARK: - 监听方法
    @objc fileprivate func backAction(){
        
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFillAction(){
        //准备JS
        let js = "document.getElementById('userId').value = '15919688564';" + "document.getElementById('passwd').value = 'ssjj.com';"
        //让webView 执行js
//        webView.evaluateJavaScript(js, completionHandler: nil)
                webView.stringByEvaluatingJavaScript(from: js)
    }
    
}

//extension YWOAuthViewController: WKNavigationDelegate {
//    
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("加载的请求\(webView.url?.absoluteString)")
//    }
//}


extension YWOAuthViewController: UIWebViewDelegate {
    
    /// 将要加载请求
    ///
    /// - parameter webView:        webView
    /// - parameter request:        要加载的请求
    /// - parameter navigationType: 导航类型
    ///
    /// - returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        print("请求的地址\(request.url?.absoluteURL)")
        //如果请求地址包含不包含 https://www.baidu.com  加载页面 /否则 就是包含 包含就往下走
        if request.url?.absoluteString.hasPrefix(YWRedirectURL) == false {
            return true
        }
        
        //从http://baidu.com 的回调地址查询字符串 code=
        //不包含code= 就是 授权失败
        if request.url?.query?.hasPrefix("code=") == false{
            //授权失败  返回上一级页面
            backAction()
            return false
        }
        
        //截取授权码
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        
        //请求accessToken
        YWNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if isSuccess {
                // SVProgressHUD.showInfo(withStatus: "登录成功")
                self.backAction()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWuserLoginSuccessedNotification), object: nil, userInfo: nil)
            } else{
                
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }
            
            
        }
        
        return false
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

