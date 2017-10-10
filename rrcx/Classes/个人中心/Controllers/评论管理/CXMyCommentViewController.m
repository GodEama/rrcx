//
//  CXMyCommentViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyCommentViewController.h"
#import "CXMyCommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface CXMyCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * commentTable;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@end
static NSString * const myCommentCell = @"myCommentCell";
@implementation CXMyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentPage = 1;
    [self getCommentListData];
    [self.view addSubview:self.commentTable];
}
-(void)getCommentListData{
    [CXHomeRequest getMyCommentsListWithParameters:@{@"page":@(_currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
        
    } success:^(id response) {
        [self.commentTable.mj_header endRefreshing];
        if ([response[@"code"] intValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXMyComment class] json:response[@"data"]];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            if (array.count < 10) {
                [self.commentTable.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.commentTable.mj_footer endRefreshing];
            }
            [self.commentTable reloadData];
        }
        else{
            [self.commentTable.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.commentTable.mj_header endRefreshing];
        [self.commentTable.mj_footer endRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:myCommentCell   cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setModel:self.dataArray[indexPath.row]];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMyCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCommentCell];
    cell.model = self.dataArray[indexPath.row];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteMyComment:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)deleteMyComment:(UIButton *)sender{
    CXMyComment * comment = _dataArray[sender.tag];
    [CXHomeRequest deleteMyCommentsWithParameters:@{@"comment_id":comment.ID} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            [_dataArray removeObject:comment];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            [self.commentTable beginUpdates];
            [self.commentTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.commentTable endUpdates];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.commentTable reloadData];

            });
            
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight-kTopHeight) style:UITableViewStylePlain];
        _commentTable.delegate = self;
        _commentTable.dataSource = self;
        [_commentTable registerClass:[CXMyCommentTableViewCell class] forCellReuseIdentifier:myCommentCell];
        [FuncManage addRefurbishWithTarget:self scrollView:_commentTable upSel:@selector(loadMoreCommentData) downSel:@selector(refreshAllData)];
        [_commentTable setTableFooterView:[UIView new]];
        _commentTable.estimatedRowHeight = 0;
        _commentTable.estimatedSectionHeaderHeight = 0;
        _commentTable.estimatedSectionFooterHeight = 0;
    }
    return _commentTable;
}

-(void)loadMoreCommentData{
    _currentPage ++;
    [self getCommentListData];
}
-(void)refreshAllData{
    _currentPage = 1;
    [self getCommentListData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
