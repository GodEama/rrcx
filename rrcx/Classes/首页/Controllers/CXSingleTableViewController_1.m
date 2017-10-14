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
#import "YMReportViewController.h"
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
        if ([model.member_id isEqualToString:User_id]) {
            //是自己的动态
            SelectView * selectView = [[SelectView alloc] initWithTitle:@[/*@"收藏",*/@"删除"] delegate:self];
            selectView.myTag = 102;
            selectView.tag = indexPath.row;
            [selectView showInWindow];
        }
        else{
            //别人的动态
            SelectView * selectView = [[SelectView alloc] initWithTitle:@[/*@"收藏",*/@"举报"] delegate:self];
            selectView.myTag = 101;
            selectView.tag = indexPath.row;
            [selectView showInWindow];
        }
        
    };
    __weak CXDiscoverTableViewCell * weakCell = cell;
    cell.zanBtnClickBlock = ^{
        
        [CXHomeRequest zanArticle:@{@"id":model.ID,@"type":@"2",@"action":[model.islike integerValue] == 0?@"up":@"down"} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                if ([model.islike integerValue] == 0) {
                    //点赞
                    model.islike = @"1";
                    model.num_up = model.num_up + 1;
                   
                }
                else{
                    model.islike = @"0";
                    model.num_up = (model.num_up - 1)>=0?model.num_up - 1:0;
                }
                weakCell.model = model;
                [weakSelf.data replaceObjectAtIndex:indexPath.row withObject:model];
            }
            else{
                [Message showMiddleHint:response[@"message"]];
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
    if (index == 1000) {//未设置收藏功能
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
    }
    if (index == 0) {
        
        if (selectView.myTag == 101) {
            //举报
            YMReportViewController * reportVC = [[YMReportViewController alloc] init];
            reportVC.articleId = self.blog.ID;
            reportVC.reportType = reportTypeBlog;
            [self.navigationController pushViewController:reportVC animated:YES];
            
        }
        else if (selectView.myTag == 102){
            //删除
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"删除此动态？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [CXHomeRequest deleteArticleWithParameters:@{@"article_id":self.blog.ID} success:^(id response) {
                    if ([response[@"code"] integerValue] == 0) {
                        [self.data removeObject:self.blog];
                        [self.tableView beginUpdates];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                    else{
                        [Message showMiddleHint:response[@"message"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
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
