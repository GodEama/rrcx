//
//  DatePicker.h
//  school
//
//  Created by BW on 15/7/23.
//  Copyright (c) 2015年 bw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView

@property (nonatomic, copy) void(^endBlock)(NSDate *date);
@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSDate *maxDate;
@property (nonatomic, retain) NSDate *defaultDate;
/**
 *  时间类型 0年月日 1年月
 */
@property (nonatomic) NSInteger type;

- (void)showInWindow;

@end
