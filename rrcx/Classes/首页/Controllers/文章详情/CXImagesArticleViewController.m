//
//  CXImagesArticleViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/27.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXImagesArticleViewController.h"
#import "CXArticleDetailModel.h"
#import "CXArticleBottomView.h"
#import "HZPhotoBrowser.h"
#import "CXImageArticleBottomView.h"
#import "QZTopTextView.h"
#import "CXImageArticleCommentViewController.h"
#import "CXTopView.h"

#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface CXImagesArticleViewController ()<HZPhotoBrowserDelegate,QZTopTextViewDelegate>
{
    QZTopTextView * _textView;
}
@property (nonatomic,strong) CXArticleDetailModel * articleModel;
@property (nonatomic,strong) CXImageArticleBottomView * bottomView;
@property (nonatomic,strong) CXTopView * topView;
@end

@implementation CXImagesArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setNeedsStatusBarAppearanceUpdate];

    [self getArticleDetailData];
    [self.view addSubview:self.bottomView];
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [self.view addSubview:self.topView];

}
-(void)getArticleDetailData{
    [CXHomeRequest getArticleDetail:@{@"id":self.articleId?:@"",@"type":@1} responseCache:^(id responseCaches) {
    } success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            _articleModel = [CXArticleDetailModel yy_modelWithJSON:response[@"data"]];
            self.topView.member_avatar = _articleModel.authorInfo.member_avatar;
            self.topView.member_nick = _articleModel.authorInfo.member_nick;
            self.topView.isFollow = [_articleModel.ishits isEqualToString:@"1"];
            self.topView.member_id = _articleModel.member_id;

            self.bottomView.isCollected = [_articleModel.iscollect isEqualToString:@"1"];
            //启动图片浏览器
            NSArray * imageArray = _articleModel.con_list;
            HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
            NSMutableArray * descArray = [NSMutableArray new];
            for (NSDictionary * dic in imageArray) {
                [descArray addObject:dic[@"desc"]?:@" "];
            }
            browser.descArray = descArray;

//            browser.sourceImagesContainerView = self; // 原图的父控件
            browser.imageCount = _articleModel.con_list.count; // 图片总数
            browser.currentImageIndex = 0;
            browser.delegate = self;
            
            [browser showInView:self.view];
            
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)QZTopTextView:(QZTopTextView *)commentView sendComment:(NSString *)comment{
    if (![FuncManage theStringIsEmpty:comment]) {
        [CXHomeRequest commentArticleWithParameters:@{@"id":self.articleId?:@"",@"comment":comment} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                [Message showMiddleHint:@"评论成功"];
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)CX_photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSDictionary * dic = self.articleModel.con_list[index];
    NSString *imageName = dic[@"value"];
    NSURL *url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)CX_photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return [UIImage imageNamed:@"placeholder_articleCover"];
}

-(CXImageArticleBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CXImageArticleBottomView alloc] initWithFrame:CGRectMake(0, KHeight - kTabBarHeight, KWidth, 49)];
        [_bottomView.commentBtn addTarget:self action:@selector(commentArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.collectBtn addTarget:self action:@selector(collectArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shareBtn addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.commentListBtn addTarget:self action:@selector(lookCommentList) forControlEvents:UIControlEventTouchUpInside];
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


-(void)commentArticle{
    [_textView.countNumTextView becomeFirstResponder];
}
-(void)lookCommentList{
    CXImageArticleCommentViewController * commentListVC = [[CXImageArticleCommentViewController alloc] init];
    commentListVC.articleId = self.articleId;
    commentListVC.articleModel = _articleModel;
    
    [self.navigationController pushViewController:commentListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goToLogin{
    CXLoginViewController *writeVc = [[CXLoginViewController alloc] init];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(CXTopView *)topView{
    if (!_topView) {
        _topView = [[CXTopView alloc] initWithFrame:CGRectMake(0, 0, KWidth, kTopHeight)];
        [_topView.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

-(void)viewWillAppear:(BOOL)animated { 
    [super viewWillAppear:animated]; self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //状态栏改为白色
    
}
    
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated]; self.navigationController.navigationBar.barStyle = UIBarStyleDefault; //状态栏改为黑色
        
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
