//
//  YWEmoticonLayout.swift
//  表情键盘
//
//  Created by 姚巍 on 16/11/6.
//  Copyright © 2016年 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import UIKit

class YWEmoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        itemSize  = collectionView.bounds.size
//        minimumLineSpacing = 0
//        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }
}
