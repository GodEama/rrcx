//
//  CXSelectIndustryView.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSelectIndustryView.h"
#import "AppDelegate.h"
@implementation CXSelectIndustryView
{
    NSInteger  _currentDataIndex;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    if (self) {
        _currentDataIndex  = -1;
        [self initializationViewWithFrame:frame];
    }
    return self;
}

- (void)initializationViewWithFrame:(CGRect)frame {
    UIView * shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [shadowView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    [self addSubview:shadowView];
    //    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/4, 200, kScreenWidth/2, 40*6)];
    //    bgView.backgroundColor = [UIColor whiteColor];
    //    [self addSubview:bgView];
    
    
    
    
    [self addSubview:self.menu];
    
    
}
-(JSDropDownMenu *)menu{
    if (!_menu) {
        _menu = [[JSDropDownMenu alloc] initWithRect:CGRectMake(KWidth/4, 200, KWidth/2, 40) andHeight:40];
        _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
        _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    return _menu;
}
#pragma mark -
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    return _data.count;
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    return _currentDataIndex;
    
    
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    return @"选择文章分类";
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    NSString * cate = _data[indexPath.row];
    return cate;
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    _currentDataIndex = indexPath.row;
    [self removeView];
}





- (void)showInWindow {
    
    self.alpha = 0;
    
    AppDelegate *appDelegate = APPDELEGATE;
    [appDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1;
    }];
}
-(void)removeView
{
    if (_currentDataIndex >= 0) {
        [self getSelectedCat];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)getSelectedCat{
    if (_delegate&&[_delegate respondsToSelector:@selector(selectCate:)]) {
        [_delegate selectCate:_data[_currentDataIndex]];
    }
}


@end
