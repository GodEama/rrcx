//
//  CXBlogDetailHeaderTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXBlogDetailModel.h"
@interface CXBlogDetailHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong) CXBlogDetailModel * model;
@property (nonatomic, copy)   void(^avatarClickBlock)(void);
@property (nonatomic, copy)   void(^moreActionBlock)(void);
@property (nonatomic, copy)   void(^zanBtnClickBlock)(void);
@property (nonatomic, assign) BOOL isAttention;
-(void)setModel:(CXBlogDetailModel *)model;
@end
