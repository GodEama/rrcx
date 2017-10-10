//
//  DateView.h
//  nq
//
//  Created by 一仓科技 on 15/12/18.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateView : UIView

@property (nonatomic, retain) NSDate *maxDate;
@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, copy) void(^block)(NSDate *date);

- (void)showInWindow;

@end
