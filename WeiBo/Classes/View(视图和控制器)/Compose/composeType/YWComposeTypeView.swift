//
//  YWComposeTypeView.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/5.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit
import pop
class YWComposeTypeView: UIView {

    //返回按钮
    @IBOutlet weak var returnBtn: UIButton!
    //关闭按钮的中心x约束
    @IBOutlet weak var closeCenterX: NSLayoutConstraint!
    //返回按钮的中心x约束
    @IBOutlet weak var returnCenterX: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    /// 按钮数据数组
    fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字","clsName": "YWComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多","actionName":"moreAction"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    //block 作为属性的写法， 需要时可选的
    fileprivate var completionBlock:((_ clsName: String?) ->())?
    // MARK: - 实例化方法
    class func composeTypeView() ->YWComposeTypeView {
    
        let nib = UINib.init(nibName: "YWComposeTypeView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! YWComposeTypeView
        view.frame = UIScreen.main.bounds
        view.steupUI()
        return view
    }

    
    /// 显示当前视图
    ///OC中的block 如果当前的方法不能执行，通常使用属性记录，在需要的时候执行
    func show(completion:@escaping (_ clsName: String?)->()) {
        //记录闭包
        completionBlock = completion
        
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else{
           return
        }
        vc.view .addSubview(self)
        
        //开始动画
        showCurrentView()
    }

    
    @objc fileprivate func moreAction() {
        
        scrollView .setContentOffset( CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        let margin = scrollView.bounds.width / 6
        //处理底部按钮
        returnBtn.isHidden = false
        closeCenterX.constant += margin
        returnCenterX.constant -= margin
        
        UIView.animate(withDuration: 0.25) { 
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func returnAction(_ sender: UIButton) {
        scrollView.setContentOffset( CGPoint(x: 0, y: 0), animated: true)
        
        closeCenterX.constant = 0
        returnCenterX.constant = 0
   
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnBtn.alpha = 0
        }) { (_) in
            self.returnBtn.isHidden  = true
            self.returnBtn.alpha = 1
        }
    }
    
    /// 关闭视图
    @IBAction func closeAction(_ sender: UIButton) {
        hideButtons()
    }
    
    //按钮点击事件
    @objc fileprivate func btnAction(selectedbutton: YWComposeTypeButton) {
    
        //判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let view = scrollView.subviews[page]
        
        for (i, btn) in view.subviews.enumerated(){
            //选中按钮放大，未选中按钮缩小
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            //x,y 在系统中使用CGPoint 表示，如果要转换成 id 需要使用 NSValue 包装
            let scale = (selectedbutton == btn) ?2 :0.2
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            //渐变动画 -动画组
            let alphaAnima: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnima.toValue = 0.2
            alphaAnima.duration = 0.5
            btn.pop_add(alphaAnima, forKey: nil)
            
            //3.添加动画监听
            if i == 0 {
                alphaAnima.completionBlock = {_，_ in
                   //执行完成闭包
                    self.completionBlock?(selectedbutton.clsName)
                }
            }
        }
    }
    
}
//MARK: - 动画方法扩展
fileprivate extension YWComposeTypeView {
   
    
    //消除动画 隐藏按钮动画
    func hideButtons(){
    //1.根据contentOffset判断当前显示的子视图
        let page  = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let view = scrollView.subviews[page]
        
        for (i, btn) in view.subviews.enumerated() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            //设置时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(view.subviews.count - i) * 0.025
            btn.pop_add(anim, forKey: nil)
            
            //监听第 0个按钮 是最后一个执行的
            if i == 0 {
                anim.completionBlock = {_, _ in
                    //隐藏当前视图
                    self.hideCurrentView()
                }
            }
        }
    }
    
    //隐藏当前View
    func hideCurrentView (){
    
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = {_,_ in
            self.removeFromSuperview()
        }
    }
    
    
    
    //动画显示当前视图
    func showCurrentView() {
      //创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
       //添加到视图
        pop_add(anim, forKey: nil)
        showButtons()
    }
    
    //弹力显示所有的按钮
    func showButtons() {
        //第一步获取scrollView的子视图的第0个按钮
        let v = scrollView.subviews[0]
        //遍历V中所有的按钮
        for (i, btn) in v.subviews.enumerated() {
            //创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //设置动画属性
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            //弹力系数 取值范围0 - 20 数值越大 弹性越大 默认为4
            anim.springBounciness = 8
            //弹性速度 取值范围 0 -20 数值越大，速度越快，默认为12
            anim.springSpeed = 10
            //设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
        }
    
    }
    
}


fileprivate extension YWComposeTypeView {
    func steupUI() {
        //强行更新布局
        layoutIfNeeded()
        
        //向scrollView 添加视图
        let rect = scrollView.bounds
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * scrollView.bounds.width, dy: 0))
            //向视图添加按钮
            addBtns(view: v, index:i * 6)
            //将视图添加到scrollView
            scrollView.addSubview(v)

        }
        
        scrollView.contentSize = CGSize(width: 2 * scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        //禁用滚动
        scrollView.isScrollEnabled = false
    }
    
    func addBtns(view:UIView, index:Int) {
        //从index 开始 添加6个按钮
        let count = 6
        for i in index..<(index + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            //从数组字典中获取图像名称和title
            let dic =  buttonsInfo[i]
            
           guard let imageName = dic["imageName"],
            let title = dic["title"] else {
                continue
            }
            
            //创建按钮
            let btn = YWComposeTypeButton.composeTypeButton(imageName:imageName , title: title)
            
            //将btn 添加到视图
            view.addSubview(btn)
            
            //添加监听方法
            if let actionName = dic["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            }
            
            //设置要展现的类名 - 不需要任何判断
            btn.clsName = dic["clsName"]
        }
        
        //布局按钮
        //准备常量
        let btnSzie = CGSize(width: 100, height: 100)
        //横向间距
        let margin = (view.bounds.width - 3 * btnSzie.width)/4
        
        
        for (i, btn) in view.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (view.bounds.height - btnSzie.height) : 0
            
            let x =  CGFloat((i % 3) + 1) * margin + CGFloat(i % 3) * btnSzie.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSzie.width, height: btnSzie.height)
            
            
        }
        
    }

}
