//
//  CXMineServiceTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMineServiceTableViewCell.h"
@interface CXMineServiceTableViewCell()

@end
@implementation CXMineServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
-(void)setupMainView{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.serviceSwitch];
    [self.contentView addSubview:self.hintLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    [_serviceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    [_hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.serviceSwitch.mas_left).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    
}
-(void)valueChange:(UISwitch *)sender{
    if (self.switchServiceBlock) {
        self.switchServiceBlock(sender.isOn);
    }
    
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
-(UISwitch *)serviceSwitch{
    if (!_serviceSwitch) {
        _serviceSwitch = [[UISwitch alloc] init];
        [_serviceSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _serviceSwitch;
}
-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UILabel new];
        _hintLab.font = [UIFont systemFontOfSize:15];
    }
    return _hintLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
