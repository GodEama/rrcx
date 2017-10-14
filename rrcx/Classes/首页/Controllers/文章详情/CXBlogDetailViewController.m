//
//  CXBlogDetailViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXBlogDetailViewController.h"
#import "QZTopTextView.h"
#import "CXArticleBottomView.h"
#import "CXBlogDetailModel.h"
#import "CXBlogDetailHeaderTableViewCell.h"
#import "CXCommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXComment.h"
#import "CXUserHomeViewController.h"
#import "CXCommentDetailViewController.h"
@interface CXBlogDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,QZTopTextViewDelegate>
{
    QZTopTextView * _textView;
}
@property (nonatomic,strong) UITableView * commentTable;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) CXArticleBottomView * bottomView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) CXBlogDetailModel * blogDetailModel;

@end

@implementation CXBlogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"文章详情";
    _commentArray = [NSMutableArray new];
    [self getMicrblogDetailData];
    [self.view addSubview:self.commentTable];
    [self.view addSubview:self.bottomView];
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    _currentPage = 1;
    [self getArticleCommentData];
}
-(void)getMicrblogDetailData{
    [CXHomeRequest getArticleDetail:@{@"id":self.blogId,@"type":@2} responseCache:^(id responseCaches) {
        [self resetHeaderViewDataWithResult:responseCaches];
    } success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            _blogDetailModel = [CXBlogDetailModel yy_modelWithJSON:response[@"data"]];
            [self.commentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.bottomView.collectBtn setImage:[UIImage imageNamed:[_blogDetailModel.islike isEqualToString:@"1"]?@"praise-a":@"praise"] forState:UIControlStateNormal];
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)resetHeaderViewDataWithResult:(id)response{
    if ([response[@"code"] integerValue] == 0) {
        _blogDetailModel = [CXBlogDetailModel yy_modelWithJSON:response[@"data"]];
        [self.commentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)QZTopTextView:(QZTopTextView *)commentView sendComment:(NSString *)comment{
    if (![FuncManage theStringIsEmpty:comment]) {
        [CXHomeRequest commentArticleWithParameters:@{@"id":self.blogId?:@"",@"comment":comment} success:^(id response) {
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
-(void)getArticleCommentData{
    [CXHomeRequest getArticleCommentsWithParameters:@{@"type":@1,@"id":self.blogId?:@"",@"page":@(self.currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 0?1:_commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"headerCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell setModel:_blogDetailModel];
        }];
    }
    else{
        
        return [tableView fd_heightForCellWithIdentifier:@"commentCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            CXComment * model = _commentArray[indexPath.row];
            [cell setCommentModel:model];
        }];
      
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CXBlogDetailHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        cell.model = _blogDetailModel;
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
            CXCommentDetailViewController * detailVC = [[CXCommentDetailViewController alloc] init];
            detailVC.comment = model;
            detailVC.type = 2;
            detailVC.blogId = weakSelf.blogId;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        };
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        CXComment * model = self.commentArray[indexPath.row];
        CXCommentDetailViewController * detailVC = [[CXCommentDetailViewController alloc] init];
        detailVC.comment = model;
        detailVC.type = 2;
        detailVC.blogId = self.blogId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


-(UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTabBarHeight - kTopHeight) style:UITableViewStylePlain];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        
        [_commentTable registerClass:[CXBlogDetailHeaderTableViewCell class] forCellReuseIdentifier:@"headerCell"];
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
    [self getArticleCommentData];
}

-(void)refreshAllData{
    _currentPage = 1;
    [self getArticleCommentData];
}
-(CXArticleBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CXArticleBottomView alloc] initWithFrame:CGRectMake(0, KHeight - kTabBarHeight, KWidth, 49)];
        [_bottomView.commentBtn addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.collectBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_bottomView.collectBtn addTarget:self action:@selector(zanBlog) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shareBtn addTarget:self action:@selector(shareBlog) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

/**
 对动态点赞
 */
-(void)zanBlog{
   
    if ([_blogDetailModel.islike isEqualToString:@"0"]) {
        [CXHomeRequest zanArticle:@{@"id":self.blogId,@"action":@"up"} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                _blogDetailModel.islike = @"1";
                 [_bottomView.collectBtn setImage:[UIImage imageNamed:@"praise-a"] forState:UIControlStateNormal];
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    else{
        [CXHomeRequest zanArticle:@{@"id":self.blogId,@"action":@"down"} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                _blogDetailModel.islike = @"0";
                [_bottomView.collectBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

/**
 分享动态
 */
-(void)shareBlog{

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
