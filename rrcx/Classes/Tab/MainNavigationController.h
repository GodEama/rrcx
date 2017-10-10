//
//  MainNavigationController.h
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 余钦 on 16/5/30.
//  Copyright © 2016年 yuqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController
- (UIViewController *)childViewControllerForStatusBarStyle;
@end
