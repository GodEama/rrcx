//
//  CXUserInfoTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserInfoTableViewCell.h"

@implementation CXUserInfoTableViewCell

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
    [self.contentView addSubview:self.detailLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-8);
        make.left.greaterThanOrEqualTo(self.titleLab.mas_right).offset(8);
    }];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab  = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = RGB(28, 28, 28);
    }
    return _titleLab;
}
-(UILabel *)detailLab{

    if (!_detailLab) {
        _detailLab = [UILabel new];
        _detailLab.textColor = RGB(194, 195, 196);
        _detailLab.font = [UIFont systemFontOfSize:14];
    }
    return _detailLab;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
