//
//  CXTopBar.h
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXTopBar : UIView
@property (nonatomic, copy) void(^searchClickBlock)(void);
@property (nonatomic, copy) void(^messageClickBlock)(void);

@end
