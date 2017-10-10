//
//  CXSelectAreaViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/13.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXSelectAreaViewController : UIViewController
@property (nonatomic,assign) NSInteger  type;/*1.省 2.市 3.区*/
@property (nonatomic,copy)   NSString * provinceId;
@property (nonatomic,copy)   NSString * cityId;
@property (nonatomic,copy)   NSString * provinceName;
@property (nonatomic,copy)   NSString * cityName;

@property (nonatomic,copy) void(^selectAreaBlock)(NSString * provinceId,NSString * provinceName,NSString * cityId,NSString * cityName);
@end
