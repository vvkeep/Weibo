//
//  YWNewFeatureView.swift
//  WeiBo
//
//  Created by yao wei on 16/9/18.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWNewFeatureView: UIView {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterBtn: UIButton!
    
    
    @IBAction func enterBtnAction(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    class func newFeatureView()-> YWNewFeatureView{
        let nib = UINib(nibName: "YWNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! YWNewFeatureView
        //从xib 加载的视图 默认 600* 600
        v.frame  = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        
        //设置 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self;
    }
}


extension YWNewFeatureView :UIScrollViewDelegate {

    //滑动结束减速的时候调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 滚动到最后一屏，让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        pageControl.currentPage = page
        //倒数第二页显示按钮
        enterBtn.isHidden = (page != scrollView.subviews.count - 1)
        
        //判断是否最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
    }
    
    //只要滑动就掉用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        enterBtn.isHidden = true
        
        //计算当前是偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        //分页隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
        
       
    }
    
    
}
