//
//  QZTopTextView.m
//  circle_iphone
//
//  Created by MrYu on 16/8/17.
//  Copyright © 2016年 ctquan. All rights reserved.
//

#import "QZTopTextView.h"
#import "CommonDef.h"

@interface QZTopTextView()
{
    UIButton *_issueBtn;
    UIView *_bgView;
    UITapGestureRecognizer *_tap;
}
@end

@implementation QZTopTextView

+ (instancetype)topTextView
{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ConvertTo6_H(316)*CT_SCALE_Y);
        // 切换中文九宫格所有数据都对 但是现实会有一个差不多10的间距  加大高度 补足 多的部分键盘挡住 视觉效果没有变
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ConvertTo6_H(400)*CT_SCALE_Y);
//        self.lpTextView.scrollsToTop = NO;
        self.countNumTextView.scrollsToTop = NO;
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [self makeSubView];
        // 添加键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)notif
{
    
    if ([self.countNumTextView isFirstResponder]) {
        NSDictionary *info = [notif userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        //        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyboardSize = [value CGRectValue].size;
        NSLog(@"keyboardSize.height%f",keyboardSize.height);
        
        // 5s ios10 可能有问题  带验证
        [UIView animateWithDuration:0.5 animations:^{
            if (keyboardSize.height == 292.0 || keyboardSize.height == 282.0) {
                // 适配搜狗输入法 分别在6p  6/5s 高度
                self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316)*CT_SCALE_Y + 26.0;
            }else{
                self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316)*CT_SCALE_Y ;
            }
            
//            self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316)*CT_SCALE_Y ;
        }];
        [self.superview addSubview:_bgView];
        [self.superview addSubview:self];
    }
}
- (void)keyboardWillDisappear:(NSNotification *)notif
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.y = SCREEN_HEIGHT;
    }];
    [_bgView removeFromSuperview];
}

#pragma mark - 非通知调用键盘消失方法
- (void)keyboardWillDisappear
{
    [self.countNumTextView resignFirstResponder];
}


-(void)makeSubView
{
    // 输入框
    self.countNumTextView.frame = CGRectMake(ConvertTo6_W(30)*CT_SCALE_X, 10, SCREEN_WIDTH - 2 * ConvertTo6_W(30)*CT_SCALE_X, ConvertTo6_H(200)*CT_SCALE_Y);
    self.countNumTextView.placeholder = @"请输入你的评论";
    self.countNumTextView.font = [UIFont systemFontOfSize:14];
    self.countNumTextView.textColor = UIColorFromRGB(0x333333);
    self.countNumTextView.layer.borderWidth = 0.5;
    self.countNumTextView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    self.countNumTextView.layer.cornerRadius = 2;
    self.countNumTextView.clipsToBounds = YES;
    [self addSubview:self.countNumTextView];
    
    // @"发布"btn
    _issueBtn = [[UIButton alloc] init];
    _issueBtn.width = ConvertTo6_W(114)*CT_SCALE_X;
    _issueBtn.height = ConvertTo6_H(54)*CT_SCALE_Y;
    // 右边对齐输入框
    _issueBtn.x = self.countNumTextView.x + self.countNumTextView.width - _issueBtn.width;
    _issueBtn.y = self.countNumTextView.y + self.countNumTextView.height + 10;
    [_issueBtn setTitle:@"发布" forState:UIControlStateNormal];
    _issueBtn.backgroundColor = UIColorFromRGB(0x00a0ff);
    _issueBtn.layer.cornerRadius = 2;
    _issueBtn.clipsToBounds = YES;
    [_issueBtn addTarget:self action:@selector(issueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_issueBtn];
    
    // 半透明灰色背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = UIColorFromRGB(0x000000);
    _bgView.alpha = 0.5;
    
    _tap = [[UITapGestureRecognizer alloc] init];
    [_tap addTarget:self action:@selector(keyboardWillDisappear)];
    [_bgView addGestureRecognizer:_tap];
}

#pragma mark - 点击发布按钮
- (void)issueBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(QZTopTextView:sendComment:)]) {
        [self.countNumTextView resignFirstResponder];
        [self.delegate QZTopTextView:self sendComment:_countNumTextView.text];
    }
}

- (LPlaceholderTextView *)lpTextView
{
    if (!_lpTextView) {
        LPlaceholderTextView *lpTextView=[[LPlaceholderTextView alloc] init];
        _lpTextView = lpTextView;
    }
    return _lpTextView;
}

- (QZCountNumTextView *)countNumTextView
{
    if (!_countNumTextView) {

        _countNumTextView = [QZCountNumTextView countNumTextView];
        _countNumTextView.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 150);
        _countNumTextView.placeholder = @"分享新鲜事...";
        _countNumTextView.maxCount = 100;
    }
    return _countNumTextView;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bgView removeGestureRecognizer:_tap];
}
@end
