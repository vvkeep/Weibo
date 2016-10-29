//
//  YWRefreshControl.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/23.
//  Copyright © 2016年 yao wei. All rights reserved.
//  刷新控件

import UIKit


/// 刷新状态切换的临界点
///
/// - Normal:      普通状态（还未到达临界点）
/// - Pulling:     超过临界点，如果放手，开始刷新
/// - WillRefresh: 超过临界点，并且刷新
enum YWRefreshStaus {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新状态切换的临界点
fileprivate let YWRefreshOffset: CGFloat = 122

class YWRefreshControl: UIControl {
    
    //刷新控件的父视图，下拉刷新控件应该适用于 tableView 和collectionView
    //父视图addSubView 强引用了self，所以使用weak
    fileprivate weak var scrollView: UIScrollView?
    fileprivate lazy var refrershView: YWRefreshView = YWRefreshView.refreshView()
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        steupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupUI()
    }
    /**
     willMove addSubView 方法会调用
     当添加到父视图的时候 newSuperView 是父视图
     当父视图移除的时候 newSuperView 是 nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //判断父视图类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        //记录父视图
        scrollView = sv
        
        //KVO监听父视图 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    //KVO 方法会统一调用此方法
    //观察者模式 在不需要的时候都需要释放 
    //通知中心：如果不释放 什么也不会发生，但是会有内存泄漏，会有多次注册的可能！
    //KVO 如果不释放会崩溃
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        //初始高度 为0 crollView?.contentInset.top = 64, scrollView?.contentOffset.y = -64
        let height = -(sv.contentInset.top + sv.contentOffset.y);
        
        if height < 0 {
            return
        }
        
        //传递高度  如果是在正在舒心状态，就不传递高度 改变大小
        if refrershView.refreshStatus != .WillRefresh {
            refrershView.parentViewHeight = height
        }
        
        //根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if sv.isDragging {
            if height > YWRefreshOffset && refrershView.refreshStatus == .Normal{
                print("放手刷新")
                refrershView.refreshStatus = .Pulling
            }else if height <= YWRefreshOffset && refrershView.refreshStatus == .Pulling{
                print("继续拽")
                refrershView.refreshStatus = .Normal
            }
        }else {
           //放手 不在拖拽状态 判断是否超过临界点
            if refrershView.refreshStatus == .Pulling {
                print("刷新数据----")
                beginRefreshing()
                //发送刷新数据事件
                sendActions(for: .valueChanged)
            }
        }
        
    }
    
    //本视在父视图上移除
    override func removeFromSuperview() {
        //superView还在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        //superView不存在
        super.removeFromSuperview()
    }
    
    //开始刷新
    func beginRefreshing(){
       print("开始刷新")
        //判断父视图
        guard let sv = scrollView else {
            return
        }
        
        //判断是否正在刷新，如果正在刷新，直接返回
        if refrershView.refreshStatus == .WillRefresh {
            return
        }
        //设置表格间距 要放在设置间距前面
        refrershView.refreshStatus = .WillRefresh
        
        //设置新视图的间距
        var inset1 = sv.contentInset
        inset1.top += YWRefreshOffset
        sv.contentInset = inset1
        
        refrershView.parentViewHeight = YWRefreshOffset
    }
    
    //结束刷新
    func endRefreshing(){
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        
        //判断状态 是否正在刷新，如果不是，直接返回
        if refrershView.refreshStatus != .WillRefresh {
            return
        }
        
        //恢复刷新视图的状态
        refrershView.refreshStatus = .Normal
        //恢复表格的 contentInset
        var inset = sv.contentInset
        inset.top -= YWRefreshOffset
        sv.contentInset = inset
    

    }
}

extension YWRefreshControl {

    fileprivate func steupUI(){
       backgroundColor = superview?.backgroundColor
        addSubview(refrershView)
        
        //自动布局
        refrershView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refrershView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refrershView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refrershView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refrershView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refrershView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refrershView.bounds.height))
        
        
    }
}
