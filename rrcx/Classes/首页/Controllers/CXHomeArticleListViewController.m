//
//  CXHomeArticleListViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXHomeArticleListViewController.h"
#import "CXFullScreenLoadingView.h"
#import "SDCycleScrollView.h"
#import "FSScrollContentView.h"
#import "CXBaseTableView.h"
#import "FSBottomTableViewCell.h"
#import "CXSingleTableViewController.h"
#import "CXSingleTableViewController_1.h"
#import "CXBanner.h"
#import "JCWebViewController.h"
@interface CXHomeArticleListViewController ()<UITableViewDelegate,UITableViewDataSource,FSSegmentTitleViewDelegate,FSPageContentViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong) CXFullScreenLoadingView *fullLoadingView;
@property (nonatomic, strong) SDCycleScrollView * homeBanner;
@property (nonatomic, strong) CXBaseTableView * mainTable;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) CXSingleTableViewController * articleVC ;
@property (nonatomic, strong) CXSingleTableViewController_1 * newsVC;
@property (nonatomic, strong) NSMutableArray * bannerArray;

@property (nonatomic, assign) BOOL canScroll;
@end

@implementation CXHomeArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
  
    [self.view addSubview:self.mainTable];
    [self loadBannerData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)loadBannerData{
   
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXHomeBanner] parameters:@{@"ad_position_id":@"2"} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _bannerArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CXBanner class] json:responseObject[@"data"][@"adsList"]]];
            NSMutableArray * imageGroup = [NSMutableArray new];
            for (CXBanner * banner in _bannerArray) {
                [imageGroup addObject:banner.images];
            }
            self.homeBanner.imageURLStringsGroup = imageGroup;
            WeakSelf(weakSelf);
            self.homeBanner.clickItemOperationBlock = ^(NSInteger index) {
                CXBanner * banner = weakSelf.bannerArray[index];
                if ([banner.url containsString:@"http"]) {
                    
                        JCWebViewController * VC = [[JCWebViewController alloc] init];
                        VC.url = banner.url;
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    }
            };
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)reloadBannerDataWithResult:(id)responseObject{
    if ([responseObject[@"code"] intValue] == 0) {
        
    }
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 1)];
    topLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, CGRectGetWidth(self.view.bounds), 1)];
    bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView * VLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2, 10, 1, 30)];
    VLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.view.bounds), 48) titles:@[@"文章",@"动态"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectColor = BasicColor;
    self.titleView.titleNormalColor = RGB(76, 76, 77);
    self.titleView.indicatorColor = BasicColor;
    self.titleView.backgroundColor = [UIColor clearColor];
    [view addSubview:topLine];
    [view addSubview:self.titleView];
    [view addSubview:bottomLine];
    [view addSubview:VLine];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return KWidth * 0.4;
        }
        return 50;
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *FSBaseTopTableViewCellIdentifier = @"FSBaseTopTableViewCellIdentifier";
    static NSString *FSBaselineTableViewCellIdentifier = @"FSBaselineTableViewCellIdentifier";
    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSMutableArray *contentVCs = [NSMutableArray array];
            
            _articleVC = [[CXSingleTableViewController alloc] init];
            _articleVC.tableView.frame = CGRectMake(0, 0, KWidth, KHeight - 156 -49);
            _articleVC.category = self.category;
            [contentVCs addObject:_articleVC];
            _newsVC = [[CXSingleTableViewController_1 alloc] init];
            _newsVC.tableView.frame = CGRectMake(0, 0, KWidth, KHeight - 156 - 49);
            _newsVC.category = self.category;
             [contentVCs addObject:_newsVC];
            
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight - kTopHeight) childVCs:contentVCs parentVC:self delegate:self];
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaselineTableViewCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaselineTableViewCellIdentifier];
            [cell.contentView addSubview:self.homeBanner];
        }
        return cell;
    }
    return nil;
}


#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    _mainTable.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _mainTable.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomCellOffset = [_mainTable rectForSection:1].origin.y;
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.mainTable.showsVerticalScrollIndicator = _canScroll?YES:NO;
}
#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

-(CXBaseTableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[CXBaseTableView alloc] initWithFrame:CGRectMake(0, 0, KWidth , KHeight- kTabBarHeight - kTopHeight) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        [FuncManage addRefurbishWithTarget:self scrollView:_mainTable upSel:nil downSel:@selector(refreshAllListData)];
    }
    
    return _mainTable;
}
-(void)refreshAllListData{
    if (self.titleView.selectIndex == 0) {
        [_articleVC refreshAllData];
    }else{
        [_newsVC refreshAllData];
    }
    dispatch_after(2, dispatch_get_main_queue(), ^{
        [self.mainTable.mj_header endRefreshing];
    });
}
-(SDCycleScrollView *)homeBanner{
    if (!_homeBanner) {
        
        _homeBanner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KWidth, KWidth/15*6) delegate:self placeholderImage:nil];
        //banner.titlesGroup = _titles;
        _homeBanner.autoScrollTimeInterval = 4.0;
        _homeBanner.currentPageDotColor = BasicColor; // 自定义分页控件小圆标颜色
        _homeBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        
        _homeBanner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _homeBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        
        _homeBanner.onlyDisplayText = NO;
        _homeBanner.delegate = self;
       
    }
    return _homeBanner;
}
-(CXFullScreenLoadingView *)fullLoadingView
{
    if(!_fullLoadingView){
        _fullLoadingView=[CXFullScreenLoadingView new];
        
    }
    return _fullLoadingView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
