//
//  QZTopTextView.h
//  circle_iphone
//
//  Created by MrYu on 16/8/17.
//  Copyright © 2016年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"
#import "QZCountNumTextView.h"
@class QZTopTextView;
@protocol QZTopTextViewDelegate <NSObject>

- (void)QZTopTextView:(QZTopTextView*)commentView sendComment:(NSString *)comment;

@end

@interface QZTopTextView : UIView

@property (nonatomic,strong) LPlaceholderTextView *lpTextView;

@property (nonatomic,strong) QZCountNumTextView *countNumTextView;

@property (nonatomic,weak) id<QZTopTextViewDelegate> delegate;

+ (instancetype)topTextView;

@end
