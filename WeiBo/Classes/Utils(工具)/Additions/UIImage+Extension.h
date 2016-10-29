//
//  UIImage+Extension.h
//  XBJob
//
//  Created by xuru on 15/10/27.
//  Copyright © 2015年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
//圆角加边框
+ (UIImage *)imageWithCircleBorderW:(CGFloat)borderW circleColor:(UIColor *)circleColor image:(UIImage *)image;

//聊天界面拉伸图片
+(UIImage *)resizeImage:(NSString *)imageName;

//  图片转base64
+ (NSString *) image2DataURL: (UIImage *) image;

//  base64转图片
+ (UIImage *) dataURL2Image: (NSString *) imgSrc;

//  生成图片名字
+ (NSString *)createTypeAndName: (UIImage *) image;

//裁剪成圆形图片
+(UIImage *) circleImage:(UIImage *)image withParam:(CGFloat)inset;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//把图片缩放到固定大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

//是否包含透明图层
+ (BOOL) imageHasAlpha: (UIImage *) image;

//图片转成Data
+ (NSData *)imageToData: (UIImage *) image;

@end
