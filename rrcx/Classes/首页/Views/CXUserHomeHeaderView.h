//
//  CXUserHomeHeaderView.h
//  rrcx
//
//  Created by 123 on 2017/9/8.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXUserHomeHeaderView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLab;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UILabel *followCountLab;

@property (weak, nonatomic) IBOutlet UIButton *followCountBtn;

@property (weak, nonatomic) IBOutlet UIImageView *VImgView;

@property (weak, nonatomic) IBOutlet UILabel *VLab;
@property (weak, nonatomic) IBOutlet UILabel *VnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (nonatomic,copy) NSString * member_nick;
@property (nonatomic,copy) NSString * member_focus;

@property (nonatomic,copy) NSString *member_follows;

@property (nonatomic,copy) NSString *member_visitor;
@property (nonatomic,copy) NSString *member_avatar;
@property (nonatomic,copy) NSString * member_id;
@property (nonatomic,assign) BOOL isAttention;
@property (nonatomic,copy) void(^fansClickBlock)(void);
@property (nonatomic,copy) void(^focusClickBlock)(void);

@end
