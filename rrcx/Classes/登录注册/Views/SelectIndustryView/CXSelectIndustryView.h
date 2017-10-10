//
//  CXSelectIndustryView.h
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h"
@protocol CXSelectIndustryViewDelegate <NSObject>

- (void)selectCate:(NSString *)cate;

@end
@interface CXSelectIndustryView : UIView<UIGestureRecognizerDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
@property(nonatomic,strong)id<CXSelectIndustryViewDelegate> delegate;  //声明代理
@property (nonatomic, strong) JSDropDownMenu * menu;
@property (nonatomic,retain) NSArray * data;
- (void)showInWindow;
@end
