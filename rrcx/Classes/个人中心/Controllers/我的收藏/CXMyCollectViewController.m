//
//  CXMyCollectViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/27.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyCollectViewController.h"
#import "CXMyCollectTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXArticleDetailViewController.h"
#import "CXImagesArticleViewController.h"
@interface CXMyCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * myCollectTable;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@end
static NSString *const myCollectArticleCell=@"myCollectArticleCell";

@implementation CXMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentPage = 1;
    [self.view addSubview:self.myCollectTable];
    [self loadCollectionArticleData];
}

-(void)loadCollectionArticleData{
    [CXHomeRequest getMycollectionArticleListWithParameters:@{@"type":@1,@"page":@(_currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.myCollectTable.mj_header endRefreshing];
        
        if ([response[@"code"] intValue] == 0) {
            
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXArticle class] json:response[@"data"]];
            if (_currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            if (array.count <10) {
                
                [self.myCollectTable.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.myCollectTable.mj_footer endRefreshing];

            }
            [self.myCollectTable reloadData];
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.myCollectTable.mj_header endRefreshing];
        [self.myCollectTable.mj_footer endRefreshing];

    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:myCollectArticleCell cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setModel:self.dataArray[indexPath.row]];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMyCollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCollectArticleCell];
    CXArticle * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXArticle * model = self.dataArray[indexPath.row];
    NSInteger type = [model.type integerValue];
    switch (type) {
        case 0:
        {
            CXArticleDetailViewController * detailVC = [[CXArticleDetailViewController alloc] init];
            detailVC.articleId = model.ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 1:
        {
            CXImagesArticleViewController * detailVC = [[CXImagesArticleViewController alloc] init];
            detailVC.articleId = model.ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:
        {
            CXArticleDetailViewController * detailVC = [[CXArticleDetailViewController alloc] init];
            detailVC.articleId = model.ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
            
        default:
        {
            CXArticleDetailViewController * detailVC = [[CXArticleDetailViewController alloc] init];
            detailVC.articleId = model.ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
    }
}



-(UITableView *)myCollectTable{
    if (!_myCollectTable) {
        _myCollectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStyleGrouped];
        _myCollectTable.delegate =self;
        _myCollectTable.dataSource = self;
        [FuncManage addRefurbishWithTarget:self scrollView:_myCollectTable upSel:@selector(loadMoreArticleData) downSel:@selector(refreshAllArticle)];
        [_myCollectTable registerClass:[CXMyCollectTableViewCell class] forCellReuseIdentifier:myCollectArticleCell];
        _myCollectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myCollectTable.estimatedRowHeight = 0;
        _myCollectTable.estimatedSectionHeaderHeight = 0;
        _myCollectTable.estimatedSectionFooterHeight = 0;
    }
    return _myCollectTable;
}
-(void)loadMoreArticleData{
    _currentPage ++;
    [self loadCollectionArticleData];
}
-(void)refreshAllArticle{
    _currentPage = 1;
    [self loadCollectionArticleData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
