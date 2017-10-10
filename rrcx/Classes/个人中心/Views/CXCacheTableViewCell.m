//
//  CXCacheTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/8.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXCacheTableViewCell.h"

@implementation CXCacheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMainView];
    }
    return self;
}

-(void)setupMainView{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.hintLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];

    [_hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UILabel new];
        _hintLab.font = [UIFont systemFontOfSize:15];
        _hintLab.textColor = RGB(136, 136, 136);
    }
    return _hintLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
