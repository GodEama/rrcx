//
//  CXTopView.h
//  rrcx
//
//  Created by 123 on 2017/9/30.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXTopView : UIView
@property (nonatomic,copy) NSString * member_id;
@property (nonatomic,copy) NSString *member_avatar;
@property (nonatomic,copy) NSString *member_nick;
@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic,strong) UIButton * backBtn;


@end
