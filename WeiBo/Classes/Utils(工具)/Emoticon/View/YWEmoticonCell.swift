//
//  YWEmoticonCell.swift
//  表情键盘
//
//  Created by 姚巍 on 16/11/6.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import UIKit

/// 表情Cell 的协议
@objc protocol YWEmoticonCellDelegate: NSObjectProtocol {
    
    /// 表情cell 选中表情模型
    ///
    /// - Parameter em: 表情模型/nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: YWEmoticonCell, em: YWEmoticon?)
}

class YWEmoticonCell: UICollectionViewCell {
    weak var delegate: YWEmoticonCellDelegate?
    
    var emoticonArr: [YWEmoticon]? {
        didSet {
            for v in contentView.subviews {
                v.isHidden = true
            }
            contentView.subviews.last?.isHidden = false
            
            for (i, em) in (emoticonArr ?? []).enumerated() {
                let btn = contentView.subviews[i] as! UIButton
                btn.setImage(em.image, for: .normal)
                
                //设置 emoji
                btn.setTitle(em.emoji, for: .normal)
                
                btn.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 表情按钮点击事件
    ///
    /// - Parameter btn: 点击的表情按钮
    @objc fileprivate func selectedEmoticonBtn(btn: UIButton) {
        let tag = btn.tag
        var em: YWEmoticon?
        //判断是否是删除按钮，如果不是删除按钮取得表情
        if tag < (emoticonArr ?? []).count {
            em = emoticonArr?[tag]
        }
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
}

fileprivate extension YWEmoticonCell {
    func setupUI() {
        //创建21个按钮
        let rowCount = 3
        let colCount = 7
        
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            contentView.addSubview(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            // 设置tag
             btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonBtn), for: .touchUpInside)
        }
        let removeBtn = contentView.subviews.last as! UIButton
        let image = UIImage (named: "compose_emotion_delete", in: YWEmoticonManager.shared.bundle, compatibleWith: nil)
        removeBtn.setImage(image, for: .normal)
    }
}
