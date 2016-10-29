//
//  UIViewController+CZAddition.m
//
//  Created by yao wei on 16/5/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIViewController+CZAddition.h"

@implementation UIViewController (CZAddition)

- (void)yw_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}

@end
