//
//  UIImageView+WebImage.swift
//  WeiBo
//
//  Created by yao wei on 16/9/20.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import SDWebImage

extension UIImageView {

    
    /// 隔离 SDWebImage 设置图像函数
    ///
    /// - parameter urlStr:           urlString
    /// - parameter placeholderImage: 占位图像
    /// - parameter isAvatar:         是否头像（设置圆角）
    func yw_setImage(urlStr:String?, placeholderImage:UIImage?, isAvatar: Bool = false) {
        
        guard let urlStr = urlStr,
            let url = URL(string: urlStr) else {
            //设置占位图像
            image = placeholderImage
            return
        }
        
        //可选项只是用在 Swift，OC 有的时候 用！同样可以传入 nil/ weak self 防止循环引用
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            //完成回调 - 判断是否头像
            if isAvatar {
            
               self?.image =  image?.yw_avatarImage(size: self?.bounds.size)
            }
            
        }
    }
}
