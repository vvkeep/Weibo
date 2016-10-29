//
//  YWTabBarViewController.swift
//  WeiBo
//
//  Created by yao wei on 16/9/9.
//  Copyright © 2016年 yao wei. All rights reserved.
//  主控制器

import UIKit
import SVProgressHUD
class YWTabBarViewController: UITabBarController {
    // MARK: - 私有控件 撰写按钮
    fileprivate lazy var composeBtn : UIButton = UIButton.yw_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    //定时器
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        steupChildControllers()
        steupComposeBtn()
        steupTimer()
        delegate = self
        
        steupNewfeatureView()

        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: YWUserShouldLoginNotification), object: nil)
    }
    
    deinit{
        //销毁定时器
        timer?.invalidate()
        
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }

    /**
     portrait :竖屏，肖像
     landscape : 横屏，风景画
     
     - 使用代码控制方向之后 好处 可以在横屏的时候 单独处理
     - 设置支持方向之后 当前的控制器及子控制器都会遵守这个方向
     - 如果播放视频 通常是通过 modal 展现的 present
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //登录通知监听方法
    @objc private func userLogin(noti:Notification){
    
        print("登录通知\(noti)")
        var deadlineTime = DispatchTime.now()
        
        //判断 noti 是否有值 如果有 提示用户重新登录
        
        if noti.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            //修改延迟时间
            deadlineTime = DispatchTime.now() + 2

        }
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            SVProgressHUD.setDefaultMaskType(.clear)
            //展现登录控制器
            let nvc = UINavigationController(rootViewController: YWOAuthViewController())
            
           self.present(nvc, animated: true, completion: nil)
        }
    }
    
    
    @objc fileprivate func composeBtnAction(){
        print("点击撰写按钮")
        //FIXME:判断是否登录
        
        //实例view
        let view = YWComposeTypeView.composeTypeView()
        //展示
        view.show { [weak view] (clsName) in
         //展现撰写微博控制器
           guard let clsName = clsName,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type else{
                view?.removeFromSuperview()

                return
            }
            
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: { 
                view?.removeFromSuperview()
            })
            
        }
    }
    
    
    //设置所有子控制器
    private func steupChildControllers() {
        
        let array: [[String:Any]] = [
            ["clsName":"YWHomeViewController","title":"首页","imageName":"home","visitorInfo" : ["imageName": "","message":"关注一些人，回这里看看有什么惊喜"]],
            ["clsName":"YWMessageViewController","title":"消息","imageName":"message_center","visitorInfo" : ["imageName": "visitordiscover_image_message","message":"登陆后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
            ["clsName":"UIViewcontroller"],
            ["clsName":"YWDiscoverViewController","title":"发现","imageName":"discover","visitorInfo" : ["imageName": "visitordiscover_image_message","message":"登陆后，最新、最热的微博尽在掌握中，不会再于实事潮流擦肩而过"]],
            ["clsName":"YWProfileViewController","title":"我的","imageName":"profile","visitorInfo" : ["imageName": "visitordiscover_image_profile","message":"登陆后，你的微博、相册、个人资料会显示在这里，展示给别人"]]
        ]
        //测试数据格式是否正确 转换成plist 数据更加直观
        //(array as NSArray) .write(toFile: "/Users/yaowei/Desktop/demo.plist", atomically: true)
        
        
        var viewControllerArr = [UIViewController]()
        
        for dic in array {
            viewControllerArr.append(controller(dic: dic))
        }
        
        viewControllers = viewControllerArr
        
    }
    
    
    /// 使用字典创建子控制器
    ///
    /// - parameter dic: 信息字典[clsName,title,imageName]
    ///
    /// - returns: 子控制器
    private func controller(dic:[String:Any]) ->UIViewController {
        //1 取得字典内容
        guard let clsName = dic["clsName"] as? String,
            let title = dic["title"] as? String,
            let imageName = dic["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? YWBaseViewController.Type,
            let visitorDic = dic["visitorInfo"] as? [String: String]
            else {
                return UIViewController()
        }
        
        //2 创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        //设置控制器的访客信息字典
        vc.visitorInfoDic = visitorDic
        
        //3 添加图片
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        //4 修改 tabbar 的标题前景色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for:.highlighted)
        //修改字体 系统默认是12号
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: .normal)
        
        // 实例化导航控制器 会调用push 方法 讲rootVC 压栈
        let nav = YWNavgationViewController(rootViewController: vc)
        return nav
    }
}


// MARK: - 新特性视图处理
extension YWTabBarViewController {

    fileprivate func steupNewfeatureView(){
        //判断是否登录
        if !YWNetworkManager.shared.userLogon {
            
            return
        }
        
        let v = isNewVersion ? YWNewFeatureView.newFeatureView() : YWWelcomeView.welcomeView()
        view.addSubview(v)

    }
    
    //extension 中可以有计算行属性 不会占用内存空间
    private var isNewVersion: Bool {
        
        //取出当前是版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        //取出保存在偏好设置的版本号
        let beforeVersion = UserDefaults.standard.string(forKey: "YWVersionKey") ?? ""
        
        //将当前的版本号偏好设置
        UserDefaults.standard.set(currentVersion, forKey: "YWVersionKey")
        
        //返回 连个版本号是否一致
        return currentVersion != beforeVersion

    }
    
    
}





// MARK: - UITabBarControllerDelegate
extension YWTabBarViewController:UITabBarControllerDelegate {

    /// 将要选择 TabBarItem
    ///
    /// - parameter tabBarController: tabBarController
    /// - parameter viewController:   目标控制器
    ///
    /// - returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        print("将要切换到\(viewController)")
        //获取控制器在数组中的索引
       let index  =  childViewControllers.index(of: viewController)
        
       //判断当前索引是首页， 同时index 也是首页 重复点击首页的按钮
        if selectedIndex == 0 && index == selectedIndex {
            print("点击首页")
            //让表格滚到顶部
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! YWHomeViewController
            //滚动到顶部
//            vc.tableView?.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
            vc.tableView?.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            
            //刷新数据
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                vc.loadData()
            })
            
            // FIXME:下拉刷新不行
//            vc.tabBarItem.badgeValue = nil
//            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        
        //判断目标控制器是否是 UIViewController 不包含子类
      return  !viewController.isMember(of: UIViewController.self)
    }

}

//MARK:- 定时器相关方法
extension YWTabBarViewController {
    //定义定时器
    fileprivate func steupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 240.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    //定期器触发方法
    @objc fileprivate func updateTimer () {
        
        if !YWNetworkManager.shared.userLogon {
        
            return
        }
        
        YWNetworkManager.shared.unreadCount { (unreadCount) in
            print("检测到\(unreadCount)条微博")
            
            //设置 首页 tabBarItem 的badgeNumber
            self.tabBar.items?[0].badgeValue = unreadCount > 0 ? "\(unreadCount)" : nil
            
            //设置 App的badgeNumber 从ios 8.0 之后 需要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = unreadCount
            
        }
    }
}

//extension 类似于 OC中的分类 在Swift 中用来切分代码块
//可以把相近功能的函数 放在一个 extension 中 便于代码维护
//注意：和OC中的分类一样 extension 不能定义属性

// MARK: - 设置界面
extension YWTabBarViewController {
    //设置撰写按钮
    fileprivate func steupComposeBtn() {
        tabBar.addSubview(composeBtn)
        //设置位置
        let count = CGFloat(childViewControllers.count)
        // 将向内缩进宽度
        let w = tabBar.yw_width / count
        //正数 向内部缩进 、负数向外外部扩展  insetBy 左右同时往内缩小
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        //添加点击事件
        composeBtn.addTarget(self, action: #selector(composeBtnAction), for: .touchUpInside)
    }
}

