//
//  CXSingleTableViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTitleModel.h"

typedef enum {
    articleListTypeHome = 0,                       //首页列表
    articleListTypeUserHome = 1,                   //用户文章列表
    articleListTypeMine = 2,                       //自己的文章列表
    articleListTypeSearch = 3,                     //搜索结果
    
}articleListType;

@interface CXSingleTableViewController : UIViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) CategoryTitleModel * category;
@property (nonatomic, assign) articleListType listType;
@property (nonatomic, copy)   NSString * personId;
@property (nonatomic, copy)   NSString * keyword;

-(void)refreshAllData;
@end
