//
//  CXUserAvatarTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserAvatarTableViewCell.h"

@implementation CXUserAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setupViews{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 15;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab  = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = RGB(28, 28, 28);
    }
    return _titleLab;
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        
    }
    return _imgView;
}
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
