//
//  CXArticleDetailViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXArticleDetailViewController.h"
#import "CXArticleHeaderView.h"
#import "CXArticleDetailHeader.h"
#import "CXArticleBottomView.h"
#import "QZTopTextView.h"
#import "CXComment.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXCommentTableViewCell.h"
#import "CXUserHomeViewController.h"
#import "CXCommentDetailViewController.h"
#import "CXUserHomeViewController.h"
#import "SDPhotoBrowser.h"

#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
@interface CXArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,QZTopTextViewDelegate,SDPhotoBrowserDelegate>
{
    QZTopTextView * _textView;
}
@property (nonatomic,strong) CXArticleDetailHeader * headerView;
@property (nonatomic,strong) UITableView * commentTable;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) CXArticleDetailModel * articleModel;
@property (nonatomic,strong) CXArticleBottomView * bottomView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray * murlArray;

@end

@implementation CXArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文章详情";
    _murlArray = [NSMutableArray new];
    _commentArray = [NSMutableArray new];
    [self getArticleDetailData];
    [self getArticleCommentData];
    [self.commentTable setTableHeaderView:self.headerView];
    [self.view addSubview:self.commentTable];
//    adjustsScrollViewInsets(self.commentTable);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.bottomView];
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    _currentPage = 1;
}
-(void)getArticleDetailData{
    [CXHomeRequest getArticleDetail:@{@"id":self.articleId,@"type":@1} responseCache:^(id responseCaches) {
        [self resetHeaderViewDataWithResult:responseCaches];
    } success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            _articleModel = [CXArticleDetailModel yy_modelWithJSON:response[@"data"]];
            _headerView.detailWebView.delegate = self;
            self.headerView.model = _articleModel;
            self.bottomView.isCollected = [_articleModel.iscollect isEqualToString:@"1"];
            
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)resetHeaderViewDataWithResult:(id)response{
    if ([response[@"code"] integerValue] == 0) {
        _articleModel = [CXArticleDetailModel yy_modelWithJSON:response[@"data"]];
        _headerView.detailWebView.delegate = self;
        self.headerView.model = _articleModel;
    }
   
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
    [self getArticleDetailData];
}



-(CXArticleDetailHeader *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CXArticleDetailHeader" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 10, KWidth, 235);
        WeakSelf(weakSelf)
        _headerView.lookAuthorHomeBlock = ^{
            if (weakSelf.articleModel) {
                CXUserHomeViewController * homeVC = [[CXUserHomeViewController alloc] init];
                homeVC.member_id = weakSelf.articleModel.authorInfo.member_id;
                [weakSelf.navigationController pushViewController:homeVC animated:YES];
            }
           
        };
        
    }
    return _headerView;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取到得网页内容
    
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    _murlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (_murlArray.count >= 2) {
        [_murlArray removeLastObject];
    }
    DLog(@">>>>>>>图片数组：%@",_murlArray);
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize actualSize = [webView sizeThatFits:CGSizeZero];
        _headerView.webViewHeight.constant = actualSize.height;
        _headerView.detailWebView.scrollView.scrollEnabled = NO;
        CGRect newFrame = _headerView.frame;
        
        newFrame.size.height = 235 + webView.scrollView.contentSize.height;
        _headerView.frame = newFrame;
        [self.commentTable beginUpdates];
        [self.commentTable setTableHeaderView:_headerView];
        [self.commentTable endUpdates];
    });
    
}
//在这个方法中捕获到图片的点击事件和被点击图片的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //path 就是被点击图片的url
        DLog(@"图片路径为：%@",path);
        // CGSize size = [self getImageSizeWithURL:path];
        
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        //        [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        int currentIndex = 0;
        for (int i = 0; i<_murlArray.count; i++) {
            NSString * str = _murlArray[i];
            if ([str isEqualToString:path]) {
                currentIndex = i;
            }
        }
        browser.isFormWebImage = YES;
        browser.currentImageIndex = currentIndex;
        // browser.sourceImagesContainerView = self.view;
        browser.imageCount = _murlArray.count;
        browser.delegate = self;
        [browser show];
        return NO;
    }
    return YES;
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.murlArray[index];
    NSURL *url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return [UIImage imageNamed:@"avatar_placeholder"];
}

-(CXArticleBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CXArticleBottomView alloc] initWithFrame:CGRectMake(0, KHeight - kTabBarHeight, KWidth, 49)];
        [_bottomView.commentBtn addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.collectBtn addTarget:self action:@selector(collectArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shareBtn addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
//收藏文章、取消收藏
-(void)collectArticle{
    if ([_articleModel.iscollect isEqualToString:@"0"]) {
        [CXHomeRequest collectArticleWithParameters:@{@"type":@1,@"id":_articleModel.ID} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                _articleModel.iscollect = @"1";
                self.bottomView.isCollected = YES;
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else{
        [CXHomeRequest cancelCollectArticleWithParameters:@{@"type":@1,@"id":_articleModel.ID} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                _articleModel.iscollect = @"0";
                self.bottomView.isCollected = NO;
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
}
-(void)shareArticle{
    if (self.articleModel.contenturl) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = self.articleModel.cover_images;
        if (!imageArray.count) {
             imageArray = @[@"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F02%2F19%2F75c58PICjTZ.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2362580362%2C1637082548%26fm%3D27%26gp%3D0.jpg"];
        }
        [shareParams SSDKSetupShareParamsByText:self.articleModel.title
                                         images:imageArray
                                            url:[NSURL URLWithString:self.articleModel.detailsurl]
                                          title:self.articleModel.title
                                           type:SSDKContentTypeWebPage];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
       [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];

        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            if (platformType == SSDKPlatformTypeSMS ) {
                [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@                \n%@",self.articleModel.title,self.articleModel.detailsurl] title:self.articleModel.title images:imageArray attachments:self.articleModel.detailsurl recipients:nil type:SSDKContentTypeImage];
            }
            switch (state) {
                case SSDKResponseStateSuccess:
                    [Message showMiddleHint:@"分享成功"];
                    
                    break;
                case SSDKResponseStateCancel:
                    
                    break;
                case SSDKResponseStateFail:
                    [Message showMiddleHint:@"分享失败"];
                    break;
                default:
                    break;
            }
        }];
    }
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
