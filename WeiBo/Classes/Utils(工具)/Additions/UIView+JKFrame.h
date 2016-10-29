//
//  UIView+JKFrame.h
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JKFrame)
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint yw_origin;
@property (nonatomic, assign) CGSize yw_size;

// shortcuts for positions
@property (nonatomic) CGFloat yw_centerX;
@property (nonatomic) CGFloat yw_centerY;


@property (nonatomic) CGFloat yw_top;
@property (nonatomic) CGFloat yw_bottom;
@property (nonatomic) CGFloat yw_right;
@property (nonatomic) CGFloat yw_left;

@property (nonatomic) CGFloat yw_width;
@property (nonatomic) CGFloat yw_height;
@end
