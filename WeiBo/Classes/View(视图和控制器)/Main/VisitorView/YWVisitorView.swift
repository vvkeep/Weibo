//
//  YWVisitorView.swift
//  WeiBo
//
//  Created by yao wei on 16/9/12.
//  Copyright © 2016年 yao wei. All rights reserved.
//  访客视图

import UIKit
class YWVisitorView: UIView {
   
    //注册按钮
     lazy var registerBtn: UIButton  = UIButton.yw_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    //登录按钮
     lazy var loginBtn: UIButton  = UIButton.yw_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    
    /// 根据字典设置访客视图信息
    ///
    /// - parameter dic: ：[imageName/message]
    var visitorInfo:[String: String]?{
        
        didSet{
            //取字典信息
            guard  let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else{
                    return
            }
            //设置消息
            tipLabel.text = message
            //首页默认已有 不需要 设置图像
            if imageName == "" {
                //首页 图标转动
                startAnimation()
                return
            }
            iconView.image = UIImage(named: imageName)
            //其他访客视图不要显示小房子和遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    fileprivate func startAnimation(){
    
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        //完成之后是否删除 如果iconView 被释放 动画会一起销毁
        anim.isRemovedOnCompletion = false
        //将动画添加到图层
        iconView.layer.add(anim, forKey: nil)
    }
    
    // MARK: - 私有控件
    //懒加载属性 主要调用 UIkit 控件的在指定构造函数 其他都需要使用类型
    fileprivate lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //小房子
    fileprivate lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示标签
    fileprivate lazy var tipLabel:UILabel = UILabel.yw_label(withText: "关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)

    //遮罩
    fileprivate lazy var maskIconView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
    
}

// MARK: - 设置界面
extension YWVisitorView {
    
    func initUI(){
        backgroundColor = UIColor.yw_color(withHex: 0xEDEDED)
        
        //添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        tipLabel.textAlignment = .center
        
        //取消 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin:CGFloat = 20.0
        //自动布局
        //图像视图
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -50))
        //小房子
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        //提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute , multiplier: 1.0, constant: 236))
        //注册按钮
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        //登录按钮
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: registerBtn, attribute: .width, multiplier: 1.0, constant: 0))
        
        //遮罩
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .bottom, relatedBy: .equal, toItem: registerBtn, attribute: .top, multiplier: 1.0, constant: -margin))
    }
}
