//
//  CXMyMessagesViewController.m
//  rrcx
//
//  Created by 123 on 2017/10/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyMessagesViewController.h"

@interface CXMyMessagesViewController ()

@end

@implementation CXMyMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CXHomeRequest getMyMessages:@{@"page":@1,@"page_size":@10} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
