//
//  YWMTRefreshView.swift
//  refreshDemo
//
//  Created by 姚巍 on 16/10/5.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import UIKit

class YWMTRefreshView: YWRefreshView {

    @IBOutlet weak var buildIV: UIImageView!
 
    @IBOutlet weak var earthIV: UIImageView!

    @IBOutlet weak var kangarooIV: UIImageView!
    
   override var parentViewHeight: CGFloat {
    
        didSet {
            
            if parentViewHeight < 25 {
                return
            }
            var scale :CGFloat
            if parentViewHeight > 122 {
                scale = 1
            }else {
            scale = 1-((122 - parentViewHeight)/(122 - 25))
            }
            
            kangarooIV.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
  
    
    override func awakeFromNib() {
        //1.房子
        let bImg1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImg2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildIV.image = UIImage.animatedImage(with: [bImg1,bImg2], duration: 0.5)
        
        //2.地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthIV.layer.add(anim, forKey: nil)
        
        //袋鼠
        
        let KImg1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let Kimg2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        kangarooIV.image = UIImage.animatedImage(with: [KImg1,Kimg2], duration: 0.4)
        
        kangarooIV.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        //设置锚点
        kangarooIV.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置center
        kangarooIV.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height - 25)
    }
}
