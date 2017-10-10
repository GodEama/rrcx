//
//  CXTextViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/25.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXTextViewController;

@protocol CXTextViewControllerDelegate <NSObject>

- (void)textViewController:(CXTextViewController *)textViewController saveText:(NSString *)saveText;

@end
@interface CXTextViewController : UIViewController
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) id<CXTextViewControllerDelegate> delegate;
@end
