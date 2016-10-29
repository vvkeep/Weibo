//
//  YWHomeViewController.swift
//  WeiBo
//
//  Created by yao wei on 16/9/9.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit
//原创微博可重用 cell
private let originalcellID = "originalcellID"
//转发微博的可重用 cell
private let retweetedCellID = "retweetedCellID"
class YWHomeViewController: YWBaseViewController {
    
    //列表视图模型
    fileprivate lazy var listViewModel = YWStatusListViewModel()
    //加载数据
    override func loadData() {
        // Xcode 8.0 的刷新控件，beginRefreshing 方法，什么都不显示！
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { 
            self.listViewModel.loadStatud (isPullup: self.isPullup) { (isSuccess,shouldRefresh) in
                //结束刷新
                self.refreshControl?.endRefreshing()
                
                //消除tabBarItem.badgeValue
                if self.isPullup == false {
                    //清除 tabItem 的 badgeNumber
                    self.navigationController?.tabBarItem.badgeValue = nil
                    //                self.tabBarController?.tabBarItem.badgeValue = nil
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                
                //恢复上拉刷新标记
                self.isPullup = false
                
                if shouldRefresh {
                    //刷新表格
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    @objc fileprivate func showFriendAction(){
        let vc = YWDemoViewController()
        //vc.hidesBottomBarWhenPushed = true
        //push 动作是nav 做的
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - 设置控件
extension YWHomeViewController {
    //重写父类方法
    override func steupTableView() {
       
        super.steupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriendAction))
        
        //注册原型cell 注意： 这里的 YWStatusNormalCell 是empty 建立的
       //原创微博Cell
        tableView?.register( UINib(nibName: "YWStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalcellID)
        
        //转发微博Cell
        tableView?.register(UINib(nibName: "YWStatusRetweedCell", bundle: nil), forCellReuseIdentifier: retweetedCellID)
        
        steupNavTitle()
        
//        //设置行高  自动计算rowHeight跟estimatedRowHeight到底是有什么仇，如果不加上估算高度的设置，自动算高就失效了。
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        //估算高度的设置
//        tableView?.estimatedRowHeight = 380
        
        //取消分割线
        tableView?.separatorStyle = .none
        
    }
    
    //设置导航栏标题
    fileprivate func steupNavTitle() {
    
        let btn = YWTitleButton(title: YWNetworkManager.shared.userAccount.screen_name)
        navItem.titleView = btn
        btn.addTarget(self, action: #selector(titleBtnAction), for: .touchUpInside)
    
    }
    
    @objc private func titleBtnAction(btn:UIButton){
        //设置选中状态
        btn.isSelected = !btn.isSelected
        
    }
    
}


//MARK: - 表格数据源方法
extension YWHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let viewModel = listViewModel.statusList[indexPath.row]

        let cellID = viewModel.status.retweeted_status == nil ? originalcellID : retweetedCellID
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YWStatusCell
        
        cell.viewModel = viewModel
        
        //设置代理
        cell.delegate = self
        return cell
    }
    
    ///父类必须实现代理方法 子类才能重写 Swift 3.0 如此 2.0 不需要
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        
        return viewModel.rowHeight
    }
}


extension YWHomeViewController:YWStatusCellDelegate{
    func statusCellDidTapURLString(cell: YWStatusCell, urlString: String) {
        let vc = YWWebViewController()
        vc.urlString = urlString
        navigationController?.pushViewController(vc, animated: true)
    }
}
