//
//  YWFPSLabel.swift
//  WeiBo
//
//  Created by 姚巍 on 16/10/28.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit
 class YWFPSLabel: UILabel {

    private lazy var disPlayLink = CADisplayLink()
    private lazy var count: NSInteger = 0
    private lazy var lastTime: TimeInterval = 0
    private var fpsColor: UIColor = UIColor.green
    
    override init(frame: CGRect) {
        var yFrame = frame
        if yFrame.origin.x == 0 && yFrame.origin.y == 0 {
            yFrame = CGRect(x: UIScreen.main.bounds.width/2 - (55/2), y: 15, width: 55, height: 20)
        }
        super.init(frame: yFrame)
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        isUserInteractionEnabled = false
        backgroundColor = UIColor.white
        alpha = 0.7
        font = UIFont.systemFont(ofSize: 12)

        disPlayLink = CADisplayLink(target: self, selector: #selector(tick))
        disPlayLink.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        disPlayLink.invalidate()
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize( width: 55, height: 20)
    }
    
    func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta: TimeInterval = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        
        lastTime = link.timestamp
        let fps = Double(count) / delta
        let fpsText = Int(round(fps))
        count = 0
        
        let attrMStr = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(fpsText) FPS" ))
        if fps > 55.0{
            fpsColor = UIColor.green
        } else if(fps >= 50.0 && fps <= 55.0) {
            fpsColor = UIColor.yellow
        } else {
            fpsColor = UIColor.red
        }
        
        attrMStr.setAttributes([NSForegroundColorAttributeName:fpsColor], range: NSMakeRange(0, attrMStr.length - 3))
        attrMStr.setAttributes([NSForegroundColorAttributeName:UIColor.black], range: NSMakeRange(attrMStr.length - 3, 3))
        self.attributedText = attrMStr
    }
}
