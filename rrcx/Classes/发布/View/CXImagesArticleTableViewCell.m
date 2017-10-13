//
//  CXImagesArticleTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/7.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXImagesArticleTableViewCell.h"
#import "UIButton+WebCache.h"

@interface CXImagesArticleTableViewCell()
@property (nonatomic,strong) UIView * bgView;

@property (nonatomic,strong) UIButton * imageBtn;
@property (nonatomic,strong) UILabel * descLab;


@end

@implementation CXImagesArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}
-(void)setupViews{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.deleteBtn];
    [self.bgView addSubview:self.upBtn];
    [self.bgView addSubview:self.downBtn];
    [self.bgView addSubview:self.imageBtn];
    [self.bgView addSubview:self.descLab];
    [self.contentView addSubview:self.addBtn];
    [self.bgView addSubview:self.textBtn];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@126);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(2);
        make.top.equalTo(self.bgView).offset(2);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    [_upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-2);
        make.top.equalTo(self.bgView).offset(2);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-2);
        make.bottom.equalTo(self.bgView).offset(-2);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteBtn.mas_right).offset(2);
        make.top.equalTo(self.deleteBtn.mas_bottom).offset(2);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
       // make.bottom.equalTo(self.bgView).offset(-12).priorityHigh();
    }];
    [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageBtn.mas_right).offset(8);
        make.top.equalTo(self.imageBtn);
        make.right.equalTo(self.upBtn.mas_left).offset(-8);
        make.height.lessThanOrEqualTo(self.imageBtn.mas_height);
    }];
    
    [_textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLab);
        make.right.equalTo(self.descLab);
        make.top.equalTo(self.descLab);
        make.bottom.equalTo(self.imageBtn);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bgView.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = RGB(238,239, 240).CGColor;
    
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.cornerRadius = 4;
//    _addBtn.layer.borderWidth = 1;
//    _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_textBtn addTarget:self action:@selector(textClick) forControlEvents:UIControlEventTouchUpInside];

}
-(void)addBtnClick{
    if (self.addImageBlock) {
        self.addImageBlock();
    }
}
-(void)textClick{
    if (self.editTextBlock) {
        self.editTextBlock();
    }
}
-(void)setModel:(CXImageItem *)model{
    _model = model;
    NSString * imgUrl = model.imagePath;
    NSString * text = model.desc;
    if ([imgUrl containsString:@"http"]) {
        [_imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];

    }
    else{
        
        NSString * filePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",imgUrl]];
        [_imageBtn setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        
    }
    if (text&&text.length >0) {
        _descLab.text = text;
        _descLab.textColor = RGB(45, 46, 47);
    }else{
        _descLab.text = @"点击添加文字";
        _descLab.textColor = [UIColor lightGrayColor];
    }
    
}







-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgView;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"article_delete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
-(UIButton *)upBtn{
    if (!_upBtn) {
        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upBtn setImage:[UIImage imageNamed:@"article_up"] forState:UIControlStateNormal];
    }
    return _upBtn;
}
-(UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setImage:[UIImage imageNamed:@"article_down"] forState:UIControlStateNormal];
    }
    return _downBtn;
}

-(UIButton *)imageBtn{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageBtn;
}
-(UILabel *)descLab{
    if (!_descLab) {
        _descLab = [UILabel new];
        _descLab.numberOfLines = 0;
        _descLab.textColor = RGB(45, 46, 47);
        _descLab.font = [UIFont systemFontOfSize:14];
    }
    return _descLab;
}
-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"article_addBtn"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

-(UIButton *)textBtn{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textBtn.backgroundColor = [UIColor clearColor];
    }
    return _textBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
