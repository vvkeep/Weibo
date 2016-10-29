//
//  YWStatusCell.swift
//  WeiBo
//
//  Created by yao wei on 16/9/20.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

/// 微博cell协议
/// 如果需要设置可选协议方法
/// 需要遵守 NSObjectProtocol
/// 协议需要时@objc 的
/// 方法需要时@objc optional
@objc protocol YWStatusCellDelegate: NSObjectProtocol {
    /// 微博cell 选中URL 字符串
    @objc optional func statusCellDidTapURLString(cell:YWStatusCell,urlString:String)
}
class YWStatusCell: UITableViewCell {

    weak var delegate: YWStatusCellDelegate?
    //微博视图模型
    var viewModel:YWStatusViewModel?{
        didSet {
            
            ///微博正文
            statusLab.attributedText = viewModel?.statusAttrText
            
            /// 被转发微博文字
            retweededTextLab?.attributedText = viewModel?.retweededAttrText
            nameLab.text = viewModel?.status.user?.screen_name
            
            //设置会员图标 - 直接获取属性，不需要计算 是存储行属性
            memberIV.image = viewModel?.memberImg
            
            //认证图标
            vipIV.image = viewModel?.vipImg
            
            //用户头像
            headIV.yw_setImage(urlStr: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"),isAvatar: true)
            
            //转发
            retweetedBtn.setTitle(viewModel?.retweetedStr, for: .normal)
            
            //评论
            commentBtn.setTitle(viewModel?.commentStr, for: .normal)
            
            //评论
            likeBtn.setTitle(viewModel?.likeStr, for: .normal)
            
            /// 配图视图的高度
//            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
              pictureView.viewModel = viewModel
            

            /// 微博来源
            sourseLab.text = viewModel?.status.source
        }
    }
    
    /// 头像
    @IBOutlet weak var headIV: UIImageView!
    
    /// 姓名
    @IBOutlet weak var nameLab: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIV: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLab: UILabel!
    
    /// 来源
    @IBOutlet weak var sourseLab: UILabel!
    
    /// 认证
    @IBOutlet weak var vipIV: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLab: FFLabel!
    
    /// 转发
    @IBOutlet weak var retweetedBtn: UIButton!
    
    /// 评论
    @IBOutlet weak var commentBtn: UIButton!
    
    /// 赞
    @IBOutlet weak var likeBtn: UIButton!
    
    /// 配图视图
    @IBOutlet weak var pictureView: YWStatusPictureView!
    
    /// 被转发微博的文字 - 原创微博没有此控件 一定要 '?'
    @IBOutlet weak var retweededTextLab: FFLabel?

     
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //离屏渲染 - 异步绘制  耗电
        self.layer.drawsAsynchronously = true
        
        //栅格化 - 异步绘制之后 ，会生成一张独立的图片 cell 在屏幕上滚动的时候，本质上滚动的是这张图片 
        //cell 优化，要尽量减少图层的数量，想党羽只有一层
        //停止滚动之后，可以接受监听
        self.layer.shouldRasterize = true
        
        //使用 “栅格化” 必须指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        
        // MARK: - 设置微博文本代理
        statusLab.delegate = self
        retweededTextLab?.delegate = self
        
    }
}

extension YWStatusCell:FFLabelDelegate{
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        //判断是否是url
        if !text.hasPrefix("http://") {
            return
        }
        
        //插入？ 如果代理没有实现协议方法，就什么都不做
        //插入！ 代理没有实现协议方法，仍然强制执行 会崩溃
        delegate?.statusCellDidTapURLString?(cell: self, urlString: text)
    }
}
