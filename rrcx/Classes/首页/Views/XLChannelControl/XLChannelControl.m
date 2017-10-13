//
//  XLChannelControl.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelControl.h"
#import "XLChannelView.h"
#import "CategoryTitleModel.h"

@interface XLChannelControl ()
{
    UINavigationController *_nav;
    
    XLChannelView *_channelView;
    
    ChannelBlock _block;
}
@property (nonatomic, assign) BOOL isEditing;
@end

@implementation XLChannelControl

+(XLChannelControl*)shareControl{
    static XLChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[XLChannelControl alloc] init];
    });
    return control;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

-(void)buildChannelView{
    
    _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.title = @"频道管理";
    _nav.topViewController.view = _channelView;
    _nav.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClick)];
    _nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
}
-(void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = - _nav.view.bounds.size.height;
        _nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
}

-(void)backMethod
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = - _nav.view.bounds.size.height;
        _nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
    _block(_channelView.inUseTitles,_channelView.unUseTitles);
}

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChannelBlock)block{
    _block = block;
    _channelView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _channelView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_channelView reloadData];
    [self getUnusedCategories];
    [self loadRequest];
    CGRect frame = _nav.view.frame;
    frame.origin.y = - _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        _nav.view.alpha = 1;
        _nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}
-(void)getUnusedCategories{
    
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    
//    [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
//    [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
//    [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
//    [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
//    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCategoryTitlesURL] parameters:@{@"type":@1,@"other":@1} responseCache:^(id responseCache) {
//        
//    } success:^(id responseObject) {
//        if ([responseObject[@"code"] integerValue] == 0) {
//            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:responseObject[@"data"]];
//            _channelView.unUseTitles = [NSMutableArray arrayWithArray:titlesArr];
//            [_channelView reloadData];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    [CXHomeRequest getCategoryTitles:@{@"type":@1,@"other":@1} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:response[@"data"]];
            _channelView.unUseTitles = [NSMutableArray arrayWithArray:titlesArr];
            [_channelView reloadData];
        }
        else{
            [self cancelClick];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadRequest{
    
    [CXHomeRequest getCategoryTitles:@{@"type":@"2"} responseCache:^(id responseCaches) {
        if ([responseCaches[@"code"] intValue] == 0) {
            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:responseCaches[@"data"]];
            _channelView.inUseTitles = [NSMutableArray arrayWithArray:titlesArr];
            [_channelView reloadData];

        }
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:response[@"data"]];
            _channelView.inUseTitles = [NSMutableArray arrayWithArray:titlesArr];
            [_channelView reloadData];

        }
    } failure:^(NSError *error) {
        
    }];
   
    
}
@end
