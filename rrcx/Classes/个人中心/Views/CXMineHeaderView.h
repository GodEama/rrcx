//
//  CXMineHeaderView.h
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXMineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLab;
@property (weak, nonatomic) IBOutlet UILabel *attentionCountLab;
@property (weak, nonatomic) IBOutlet UILabel *visitCountLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topImageHeight;

@property (nonatomic,copy) void(^avatarClickBlock)(void);

@property (nonatomic,copy) void(^fansClickBlock)(void);
@property (nonatomic,copy) void(^focusClickBlock)(void);
@property (nonatomic,copy) void(^visitorClickBlock)(void);

@property (nonatomic,copy) NSString * member_nick;
@property (nonatomic,copy) NSString * member_focus;

@property (nonatomic,copy) NSString *member_follows;

@property (nonatomic,copy) NSString *member_visitor;
@property (nonatomic,copy) NSString *member_avatar;




@end
