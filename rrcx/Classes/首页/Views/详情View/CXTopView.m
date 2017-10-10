//
//  CXTopView.m
//  rrcx
//
//  Created by 123 on 2017/9/30.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXTopView.h"
#import "UIButton+WebCache.h"
@interface CXTopView()
@property (nonatomic,strong) UIButton * avatarBtn;
@property (nonatomic,strong) UIButton * optionBtn;
@property (nonatomic,strong) UILabel  * nickLabel;
@property (nonatomic,strong) UIButton * followBtn;
@end
@implementation CXTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}



-(void)initSubViews{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@44);
    }];
    [view addSubview:self.avatarBtn];
    [view addSubview:self.nickLabel];
    [view addSubview:self.followBtn];
    [view addSubview:self.optionBtn];
    [view addSubview:self.backBtn];
    
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
   
    [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-8);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.optionBtn.mas_left).offset(-8);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(48, 25));
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBtn.mas_right).offset(8);
        make.centerY.equalTo(self.avatarBtn);
        make.right.lessThanOrEqualTo(self.followBtn.mas_left);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(8);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(18, 32));
    }];
    self.avatarBtn.layer.masksToBounds = YES;
    self.avatarBtn.layer.cornerRadius = 20;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 4;
    
}

-(void)setIsFollow:(BOOL)isFollow{
    _isFollow = isFollow;
    if (!isFollow) {
        self.followBtn.backgroundColor = BasicColor;
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.1;
        self.followBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else{
        self.followBtn.backgroundColor = [UIColor clearColor];
        [self.followBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 1;
        self.followBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}
-(void)setMember_nick:(NSString *)member_nick{
    _member_nick = member_nick;
    self.nickLabel.text = member_nick;
    
}
-(void)setMember_avatar:(NSString *)member_avatar{
    _member_avatar = member_avatar;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:member_avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
}
-(void)setMember_id:(NSString *)member_id{
    _member_id = member_id;
    if (User_id&&[member_id isEqualToString:User_id]) {
        self.followBtn.hidden = YES;
    }
    else{
        self.followBtn.hidden = NO;
    }
}
-(void)followBtnClick:(UIButton *)sender{
    
    [CXHomeRequest attentionUserWithParameters:@{@"action":self.isFollow?@1:@2,@"member_id":_member_id} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            if (_isFollow) {
                [self setIsFollow:YES];
            }
            else{
                [self setIsFollow:NO];
            }
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}





-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _avatarBtn;
}

-(UIButton *)optionBtn{
    if (!_optionBtn) {
        _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionBtn setImage:[UIImage imageNamed:@"option-w"] forState:UIControlStateNormal];

    }
    return _optionBtn;
}


-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel  = [UILabel new];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.textColor = [UIColor whiteColor];
        
    }
    return _nickLabel;
}


-(UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"arrowhead-w"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
@end
