//
//  CXChannelManagementViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/18.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXChannelManagementViewController.h"
#import "XLChannelControl.h"
@interface CXChannelManagementViewController ()

@end

@implementation CXChannelManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XLChannelControl";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showChannel];
}
-(void)showChannel
{
    NSArray *arr1 = @[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"];
    NSArray *arr2 = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿"];
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        NSLog(@"inUseTitles = %@",inUseTitles);
        NSLog(@"unUseTitles = %@",unUseTitles);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
