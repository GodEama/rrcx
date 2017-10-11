//
//  CXUserHomeViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/8.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserHomeViewController.h"
#import "CXUserHomeHeaderView.h"
#import "CXSingleTableViewController.h"
#import "CXSingleTableViewController_1.h"
#import "CXFullScreenLoadingView.h"
#import "FSScrollContentView.h"
#import "CXBaseTableView.h"
#import "FSBottomTableViewCell.h"
#import "CXUser.h"
#import "CXPeopleListViewController.h"
#import "MXNavigationBarManager.h"
@interface CXUserHomeViewController ()<UITableViewDelegate,UITableViewDataSource,FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic, strong) CXUserHomeHeaderView * headerView;
@property(nonatomic,strong) CXFullScreenLoadingView *fullLoadingView;
@property (nonatomic, strong) CXBaseTableView * mainTable;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;

@end

@implementation CXUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    [self initBarManager];
    [self getUserBasicInfo];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.member_id isEqualToString:User_id]) {
        self.headerView.followBtn.hidden = YES;
    }
    [self.view addSubview:self.mainTable];
}

-(void)getUserBasicInfo{
    [CXHomeRequest getUserBasicInfo:@{@"id":self.member_id?:@""} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            CXUser * user = [CXUser yy_modelWithJSON:response[@"data"]];
            self.headerView.member_nick = user.member_nick;
            self.headerView.member_follows = user.member_follows;
            self.headerView.member_focus = user.member_focus;
            self.headerView.member_avatar = user.member_avatar;
            self.headerView.member_id = user.member_id;
            self.headerView.isAttention = [response[@"data"][@"ishits"] intValue] ==1;
            self.title = user.member_nick;
        }

        
    } failure:^(NSError *error) {
        
    }];
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
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(10, 1, CGRectGetWidth(self.view.bounds), 48) titles:@[@"动态",@"文章"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectColor = BasicColor;
    self.titleView.titleNormalColor = RGB(76, 76, 77);
    self.titleView.indicatorColor = BasicColor;
    self.titleView.littleTitlesCompact = YES;
    self.titleView.backgroundColor = [UIColor whiteColor];
    [view addSubview:topLine];
    [view addSubview:self.titleView];
    [view addSubview:bottomLine];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 251;
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
            
            
            CXSingleTableViewController_1 * newsVC = [[CXSingleTableViewController_1 alloc] init];
            newsVC.blogListType = microblogListTypeUserHome;
            newsVC.personId = self.member_id;
            newsVC.tableView.frame = CGRectMake(0, 0, KWidth, KHeight - 50);
            
            [contentVCs addObject:newsVC];
            CXSingleTableViewController * articleVC = [[CXSingleTableViewController alloc] init];
            articleVC.listType = articleListTypeUserHome;
            if ([User_id isEqualToString:self.member_id]) {
                articleVC.listType = articleListTypeMine;
            }
            articleVC.personId = self.member_id;
            articleVC.tableView.frame = CGRectMake(0, 0, KWidth, KHeight - 50);
            [contentVCs addObject:articleVC];
            
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight - 64) childVCs:contentVCs parentVC:self delegate:self];
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaselineTableViewCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaselineTableViewCellIdentifier];
            
            [cell.contentView addSubview:self.headerView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
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
    CGFloat bottomCellOffset = [_mainTable rectForSection:1].origin.y -kTopHeight;
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
    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];

}
#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

-(CXBaseTableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[CXBaseTableView alloc] initWithFrame:CGRectMake(0, 0, KWidth , KHeight) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
    }
    
    return _mainTable;
}

-(CXFullScreenLoadingView *)fullLoadingView
{
    if(!_fullLoadingView){
        _fullLoadingView=[CXFullScreenLoadingView new];
        
    }
    return _fullLoadingView;
}











-(CXUserHomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CXUserHomeHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, KWidth, 251);
        WeakSelf(weakSelf)
        _headerView.fansClickBlock = ^{
            CXPeopleListViewController * listVC = [[CXPeopleListViewController alloc] init];
            listVC.member_id = weakSelf.member_id;
            listVC.listType = peopleListTypeMyFans;
            [weakSelf.navigationController pushViewController:listVC animated:YES];
            
        };
        _headerView.focusClickBlock = ^{
            CXPeopleListViewController * listVC = [[CXPeopleListViewController alloc] init];
            listVC.member_id = weakSelf.member_id;
            listVC.listType = peopleListTypeMyFollows;
            [weakSelf.navigationController pushViewController:listVC animated:YES];
        };
    }
    return _headerView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO ;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mainTable.delegate = nil;

    [MXNavigationBarManager reStoreToSystemNavigationBar];

}

- (void)initBarManager {
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor whiteColor]];
    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setZeroAlphaOffset:0];
    [MXNavigationBarManager setFullAlphaOffset:kTopHeight];
    [MXNavigationBarManager setFullAlphaTintColor:[UIColor blackColor]];
    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
    
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
