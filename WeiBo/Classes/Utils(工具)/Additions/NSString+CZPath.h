//
//  NSString+CZPath.h
//
//  Created by yao wei on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZPath)

/// 给当前文件追加文档路径
- (NSString *)yw_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)yw_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)yw_appendTempDir;

@end
