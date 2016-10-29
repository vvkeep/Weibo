//
//  YWStatusPictureView.swift
//  WeiBo
//
//  Created by yao wei on 16/9/20.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWStatusPictureView: UIView {

    var viewModel: YWStatusViewModel?{
    
        didSet{
            calcViewSize()
            /// 设置配图 （被转发和原创）
            urls = viewModel?.picURLs
        }
    }
    
    
    /// 根据视图模型的配图大小 调整显示内容
    private func calcViewSize(){
        
        //处理宽度
        //单图，根据配图视图大小 修改 subview(0)的宽度
        
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: pictureOutterMargin, width:viewSize.width , height: viewSize.height - pictureOutterMargin)
        }else{
        
            //多图 、无图 恢复 subview【0】的宽度 保证九宫格布局
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: pictureOutterMargin, width:YWStatusPictureItemWith , height:YWStatusPictureItemWith)
         }
        
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    
   private var urls: [YWStatusPictures]? {
    
        didSet{
        
            //隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            //设置图像
            for url in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                if index == 1 && urls?.count == 4 {
                
                    index += 1
                }
                
                iv.yw_setImage(urlStr: url.thumbnail_pic, placeholderImage: UIImage(named: "paceholder"))
                iv.isHidden = false
                index += 1
            }
        
            
            
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        steupUI()
    }
}


// MARK: - 设置界面
extension YWStatusPictureView {

    
    /// Cell 中所有的控件都是提前准备好
    fileprivate func  steupUI() {
        backgroundColor = superview?.backgroundColor
        /// 超出范围不显示
        clipsToBounds = true
        
        let rect = CGRect(x: 0, y: pictureOutterMargin, width: YWStatusPictureItemWith, height: YWStatusPictureItemWith)
        let count = 3
        
        for i in 0..<9 {
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let iv = UIImageView(frame: rect)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let xOffset = col * (YWStatusPictureItemWith + pictureInnerMargin)
            
            let yOffset = row * (YWStatusPictureItemWith + pictureInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            iv.backgroundColor = UIColor.red
            addSubview(iv)
        }
        
    }
}
