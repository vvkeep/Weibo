//
//  YWEmoticonInputView.swift
//  表情键盘
//
//  Created by 姚巍 on 16/11/6.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//  表情输入视图

import UIKit
fileprivate let cellID = "cellID"
class YWEmoticonInputView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIView!
    
    ///选中表情回调
    fileprivate var selectedEmoticonCallBack:((_ emoticon: YWEmoticon?) ->())?
    
    /// 加载视图
    ///
    /// - returns: 返回视图
    class func inputView(selectedEmoticon:@escaping (_ emoticon: YWEmoticon?) -> ()) -> YWEmoticonInputView {
        let nib = UINib(nibName: "YWEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! YWEmoticonInputView
        
        //记录闭包哦
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
        
    }
    
    override func awakeFromNib() {
        // collectionView.register(UINib(nibName: "YWEmoticonCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.register(YWEmoticonCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension YWEmoticonInputView: UICollectionViewDataSource {
    ///分组中表情页的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return YWEmoticonManager.shared.packageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YWEmoticonManager.shared.packageArr[section].munberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! YWEmoticonCell
        cell.delegate = self
//        cell.label.text = "\(indexPath.section) -  \(indexPath.row)"
        cell.emoticonArr = YWEmoticonManager.shared.packageArr[indexPath.section].emoticon(page: indexPath.item)
        return cell
    }
}

extension YWEmoticonInputView: YWEmoticonCellDelegate {
    func emoticonCellDidSelectedEmoticon(cell: YWEmoticonCell, em: YWEmoticon?) {
        //执行闭包
        selectedEmoticonCallBack?(em)
    }
}
