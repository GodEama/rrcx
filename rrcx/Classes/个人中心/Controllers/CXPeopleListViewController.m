//
//  CXPeopleListViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXPeopleListViewController.h"
#import "CXFansTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface CXPeopleListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * peopleList;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation CXPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentPage = 1;
    [self initlizationData];
    [self initlizationViews];
}
-(void)initlizationData{
    _currentPage = 1;
    
    if (self.listType == peopleListTypeMyFans) {
        self.title = @"粉丝";
        [self loadFansListData];
    }
    else{
        self.title = @"关注";
        [self loadFollowsListData];
    }
}
-(void)initlizationViews{
    [self.view addSubview:self.peopleList];

}


-(void)loadFansListData{
    [CXHomeRequest getMyFansListWithParameters:@{@"person_id":_member_id?:@"",@"page":@(_currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.peopleList.mj_header endRefreshing];
        if (self.currentPage) {
            [self.dataArray removeAllObjects];
        }
        NSArray * array = [NSArray yy_modelArrayWithClass:[CXListPeople class] json:response[@"data"]];
        [self.dataArray addObjectsFromArray:array];
        if (array.count) {
            [self.peopleList.mj_footer endRefreshing];
        }
        else{
            [self.peopleList.mj_footer endRefreshingWithNoMoreData];
        }
        [self.peopleList reloadData];
        
    } failure:^(NSError *error) {
        [self.peopleList.mj_header endRefreshing];
        [self.peopleList.mj_footer endRefreshing];
    }];
}

-(void)loadFollowsListData{
 
    [CXHomeRequest getMyfollowsListWithParameters:@{@"person_id":_member_id?:@"",@"page":@(_currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.peopleList.mj_header endRefreshing];
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray * array = [NSArray yy_modelArrayWithClass:[CXListPeople class] json:response[@"data"]];
        [self.dataArray addObjectsFromArray:array];
        if (array.count) {
            [self.peopleList.mj_footer endRefreshing];
        }
        else{
            [self.peopleList.mj_footer endRefreshingWithNoMoreData];
        }
        [self.peopleList reloadData];
    } failure:^(NSError *error) {
        [self.peopleList.mj_header endRefreshing];
        [self.peopleList.mj_footer endRefreshing];
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
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"peopleCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setPeople:_dataArray[indexPath.row]];
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXFansTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCell"];
    CXListPeople * model = _dataArray[indexPath.row];
    cell.people = model;
    if (self.listType == peopleListTypeMyFollows) {
        cell.followBtn.hidden = YES;
    }
    return cell;
}


-(UITableView *)peopleList{
    if (!_peopleList) {
        _peopleList = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight) style:UITableViewStyleGrouped];

        
        _peopleList.delegate = self;
        _peopleList.dataSource = self;
        [_peopleList registerClass:[CXFansTableViewCell class] forCellReuseIdentifier:@"peopleCell"];
        [FuncManage addRefurbishWithTarget:self scrollView:_peopleList upSel:@selector(loadMorePeople) downSel:@selector(reloadAllData)];
        [_peopleList setTableFooterView:[UIView new]];
        _peopleList.estimatedRowHeight = 0;
        _peopleList.estimatedSectionHeaderHeight = 0;
        _peopleList.estimatedSectionFooterHeight = 0;
    }
    return _peopleList;
}
-(void)loadMorePeople{
    _currentPage ++;
    if (self.listType == peopleListTypeMyFans) {
        [self loadFansListData];
    }
    else{
        [self loadFollowsListData];
    }
}
-(void)reloadAllData{
    _currentPage = 1;
    if (self.listType == peopleListTypeMyFans) {
        [self loadFansListData];
    }
    else{
        [self loadFollowsListData];
    }
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
};
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
