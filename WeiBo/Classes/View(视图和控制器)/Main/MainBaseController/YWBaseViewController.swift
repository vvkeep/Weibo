//
//  YWBaseViewController.swift
//  WeiBo
//
//  Created by yao wei on 16/9/9.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

/**
 1.extension 中不能有属性
 2.extension 不能重写父类发方法 重写父类方法是子类发职责 分类负责扩展
 */
class YWBaseViewController: UIViewController {
    
    //访客视图信息字典
    var visitorInfoDic :[String:String]?
    
    //表格视图 -J' 如果用户没有登录，就不创建
    var tableView: UITableView?
    //刷新控件
    var refreshControl:YWRefreshControl?
    //上拉刷新的标记
    var isPullup = false
    
    //自定义导航条
    lazy var navgationBar : UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.yw_screenWidth(), height: 64))
    
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //判断是否登录 登录再加载数据
        YWNetworkManager.shared.userLogon ? loadData() :()
        //注册登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: YWuserLoginSuccessedNotification), object: nil)
        
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override var title : String?{
        didSet{
            navItem.title = title
        }
    }
    //加载数据 具体由子类负责
    func loadData() {
        //如果子类不实现 默认关闭刷新
        refreshControl?.endRefreshing()
    }
}

// MARK: - 访客视图监听方法
extension YWBaseViewController {
    
    //登录成功
    @objc fileprivate func loginSuccess(noti: Notification){
        print("登录成功")
        
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        // view = nil 会重新调用 loadview -> viewDidLoad
        view = nil
        
        //注销通知 ->重新执行viewDidLoad 会再次被注册 避免通知重复注册 会重复通知的（发多次的情况）
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func login() {
        
        print("用户登录")
        //发送通知
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: YWUserShouldLoginNotification), object: nil, userInfo: nil))
    }
    
    @objc fileprivate func register() {
        
        print("用户注册")
    }
}



// MARK: - 设置界面
extension YWBaseViewController {
    
    fileprivate func initUI() {
        view.backgroundColor = UIColor.white
        //取消自动缩进 - 如果隐藏了导航栏 会缩进20点
        automaticallyAdjustsScrollViewInsets = false
        steupNavigationBar()
        YWNetworkManager.shared.userLogon ? steupTableView() : steupVisitorView()
    }
    
    /// 设置表格视图-- 用户登录之后执行
    //子类重写方法 因为子类不需要关心用户登录之前的逻辑
    func steupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navgationBar)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navgationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.yw_height ?? 49, right: 0)
        //设置导航条的缩进
        tableView?.scrollIndicatorInsets  = tableView!.contentInset
        
        //添加刷新控件
        refreshControl = YWRefreshControl()
        
//        let str = NSAttributedString(string: "正在刷新")
//        
//        refreshControl?.attributedTitle = str
        tableView?.addSubview(refreshControl!)
        //添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func steupVisitorView() {
        
        let visitorView = YWVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navgationBar)
        visitorView.visitorInfo = visitorInfoDic
        
        //添加访客视图按钮的监听方法
        visitorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    ///设置导航栏
    private func steupNavigationBar() {
        view.addSubview(navgationBar)
        //将item 设置给barnj
        navgationBar.items = [navItem]
        //设置 navBar 的渲染颜色
        navgationBar.barTintColor = UIColor.yw_color(withHex: 0xF6F6F6)
        //设置navBar 的标题字体颜色
        navgationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //设置系统按钮的文字渲染颜色  只对系统.plain 的方法有效
        navgationBar.tintColor = UIColor.orange
    }
}

// MARK: - 代理方法
extension YWBaseViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类只是准备方法 子类负责具体实现  子类发数据源方法不需要super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证没有语法错误
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    //在显示最后一行的时候 做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 判断indexpath 是否最后一行
        let row = indexPath.row
        //取最后一组
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        //最后一组的行数
        let count = tableView.numberOfRows(inSection: section)
        //如果是最后一行 同时没有开始上拉刷新
        if (row == count - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            //开始刷新
            loadData()
            
        }
    }
}
