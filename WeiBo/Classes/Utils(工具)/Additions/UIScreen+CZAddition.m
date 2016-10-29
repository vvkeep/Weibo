//
//  UIScreen+CZAddition.m
//
//  Created by yao wei on 16/5/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIScreen+CZAddition.h"

@implementation UIScreen (CZAddition)

+ (CGFloat)yw_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)yw_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)yw_scale {
    return [UIScreen mainScreen].scale;
}

@end
