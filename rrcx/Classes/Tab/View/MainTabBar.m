//
//  MainTabBar.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 余钦 on 16/5/30.
//  Copyright © 2016年 yuqin. All rights reserved.
//

#import "MainTabBar.h"
#import "MainTabBarButton.h"

@interface MainTabBar ()
@property(nonatomic, strong)NSMutableArray *tabbarBtnArray;
@property(nonatomic, weak)UIButton *writeButton;
@property(nonatomic, weak)MainTabBarButton *selectedButton;
@property (nonatomic, weak) UIView * addView;
@end

@implementation MainTabBar
- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self SetupWriteButton];
    }
    
    return self;
}

- (void)SetupWriteButton{
    UIView * view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, 44, 44);
    UIImageView * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(6, 2, 25, 25)];
    imgview.image = [UIImage imageNamed:@"release"];
    [view addSubview:imgview];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgview.frame)+2, 44, 44-CGRectGetMaxY(imgview.frame))];
    label.text = @"发布";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    
    
    UIButton *writeButton = [UIButton new];
    writeButton.adjustsImageWhenHighlighted = NO;
//    [writeButton setImage:[UIImage imageNamed:@"button_write~iphone"] forState:UIControlStateNormal];
//    [writeButton setTitle:@"写文章" forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(ClickWriteButton) forControlEvents:UIControlEventTouchUpInside];
//    writeButton.bounds = CGRectMake(0, 0, 44, 44);
    writeButton.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    writeButton.backgroundColor = [UIColor clearColor];
    [view addSubview:writeButton];
    [self addSubview:view];
    _addView = view;
    _writeButton = writeButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //self.writeButton.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    self.addView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.subviews.count);
    CGFloat btnH = self.frame.size.height;
    
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        MainTabBarButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        if (nIndex > 0) {
            btnX += btnW;
        }
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
    }
}

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem{
    MainTabBarButton *tabBarBtn = [[MainTabBarButton alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabbarBtnArray addObject:tabBarBtn];
    
    //default selected first one
    if (self.tabbarBtnArray.count == 1) {
        [self ClickTabBarButton:tabBarBtn];
    }
}

- (void)ClickTabBarButton:(MainTabBarButton *)tabBarBtn{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
    
    self.selectedButton.selected = NO;
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}

- (void)ClickWriteButton{
    if ([self.delegate respondsToSelector:@selector(tabBarClickWriteButton:)]) {
        [self.delegate tabBarClickWriteButton:self];
    }
}
@end
