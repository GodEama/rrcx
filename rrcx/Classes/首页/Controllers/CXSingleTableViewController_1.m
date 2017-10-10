//
//  CXSingleTableViewController_1.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSingleTableViewController_1.h"
#import "CXDiscoverTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXUserHomeViewController.h"
#import "SelectView.h"
#import "CXBlogDetailViewController.h"
@interface CXSingleTableViewController_1 ()<UITableViewDelegate,UITableViewDataSource,SelectViewDelegate>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) CXFind * blog;
@end
static NSString *const discoverCell=@"discoverCell";
@implementation CXSingleTableViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _data = [NSMutableArray new];
//    [_data addObjectsFromArray:@[@{@"content":@"九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12",@"time":@"08月12日 09:42",@"imageArr":@[@"图片"],@"avatar":@"组-19",@"name":@"微视觉",@"lookCount":@"1204",@"commentCount":@"23",@"zanCount":@"48",@"isZan":@"1"},
//                                 @{@"content":@"九寨，让我再看一眼你的美",@"time":@"08月12日 09:42",@"imageArr":@[@"组-1",@"组-1-拷贝",@"组-1",@"组-1-拷贝",@"组-1",@"组-1-拷贝",@"组-1",@"组-1-拷贝",@"组-1"],@"avatar":@"组-19",@"name":@"微视觉",@"lookCount":@"1200",@"commentCount":@"23",@"zanCount":@"48",@"isZan":@"1"},
//                                 @{@"content":@"九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12",@"time":@"08月12日 09:42",@"imageArr":@[@"图片"],@"avatar":@"组-19",@"name":@"微视觉",@"lookCount":@"1204",@"commentCount":@"23",@"zanCount":@"48",@"isZan":@"1"},
//                                 @{@"content":@"九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12,九寨，让我再看一眼你的美12",@"time":@"08月12日 09:42",@"imageArr":@[@"图片"],@"avatar":@"组-19",@"name":@"微视觉",@"lookCount":@"1204",@"commentCount":@"23",@"zanCount":@"48",@"isZan":@"1"}]];
    _currentPage = 1;
    [self loadCircleListDatas];
    [self.view addSubview:self.tableView];
}








-(void)loadCircleListDatas{
    NSString * url = CXNewsList;
    NSDictionary * dic;

    if (self.blogListType == microblogListTypeHome) {
        dic = @{@"channel_id":self.category.guide,@"page_size":@10,@"page":@(_currentPage)};
    }
    else if (self.blogListType == microblogListTypeUserHome||self.blogListType == microblogListTypeMine){
        url = CXUserFindList;
        dic = @{@"person_id":self.personId,@"page_size":@10,@"page":@(_currentPage)};
    }
   
    [CXHomeRequest getNewsListWithUrl:url andParameters:dic responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([response[@"code"] intValue] == 0) {
            
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXFind class] json:response[@"data"]];
            if (_currentPage == 1) {
                [_data removeAllObjects];
            }
            [_data addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    

}




#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:discoverCell cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setModel:_data[indexPath.row]];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:discoverCell];
    
    CXFind * model = _data[indexPath.row];
    cell.model = model;
    
    WeakSelf(weakSelf);
    cell.avatarClickBlock = ^{
        CXUserHomeViewController * userHomeVC = [[CXUserHomeViewController alloc] init];
        userHomeVC.member_id = model.member_id;
        [self.navigationController pushViewController:userHomeVC animated:YES];
    };
    cell.moreActionBlock = ^{
        weakSelf.blog = model;

        SelectView * selectView = [[SelectView alloc] initWithTitle:@[@"收藏",@"举报"] delegate:self];
        selectView.myTag = 101;
        [selectView showInWindow];
    };
    cell.zanBtnClickBlock = ^{
        [CXHomeRequest zanArticle:@{@"id":model.ID,@"type":@"2",@"action":@"up"} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXFind * model = _data[indexPath.row];
    CXBlogDetailViewController * detailVC = [[CXBlogDetailViewController alloc] init];
    detailVC.blogId = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}



-(void)selectView:(SelectView *)selectView index:(NSInteger)index{
    if (selectView.myTag == 101) {
        if (index == 0) {
            //收藏
            [CXHomeRequest collectArticleWithParameters:@{@"type":@2,@"id":_blog.ID} success:^(id response) {
                if ([response[@"code"] intValue] == 0) {
                    [Message showMiddleHint:@"收藏成功"];
                }
                else{
                    [Message showMiddleHint:response[@"message"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            //举报
            
        
        }
    }

}



#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //            return;
        //        }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CXDiscoverTableViewCell class] forCellReuseIdentifier:discoverCell];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [FuncManage addRefurbishWithTarget:self scrollView:_tableView upSel:@selector(loadMoreData) downSel:@selector(refreshAllData)];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    return _tableView;
    
}
-(void)loadMoreData{
    _currentPage ++;
    [self loadCircleListDatas];
}
-(void)refreshAllData{
    _currentPage = 1;
    [self loadCircleListDatas ];
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
