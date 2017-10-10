//
//  CXTopBar.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXTopBar.h"



@interface CXTopBar ()
@property(nonatomic,strong) UIImageView *rightIconBtn;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIImageView *serachImg;
@property(nonatomic,strong) UILabel *searchTipLable;
@property(nonatomic,strong) UIButton *searchBtn;
@end

@implementation CXTopBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if(self=[super init])
    {
        [self setupSubviews];
    }
    return self;
}


-(void)setupSubviews
{
    self.frame=CGRectMake(0, 0, KWidth, kTopHeight);
    
    self.backgroundColor=BasicColor;
    [self addSubview: self.rightIconBtn];
    [self addSubview: self.centerView];
    [self.centerView addSubview: self.serachImg];
    [self.centerView addSubview: self.searchTipLable];
    [self.centerView addSubview: self.searchBtn];
    [self.rightIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.bottom.equalTo(self).offset(-8);
        
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightIconBtn.mas_left).offset(-15);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-8);
        make.height.mas_equalTo(30);
    }];
    [self.serachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self.centerView);
    }];
    
    [self.searchTipLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerView);
        make.left.equalTo(self.serachImg.mas_right).offset(10);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView);
        make.top.equalTo(self.centerView);
        make.size.mas_equalTo(self.centerView);
    }];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        
    }
    return  self;
}

-(UIImageView *)rightIconBtn{
    if(!_rightIconBtn){
        _rightIconBtn=[UIImageView new];
        _rightIconBtn.image=[UIImage imageNamed:@"nav_messsage"];
        _rightIconBtn.layer.cornerRadius=16;
        _rightIconBtn.layer.masksToBounds=YES;
    }
    return _rightIconBtn;
}

-(UIView*)centerView{
    if(!_centerView){
        _centerView=[UIView new];
        _centerView.layer.cornerRadius=4;
        _centerView.backgroundColor=[UIColor whiteColor];
    }
    return _centerView;
}

-(UIImageView*)serachImg{
    if(!_serachImg){
        _serachImg=[UIImageView new];
        _serachImg.image=[UIImage imageNamed:@"search_small"];
        
    }
    return _serachImg;
}

-(UILabel *)searchTipLable{
    if(!_searchTipLable){
        _searchTipLable=[UILabel new];
        _searchTipLable.font=[UIFont systemFontOfSize:13];
        _searchTipLable.text=@"搜索";
        _searchTipLable.textColor=[UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1];
    }
    return _searchTipLable;
}
-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton new];
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(void)searchBtnClick{
    if (self.searchClickBlock) {
        self.searchClickBlock();
    }
}


@end
