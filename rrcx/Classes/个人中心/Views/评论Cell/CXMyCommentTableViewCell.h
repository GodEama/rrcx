//
//  CXMyCommentTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXMyComment.h"
@interface CXMyCommentTableViewCell : UITableViewCell
@property (nonatomic,strong) CXMyComment * model;
@property (nonatomic,strong) UIButton * deleteBtn;

-(void)setModel:(CXMyComment *)model;
@end
