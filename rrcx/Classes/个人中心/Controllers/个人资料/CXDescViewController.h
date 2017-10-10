//
//  CXDescViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/25.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXDescViewController;

@protocol CXDescViewControllerDelegate <NSObject>

- (void)descViewController:(CXDescViewController *)descViewController saveText:(NSString *)saveText;

@end
@interface CXDescViewController : UIViewController
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) id<CXDescViewControllerDelegate> delegate;

@end
