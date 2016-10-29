//
//  Bundle+Extension.swift
//  WeiBo
//
//  Created by yao wei on 16/9/9.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import Foundation

extension Bundle {

    //计算性属性 类似于函数 没有参数 有返回值
    var nameSpace : String {
    
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
