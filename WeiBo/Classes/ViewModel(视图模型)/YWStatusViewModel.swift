//
//  YWStatusViewModel.swift
//  WeiBo
//
//  Created by yao wei on 16/9/20.
//  Copyright © 2016年 yao wei. All rights reserved.
//  单条微博的数据模型

import Foundation
/**
 如果没有任何父类 希望在开发是调试 输出调试信息
 1.遵守CustomStringConvertible 协议
 2.实现 description 计算型属性
 关于表格性能优化
 尽量少计算 所有需要的素材提前计算好
 控件上不要设置圆角半径 所有图像渲染的属性 都要注意
 不要动态创建控件 所有的控件提前创建好 在显示的时候 根据数据隐藏/显示
 cell中控件的层次太少 数量越少越好
 */
class YWStatusViewModel: CustomStringConvertible{
   
    var status: YWStatus
    
    /// 会员图标 - 存储型属性（用内存换 CPU）
    var memberImg:UIImage?
    
    /// 认证类型 -1 没有认证 0 认证用户 235 企业用户 220 达人
    var vipImg: UIImage?
    
    /// 转发
    var retweetedStr: String?
    
    /// 评论
    var commentStr: String?
    
    /// 点赞
    var likeStr: String?
    
    /// 来源
//    var sourceStr: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    
    /// 如果是被转发的微博，原创微博衣服那个没有图
    var  picURLs: [YWStatusPictures]? {
    //如果有被转发的微博 返回被转发微博的配图， 如果没有，返回原创微博的配图 ,如果都没有 返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 行高
    var rowHeight:CGFloat = 0
    
    /// 微博正文的属性文本
    var statusAttrText: NSAttributedString?
    /// 被转发微博的属性文字
    var retweededAttrText: NSAttributedString?
    
    init(model: YWStatus) {
        self.status = model
        //根据计算出的会员图标0 - 6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7{
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberImg = UIImage(named: imageName)
        }
        
        //认证图标
        switch model.user?.verified_type ?? -1{
        case  0:
            vipImg = UIImage(named: "avatar_vip")
        case  2,3,5:
            vipImg = UIImage(named: "avatar_enterprise_vip")
        case  220:
            vipImg = UIImage(named: "avatar_enterprise_vip")
        default:
            break
        }
        
        //设置底部计数字符串
        retweetedStr = countString(count: model.reposts_count, defaultStr: " 转发")
        commentStr = countString(count: model.comments_count, defaultStr: " 评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: " 赞")
        
        //计算配图视图大小
        pictureViewSize = calPictureViewSize(count: picURLs?.count)
        
        // 设置微博文本
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //被转发微博的文字
        let rText = "@" + (model.retweeted_status?.user?.screen_name ?? "") + ":" + (model.retweeted_status?.text ?? "")
        retweededAttrText = YWEmoticonManager.shared.emoticonString(string:rText, font:retweetedFont)
        
        //微博正文属性文本
        statusAttrText = YWEmoticonManager.shared.emoticonString(string:model.text ?? "", font:originalFont)

        //计算行高
        updateRowHeight()
    }
    
    var description: String {
        return status.description
    }
    
    
    /// 根据当前视图模型内容计算行高
    func updateRowHeight() {
        let margin:CGFloat = 12
        
        let iconHeight: CGFloat = 34
        
        let bottomBarHeight: CGFloat = 35
        
        let viewSize = CGSize(width: UIScreen.yw_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        

        
        
        //计算顶部位置
      var height = 2 * margin + iconHeight + margin
        
        //正文高度
         if let text = statusAttrText {
            
            //正文属性文本高度 属性文本中，自身已经包含了字体属性
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            /**
             预期尺寸，宽度固定，高度尽量大
             选项： 换行文本 统一使用 .usesLineFragmentOrigin
             attributes:指定字体字典
             */
//           height += (text as NSString).boundingRect(with: viewSize, options:.usesLineFragmentOrigin, attributes: [NSFontAttributeName: originalFont], context: nil).height
        
            //判断是否有转发微博
            if status.retweeted_status != nil {
            
                height += 2 * margin
                
                if let text = retweededAttrText {
                    height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
                    
//                    height += (text as NSString).boundingRect(with: viewSize, options:.usesLineFragmentOrigin, attributes: [NSFontAttributeName: retweetedFont], context: nil).height
                    
                }
            }
            
            //配图视图
            height += pictureViewSize.height
            
            //底部工具栏
            height += bottomBarHeight
            
            //使用属性记录
            rowHeight = height
            
        }
    }
    
    
    /// 使用单个图像 更新配图视图的大小
    ///
    ///新浪针对单张图片，都是缩略图，但是偶尔会有一张特别大的图
    /// - parameter image: 网络缓存的单张图像
    ///
    func updateImageSize(image: UIImage) {
        var size = image.size
        
        let maxWith: CGFloat = 300
        let minWidth: CGFloat = 40
        
        //过宽图片处理
        if size.width >= maxWith {
            //设置最大宽度
            size.width = maxWith
           //等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        //过窄处理
        if size.width < minWidth {
            //设置最大宽度
            size.width = minWidth
            //等比例调整高度
            size.height = size.width * image.size.height/image.size.width / 4
        }

        
        //注意 尺寸需要增加顶部的 12 个点 便于布局
        size.height +=  pictureOutterMargin
        
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    }
    
    
    
    /// 计算指定数量的图片对应的配图的大小
    ///
    /// - parameter count: 配图数量
    ///
    /// - returns: 配图视图的大小
    private func calPictureViewSize(count: Int?) ->CGSize {

        if count == 0 || count == nil{
            return CGSize()
        }
        
        /// 行数
        let row = (count! - 1)/3 + 1
        
        /// 根据行数计算行高
        let height = pictureOutterMargin + CGFloat(row) * YWStatusPictureItemWith + CGFloat(row - 1) * pictureInnerMargin
        
        return CGSize(width: YWStatusPictureViewWidth, height: height)
    
    }
    
    /*
     如果 数量 == 0 显示默认标题
     数量 超过 10000 显示x.xx万
     如果 数量 <10000 显示实际数字
    **/
    private func countString(count:Int, defaultStr: String) ->String {
    
        if count == 0 {
        return defaultStr
        }
        
        if count < 10000 {
        return count.description
        }
        
        return String(format: "%.02f 万",  Double(count / 10000))
    }
    
}
