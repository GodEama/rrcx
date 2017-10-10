//
//  CXImageArticleCommentViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXImageArticleCommentViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXCommentTableViewCell.h"
#import "CXUserHomeViewController.h"
#import "CXCommentDetailViewController.h"
#import "QZTopTextView.h"
#import "CXArticleBottomView.h"
#import "CXCommentBottomView.h"
@interface CXImageArticleCommentViewController ()<UITableViewDelegate,UITableViewDataSource,QZTopTextViewDelegate>
{
    QZTopTextView * _textView;
}
@property (nonatomic,strong) UITableView * commentTable;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) CXCommentBottomView * bottomView;

@end

@implementation CXImageArticleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    _commentArray = [NSMutableArray new];
    [self getArticleCommentData];
    [self.view addSubview:self.commentTable];
    //    adjustsScrollViewInsets(self.commentTable);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.bottomView];
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    _currentPage = 1;

}
-(void)getArticleCommentData{
    [CXHomeRequest getArticleCommentsWithParameters:@{@"type":@1,@"id":self.articleId?:@""} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.commentTable.mj_header endRefreshing];
        if ([response[@"code"] integerValue] == 0) {
            if (self.currentPage == 1) {
                
                [self.commentArray removeAllObjects];
                NSArray * array =  [NSArray yy_modelArrayWithClass:[CXComment class] json:response[@"data"]];
                if (array.count) {
                    [self.commentTable.mj_footer endRefreshing];
                }
                else{
                    [self.commentTable.mj_footer endRefreshingWithNoMoreData];
                    _currentPage = _currentPage>1?_currentPage--:_currentPage;
                }
                [self.commentArray addObjectsFromArray:array];
                [self.commentTable reloadData];
            }
            else{
                [self.commentTable.mj_footer endRefreshing];
            }
        }
        
    } failure:^(NSError *error) {
        [self.commentTable.mj_header endRefreshing];
        [self.commentTable.mj_footer endRefreshing];
    }];
}
-(void)QZTopTextView:(QZTopTextView *)commentView sendComment:(NSString *)comment{
    if (![FuncManage theStringIsEmpty:comment]) {
        if (![FuncManage theStringIsEmpty:comment]) {
            [CXHomeRequest commentArticleWithParameters:@{@"id":self.articleId?:@"",@"comment":comment} success:^(id response) {
                if ([response[@"code"] integerValue] == 0) {
                    CXComment * comment = [CXComment yy_modelWithJSON:response[@"data"]];
                    [_commentArray insertObject:comment atIndex:0];
                    [self.commentTable reloadData];
                }
                else{
                    [Message showMiddleHint:response[@"message"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"commentCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        CXComment * model = _commentArray[indexPath.row];
        [cell setCommentModel:model];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    CXComment * model = _commentArray[indexPath.row];
    cell.commentModel = model;
    WeakSelf(weakSelf)
    cell.avatarBtnClickBlock = ^{
        CXUserHomeViewController * userHomeVC = [[CXUserHomeViewController alloc] init];
        userHomeVC.member_id = model.member_id;
        [weakSelf.navigationController pushViewController:userHomeVC animated:YES];
    };
    __weak CXCommentTableViewCell * weakCell = cell;
    __weak CXComment * weakModel = model;
    cell.zanCommentBlock = ^{
        BOOL liked = [model.islike isEqualToString:@"1"];
        [CXHomeRequest zanArticle:@{@"comm_id":model.ID,@"action":liked?@"down":@"up",@"id":weakSelf.articleId} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                if ([model.islike isEqualToString:@"1"]) {
                    weakModel.islike = @"0";
                    weakModel.num_up = [NSString stringWithFormat:@"%ld",[weakModel.num_up integerValue]-1];
                    weakCell.commentModel = weakModel;
                }
                else{
                    weakModel.islike = @"1";
                    weakModel.num_up = [NSString stringWithFormat:@"%ld",[weakModel.num_up integerValue]+1];
                    weakCell.commentModel = weakModel;
                }
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
    };
    cell.replyCommentClickBlock = ^{
        CXCommentDetailViewController * detailVC = [[CXCommentDetailViewController alloc] init];
        detailVC.comment = model;
        detailVC.type = 2;
        detailVC.blogId = weakSelf.articleId;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXComment * model = _commentArray[indexPath.row];
    CXCommentDetailViewController * detailVC = [[CXCommentDetailViewController alloc] init];
    detailVC.comment = model;
    detailVC.type = 2;
    detailVC.blogId = self.articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - 49 - kTopHeight) style:UITableViewStylePlain];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        [_commentTable registerClass:[CXCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
        [_commentTable setTableFooterView:[UIView new]];
        [FuncManage addRefurbishWithTarget:self scrollView:_commentTable upSel:@selector(loadMoreCommentData) downSel:nil];
        //        //声明tableView的位置 添加下面代码
        //        if (@available(iOS 11.0, *)) {
        //            _commentTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        }
        _commentTable.estimatedRowHeight = 0;
        _commentTable.estimatedSectionHeaderHeight = 0;
        _commentTable.estimatedSectionFooterHeight = 0;
    }
    return _commentTable;
}
-(void)loadMoreCommentData{
    _currentPage ++;
    [self getArticleCommentData];
}

-(void)refreshAllData{
    _currentPage = 1;
    [self getArticleCommentData];
}

-(CXCommentBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CXCommentBottomView alloc] initWithFrame:CGRectMake(0, KHeight - 49, KWidth, 49)];
        [_bottomView.commentBtn addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}


-(void)commentArticle{
    [_textView.countNumTextView becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
