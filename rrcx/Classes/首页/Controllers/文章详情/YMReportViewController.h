//
//  YMReportViewController.h
//  YunMuFocus
//
//  Created by apple on 2017/5/5.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMReportViewController : UIViewController
typedef NS_ENUM(NSInteger,reportType){
    reportTypeArticle   = 2,
    reportTypeUser      = 1,
    reportTypeBlog      = 3,
    reportTypeComment   = 4,
};

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * articleId;
@property (nonatomic, assign) reportType reportType;
@end
