//
//  CXSingleTableViewController_1.h
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTitleModel.h"

typedef enum {
    microblogListTypeHome = 0,                       //首页列表
    microblogListTypeUserHome = 1,                   //用户文章列表
    microblogListTypeMine = 2,                       //自己的文章列表
    microblogListTypeSearch = 3,                     //搜索结果
    
}microblogListType;

@interface CXSingleTableViewController_1 : UIViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) CategoryTitleModel * category;
@property (nonatomic, assign) microblogListType blogListType;
@property (nonatomic, copy)   NSString * personId;
-(void)refreshAllData;
@end
