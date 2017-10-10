//
//  CXFansTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXListPeople.h"
@interface CXFansTableViewCell : UITableViewCell
@property (nonatomic, strong) CXListPeople * people;
@property (nonatomic, copy)   void(^followBtnClickBlock)(void);
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic,strong) UIButton * followBtn;

-(void)setPeople:(CXListPeople *)people;
@end
