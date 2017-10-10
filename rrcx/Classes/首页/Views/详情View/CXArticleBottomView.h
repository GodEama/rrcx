//
//  CXArticleBottomView.h
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXArticleBottomView : UIView
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIImageView * penImageView;
@property (nonatomic,strong) UILabel * writeLab;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * collectBtn;
@property (nonatomic,strong) UIButton * shareBtn;

@property (nonatomic,assign) BOOL isCollected;


@end
