//
//  YWStatusListViewModel.swift
//  WeiBo
//
//  Created by 姚巍 on 16/9/15.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import Foundation
import SDWebImage
/// 微博数据列表视图模型
/**
 - 如果需要使用KVC 或者字典转模型框架设置对象值 类就需要继承NSObject
 - 如果只是包装了一些代码逻辑（写了一些函数）可以不用任何父类 好处 更加轻量级
 */

//上拉刷新最大尝试次数
fileprivate let maxPullupTryTimes = 3

class YWStatusListViewModel {
    //微博视图模型数组懒加载
    lazy var statusList = [YWStatusViewModel]()
    
    ///上拉刷新错误次数
    fileprivate var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - parameter pullup: 是否上拉刷新标记
    /// - parameter completion: 完成回调[网络请求是否成功/是否刷新表格]
    func loadStatud(isPullup:Bool, completion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        //判断是否是上拉刷新，同时检查刷新错误
        if isPullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        
        //上拉 下拉 只能存在一种 since_id 和max_id  同时只能一个有值 另一个为 默认值 0
        // since_id 取出数组中第一条微博的 id
        let since_id = isPullup ? 0 :(statusList.first?.status.id ?? 0)
        //max_id 取出数组最后一条微博的 id
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) :0
        
        YWNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSucess) in
            
            // 判断网络请求是否成功
            if !isSucess{
                //直接返回
                completion(false, false)
                return
            }
            //1.字典转模型
            var array = [YWStatusViewModel]()
            
            //遍历服务器返回字典数组，字典转模型
            
            for dic in list ?? [] {
                
                //创建微博模型 - 创建失败 继续遍历
                guard let model = YWStatus.yy_model(with: dic) else{
                    continue
                }
                //将视图模型添加到数组
                array.append(YWStatusViewModel(model: model))
            }
            
            //            guard let array = NSArray.yy_modelArray(with: YWStatus.self, json: list ?? []) as? [YWStatus] else{
            //                completion(isSucess,false)
            //                return
            //            }
            
            //拼接数据
            if isPullup {
                //上拉刷新后，将结果拼接在数组的末尾
                self.statusList += array
            } else {
                //下拉刷新 应该讲结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
//            print("刷新了\(array.count)条数据\(array)")
            
            //判断 上拉刷新的数据量
            if isPullup && array.count == 0 {
                
                self.pullupErrorTimes += 1
                completion(isSucess, false)
                
            }else {
                
                self.cacheSingleImage(list: array,finished:completion)
            }
            
        }
    }
    
    
    /// 缓存本次下载微博数据数组中是单张图像
    ///
    /// - parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list: [YWStatusViewModel], finished:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
    
        //调度组
        let group = DispatchGroup()
        
        //记录数据长度
        var length = 0
        
        for vm in list {
            if vm.picURLs?.count != 1 {
                continue
            }
            
            /// 代码执行到此，数组中有且仅有一张图片
            guard let picUrl = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: picUrl) else {
                    continue
            }
            
            //入组
            group.enter()
            
            //下载图像  downloadImage 是SDWebImage 的核心方法 图片下载完成后 会自动保存到沙盒中 文件路径是 url 的 MD5
         
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                    
                    //NSData 是 length 属性
                    length += data.count
                    //图像缓存成功 更新配图视图大小
                    vm.updateImageSize(image: image)
                    
                }
                //出组 -放在回调的最后一句
                group.leave()
            })
            
        }
        
        group.notify(queue: DispatchQueue.main) { 
            print("图像缓存\(length/1024)k")
            
            //完成回调
            finished(true, true)
            
        }
    }
    
 }
