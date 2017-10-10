//
//  CXDiscoverTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXFind.h"
@interface CXDiscoverTableViewCell : UITableViewCell
@property (nonatomic, strong) CXFind * model;
@property (nonatomic, copy)   void(^avatarClickBlock)(void);
@property (nonatomic, copy)   void(^moreActionBlock)(void);
@property (nonatomic, copy)   void(^zanBtnClickBlock)(void);
-(void)setModel:(CXFind *)model;
@end
