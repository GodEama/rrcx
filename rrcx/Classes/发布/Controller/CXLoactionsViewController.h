//
//  CXLoactionsViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface CXLoactionsViewController : UIViewController
@property (nonatomic, copy) void(^selectAddressBlock)(AMapPOI * poi);
@property (nonatomic, strong) AMapPOI * lastPoi;

@end
