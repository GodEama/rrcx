//
//  CXSingleTableViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSingleTableViewController.h"
#import "CXShareTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXUserHomeViewController.h"
#import "CXArticle.h"
#import "CXArticleDetailViewController.h"
#import "SelectView.h"
#import "CXPostArticleViewController.h"
#import "CXPostImagesViewController.h"
#import "CXPostVideoViewController.h"
#import "CXImagesArticleViewController.h"
@interface CXSingleTableViewController ()<UITableViewDelegate,UITableViewDataSource,SelectViewDelegate>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) CXArticle * model;
@end

@implementation CXSingleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _data = [NSMutableArray new];

    _currentPage = 1;
    [self loadArticleListData];
    if (self.listType == articleListTypeSearch) {
        self.vcCanScroll = YES;
    }
    [self.view addSubview:self.tableView];
    
}

-(void)loadArticleListData{
    NSString * url = CXArticleList;
    NSDictionary * dic;
    if (self.listType == articleListTypeHome) {
        dic = @{@"channel_id":self.category.guide,@"page_size":@10,@"page":@(_currentPage)};

    }
    else if(self.listType == articleListTypeUserHome||self.listType == articleListTypeMine){
        url = CXUserArticleList;
        dic = @{@"person_id":self.personId?:@"",@"page_size":@10,@"page":@(_currentPage)};
        
    }
    else if (self.listType == articleListTypeSearch){
        url = CXSerchResultArticleList;
        dic = @{@"title":self.keyword?:@"",@"page":@(self.currentPage),@"page_size":@10};
    }
    
    [CXHomeRequest getOneArticleListWithUrl:url andParameters:dic responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([response[@"code"] intValue] == 0) {
            
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXArticle class] json:response[@"data"]];
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
    return [tableView fd_heightForCellWithIdentifier:@"articleCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setModelDataWith:_data[indexPath.row]];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleCell"];
    cell.isSelf = self.listType == articleListTypeMine;
    CXArticle * model = _data[indexPath.row];
    [cell setModelDataWith:model];
    WeakSelf(weakSelf);
    cell.avatarClickBlock = ^{
        CXUserHomeViewController * userHomeVC = [[CXUserHomeViewController alloc] init];
        userHomeVC.member_id = model.member_id;
        [weakSelf.navigationController pushViewController:userHomeVC animated:YES];
    };
    cell.optionBtn.tag = indexPath.row;
    if (self.listType == articleListTypeMine) {
        
        cell.optionBtnClickBlock = ^{
            weakSelf.model = model;
            NSArray * array;
            if ([model.status isEqualToString:@"1"]) {
                array = @[@"删除"];
            }
            else if ([model.status isEqualToString:@"3"]) {
                switch ([model.type integerValue]) {
                    case 0:
                        array = @[@"修改",@"删除"];
                        break;
                    case 1:
                        array = @[@"修改",@"删除"];
                        break;
                    case 2:
                        array = @[@"删除"];
                        break;
                    default:
                        break;
                }
            }
            else if ([model.status isEqualToString:@"2"]){
                array = @[@"置顶",@"删除"];
            }
            SelectView * selectView = [[SelectView alloc] initWithTitle:array delegate:weakSelf];
            selectView.myTag = indexPath.row;
            [selectView showInWindow];
            
        };
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXArticle * model = _data[indexPath.row];
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


-(void)selectView:(SelectView *)selectView index:(NSInteger)index{
    if ([selectView.titles[index] isEqualToString:@"删除"]) {
        [self deleteArticleWithTag:selectView.myTag];
    }
    else if ([selectView.titles[index] isEqualToString:@"置顶"]){
        [self setTopArticle];
    }
    else if ([selectView.titles[index] isEqualToString:@"修改"]){
        [self updateMyArticle];
    }
}

-(void)deleteArticleWithTag:(NSInteger)index{
    [CXHomeRequest deleteArticleWithParameters:@{@"article_id":_model?_model.ID:@""} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            [_data removeObject:_model];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setTopArticle{
    [CXHomeRequest setTopArticleWithParameters:@{@"article_id":_model?_model.ID:@""} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)updateMyArticle{
    if ([_model.type isEqualToString:@"0"]) {
        CXPostArticleViewController * postArticle = [[CXPostArticleViewController alloc] init];
        postArticle.loadType = netLoadType;
        postArticle.articleID = _model.ID;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:postArticle];
        [self presentViewController:nav animated:YES completion:nil];
    }
    if ([_model.type isEqualToString:@"1"]) {
        CXPostImagesViewController * postArticle = [[CXPostImagesViewController alloc] init];
        postArticle.loadImagesType = netLoadImagesType;
        postArticle.articleID = _model.ID;

        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:postArticle];
        [self presentViewController:nav animated:YES completion:nil];
    }
    if ([_model.type isEqualToString:@"2"]) {
        CXPostVideoViewController * postArticle = [[CXPostVideoViewController alloc] init];
        postArticle.loadVideoType = netLoadVideoType;
        postArticle.articleID = _model.ID;

        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:postArticle];
        [self presentViewController:nav animated:YES completion:nil];
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
    if (self.listType == articleListTypeSearch) {
        return;
    }
    else{
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
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CXShareTableViewCell class] forCellReuseIdentifier:@"articleCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [FuncManage addRefurbishWithTarget:self scrollView:_tableView upSel:@selector(loadMoreArticleData) downSel:@selector(refreshAllData)];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    return _tableView;
    
}


-(void)loadMoreArticleData{
    _currentPage ++;
    [self loadArticleListData];
    
}
-(void)refreshAllData{
    _currentPage = 1;
    [self loadArticleListData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
