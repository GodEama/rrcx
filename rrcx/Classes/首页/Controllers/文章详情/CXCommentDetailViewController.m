//
//  CXCommentDetailViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/22.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXCommentDetailViewController.h"
#import "CXUserHomeViewController.h"
#import "QZTopTextView.h"
#import "CXArticleBottomView.h"
#import "CXBlogDetailModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXCommentTableViewCell.h"
@interface CXCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,QZTopTextViewDelegate>
{
    QZTopTextView * _textView;
}
@property (nonatomic,strong) UITableView * commentTable;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) CXArticleBottomView * bottomView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) CXBlogDetailModel * blogDetailModel;

@end

@implementation CXCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    _commentArray = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.commentTable];
    [self.view addSubview:self.bottomView];
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    _currentPage = 1;
    [self getReplyList];
}


-(void)QZTopTextView:(QZTopTextView *)commentView sendComment:(NSString *)comment{
    if (![FuncManage theStringIsEmpty:comment]) {
        [CXHomeRequest commentArticleWithParameters:@{@"comment_id":self.comment?_comment.ID:@"",@"comment":comment,@"id":_blogId} success:^(id response) {
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
-(void)getReplyList{
    [CXHomeRequest getReplayListWithParameters:@{@"comment_id":_comment?_comment.ID:@"",@"page":@(self.currentPage),@"page_size":@"10"} responseCache:^(id responseCaches) {
        
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



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _commentArray.count?2:1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 0?1:_commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        
    return [tableView fd_heightForCellWithIdentifier:@"commentCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        
        CXComment * model = indexPath.section == 0?_comment:_commentArray[indexPath.row];
            [cell setCommentModel:model];
        }];
        
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    else{
        return 40;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0?nil:@"回复";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CXCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.commentModel = _comment;
        return cell;
    }
    else{
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
            [CXHomeRequest zanArticle:@{@"comm_id":model.ID,@"action":liked?@"down":@"up",@"id":weakSelf.blogId} success:^(id response) {
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
            
        };
        return cell;
    }
    
}



-(UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - 49 - kTopHeight) style:UITableViewStyleGrouped];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        [_commentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_commentTable registerClass:[CXCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
        [_commentTable setTableFooterView:[UIView new]];
        [FuncManage addRefurbishWithTarget:self scrollView:_commentTable upSel:@selector(loadMoreCommentData) downSel:@selector(refreshAllData)];
        _commentTable.estimatedRowHeight = 0;
        _commentTable.estimatedSectionHeaderHeight = 0;
        _commentTable.estimatedSectionFooterHeight = 0;
    }
    return _commentTable;
}
-(void)loadMoreCommentData{
    _currentPage ++;
    [self getReplyList];
}

-(void)refreshAllData{
    _currentPage = 1;
    [self getReplyList];
}
-(CXArticleBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CXArticleBottomView alloc] initWithFrame:CGRectMake(0, KHeight - 49, KWidth, 49)];
        [_bottomView.commentBtn addTarget:self action:@selector(replayComment) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.collectBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];

    }
    return _bottomView;
}

-(void)replayComment{
    [_textView.countNumTextView becomeFirstResponder];
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
