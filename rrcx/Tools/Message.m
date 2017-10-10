//
//  Message.m
//  CarWash
//
//  Created by BW on 14-6-10.
//  Copyright (c) 2014年 bw. All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
static BOOL isShow = YES;
static Message *message = nil;

@interface Message ()<UIAlertViewDelegate>

@end

@implementation Message

+ (void)showMessageWithConfirm:(BOOL)confirm
                         title:(NSString *)title {
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = title;
//    hud.labelFont = [UIFont systemFontOfSize:15];
//    hud.margin = 10.f;
//    hud.yOffset = 0;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    if (!message) {
        message = [[Message alloc] init];
    }
    [message getMessageWithConfirm:confirm
                             title:title];
}
+ (void)showMessageWithConfirm:(BOOL)confirm
                         info:(NSString *)info {
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = info;
//    hud.labelFont = [UIFont systemFontOfSize:15];
//    hud.margin = 10.f;
//    hud.yOffset = 0;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    if (!message) {
        message = [[Message alloc] init];
    }
    [message getMessageWithConfirm:confirm
                             message:info];
}

- (void)getMessageWithConfirm:(BOOL)confirm
                        message:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:confirm ? @"确认" : nil
                                              otherButtonTitles:nil];
    alertView.delegate = self;
    if (!isShow) {
        return;
    }
    [alertView show];
    isShow = NO;
    if (!confirm) {
        [Message performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
    }
}
- (void)getMessageWithConfirm:(BOOL)confirm
                        title:(NSString *)title {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:confirm ? @"确认" : nil
                                              otherButtonTitles:nil];
    alertView.delegate = self;
    if (!isShow) {
        return;
    }
    [alertView show];
    isShow = NO;
    if (!confirm) {
        [Message performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.0];
    }
}

+ (void)dismissAlertView:(UIAlertView *)alert {
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    isShow = YES;
}

#pragma mark -UIAlertViewDelegate-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    isShow = YES;
}


+(BOOL)showNoLoginWithResult:(id)responseObject{
    if ([responseObject[@"login"] integerValue] == 0) {
        [self showMessageWithConfirm:NO title:@"请先登录"];
        return NO;
    }
    else{
        return YES;
    }
}
# pragma mark - HUD

+(void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    [hud setOffset:CGPointMake(0, 0)];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}


@end
