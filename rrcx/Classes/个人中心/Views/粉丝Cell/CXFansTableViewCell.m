//
//  CXFansTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXFansTableViewCell.h"
@interface CXFansTableViewCell()
@property (nonatomic,strong) UIImageView * avatarImgView;
@property (nonatomic,strong) UILabel * nicknameLabel;
@property (nonatomic,strong) UILabel * introLabel;
@end
@implementation CXFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)initSubviews{
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.introLabel];
    [self.contentView addSubview:self.followBtn];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView).priorityLow();
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.avatarImgView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.top.equalTo(self.avatarImgView);
        make.right.equalTo(self.followBtn.mas_left).offset(-8);
        
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel);
        make.bottom.equalTo(self.avatarImgView);
        make.right.equalTo(self.nicknameLabel);
    }];
    
    [self.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 2;
    
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 20;
    

}

-(void)followBtnClick:(UIButton*)btn{
    [CXHomeRequest attentionUserWithParameters:@{@"action":self.isFollow?@2:@1,@"member_id":_people.member_id} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            if (_isFollow) {
                [self setIsFollow:NO];
            }
            else{
                [self setIsFollow:YES];
            }
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setPeople:(CXListPeople *)people{
    _people = people;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:people.member_avatar] placeholderImage:nil];
    self.nicknameLabel.text = people.member_nick;
    self.introLabel.text = people.member_intro;
    self.isFollow = people.is_followed;
}
-(void)setIsFollow:(BOOL)isFollow{
    _isFollow = isFollow;
    if (isFollow) {
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 1;
        self.followBtn.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.followBtn.backgroundColor = [UIColor whiteColor];
        
    }
    else{
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.1;
        self.followBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.followBtn.backgroundColor = BasicColor;
        
    }

}




-(UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = [UIFont systemFontOfSize:15];
        _nicknameLabel.textColor  = UIColorFromRGB(0x2d2d2d);
    }
    return _nicknameLabel;
}
-(UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [UILabel new];
        _introLabel.font = [UIFont systemFontOfSize:12];
        _introLabel.textColor =UIColorFromRGB(0xa5a5a5);
    }
    return _introLabel;
}
-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        
    }
    return _avatarImgView;
}
-(UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _followBtn;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
