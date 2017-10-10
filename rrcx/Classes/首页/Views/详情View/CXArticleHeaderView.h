//
//  CXArticleHeaderView.h
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXArticleDetailModel.h"
@interface CXArticleHeaderView : UIView
@property (nonatomic, strong)CXArticleDetailModel * model;
@property (nonatomic,assign) BOOL isAttention;
@property (nonatomic, copy) void(^setViewHeightBlock)(CGFloat webHeight);

@property (nonatomic,copy) void(^lookAuthorHomeBlock)(void);
@end
