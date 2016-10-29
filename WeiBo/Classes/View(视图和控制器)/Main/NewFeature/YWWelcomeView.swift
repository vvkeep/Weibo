
//
//  YWWelcomeView.swift
//  WeiBo
//
//  Created by yao wei on 16/9/18.
//  Copyright © 2016年 yao wei. All rights reserved.
//  欢迎视图

import UIKit
import SDWebImage
class YWWelcomeView: UIView {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconCons: NSLayoutConstraint!
    
    class func welcomeView()-> YWWelcomeView{
        let nib = UINib(nibName: "YWWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! YWWelcomeView
      //从xib 加载的视图 默认 600* 600
        v.frame  = UIScreen.main.bounds
        return v
    }
    
    // 此方法只是刚刚从xib 从二进制文件将视图数据在家完成 还没和代码建立联系  不要在这个方法里处理UI
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        guard let urlStr = YWNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlStr)
            else {
                return
        }
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        // - 使用自动布局 就不要用frame了
        iconView.layer.cornerRadius = iconCons.constant * 0.5
        iconView.layer.masksToBounds = true
        
    }

    //视图被添加到window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
         layoutIfNeeded()
        bottomCons.constant = bounds.size.height - 200
        //视图使用自动布局来设置的 只是设置了约束
        //当视图被添加到窗口上时，根据父视图的大小 计算约束值 更新控件位置
        //layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // 执行之后，控件所在位置 就是xib中布局的位置

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            self.layoutIfNeeded()
            }) { (_) in
            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.alpha = 1
                }, completion: { (_) in
                    self.removeFromSuperview()
            })
        }
        
        
    }
}
