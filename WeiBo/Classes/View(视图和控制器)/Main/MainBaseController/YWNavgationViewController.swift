//
//  YWNavgationViewController.swift
//  WeiBo
//
//  Created by yao wei on 16/9/9.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWNavgationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏默认 的NavgationBar
        navigationBar.isHidden = true
    }
    
    
    
    //重写 push 方法 所有的push 都做都会调用此方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //如果不是根控制器 栈底控制器 才需要隐藏 根控制器不需要隐藏
        //注意super 之前和之后的问题的区别 childViewControllers.count > 1
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            //一层显示首页标题 其他显示返回
            if let vc = (viewController as? YWBaseViewController){
                var title = "返回"
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent),isBack:true)
                
            }
            
        }
        
        super.pushViewController(viewController, animated:true)
    }
    
    
    @objc private func popToParent(){
        
        popViewController(animated: true)
    }
    
}
