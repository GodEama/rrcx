//
//  CXShareTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXArticle.h"
@interface CXShareTableViewCell : UITableViewCell

@property (nonatomic, assign)   BOOL isSelf;
@property (nonatomic,strong) UIButton * optionBtn;

@property (nonatomic,copy) void(^avatarClickBlock)(void);
@property (nonatomic,copy) void(^optionBtnClickBlock)(void);
-(void)setModelDataWith:(CXArticle*)model;

@end
