//
//  CXArticleDetailHeader.h
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXArticleDetailModel.h"
@interface CXArticleDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLab;

@property (nonatomic,assign) BOOL isAttention;
@property (nonatomic,assign) BOOL isLike;
@property (nonatomic, strong)CXArticleDetailModel * model;

@property (nonatomic,copy) void(^lookAuthorHomeBlock)(void);

@end
