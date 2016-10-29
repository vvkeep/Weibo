
//
//  YWDemoViewController.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/11.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWDemoViewController: YWBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc fileprivate func showNextAction(){
        let vc = YWDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}




extension YWDemoViewController {
    
    override func steupTableView() {
        super.steupTableView()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(showNextAction))

    }
}
