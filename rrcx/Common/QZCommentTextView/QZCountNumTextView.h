//
//  QZCountNumTextView.h
//  Application
//
//  Created by MrYu on 2016/12/9.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZCountNumTextView : UITextView

+ (instancetype)countNumTextView;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,assign) NSInteger maxCount;

@end
