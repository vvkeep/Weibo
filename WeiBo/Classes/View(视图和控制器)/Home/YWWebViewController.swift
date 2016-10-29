//
//  YWWebViewController.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/19.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWWebViewController: YWBaseViewController {

    fileprivate lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    var urlString: String?{
        didSet {
         guard let urlString = urlString,
            let url = URL(string: urlString) else{
                return
            }
            webView.loadRequest(URLRequest(url: url))
        }
    }

}

extension YWWebViewController{
    override func steupTableView() {
        navItem.title = "网页"
        
        view.insertSubview(webView, belowSubview: navgationBar)
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset.top = navgationBar.bounds.height
        
    }
}
