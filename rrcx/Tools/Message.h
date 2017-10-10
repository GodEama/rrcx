//
//  Message.h
//  CarWash
//
//  Created by BW on 14-6-10.
//  Copyright (c) 2014年 bw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Message : UIView

+ (void)showMessageWithConfirm:(BOOL)confirm
                         title:(NSString *)title;
+ (void)showMessageWithConfirm:(BOOL)confirm
                          info:(NSString *)info;
+(BOOL)showNoLoginWithResult:(id)responseObject;

+(void)showMiddleHint:(NSString *)hint;
@end
