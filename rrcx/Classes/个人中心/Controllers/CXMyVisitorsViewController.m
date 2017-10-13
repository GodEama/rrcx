//
//  CXMyVisitorsViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyVisitorsViewController.h"
#import "CXFansTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXUserHomeViewController.h"
@interface CXMyVisitorsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * peopleList;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation CXMyVisitorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的访客";
    _currentPage = 1;
    [self initlizationData];
    [self initlizationViews];
}
-(void)initlizationData{
    _currentPage = 1;
    [self loadMyVisitorsListData];
    
}
-(void)initlizationViews{
    [self.view addSubview:self.peopleList];
    
}




-(void)loadMyVisitorsListData{
    
    [CXHomeRequest getMyVisitorsListWithParameters:@{@"person_id":_member_id?:@"",@"page":@(_currentPage),@"page_size":@10} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        [self.peopleList.mj_header endRefreshing];
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray * array = [NSArray yy_modelArrayWithClass:[CXListPeople class] json:response[@"data"][@"visitorList"]];
       // [self.dataArray addObjectsFromArray:array];
        if (array.count) {
            [self.peopleList.mj_footer endRefreshing];
            for (CXListPeople * people in array) {
                if (_dataArray.count) {
                    NSMutableArray * keyArr = [NSMutableArray new];
                    for (NSDictionary * dict in _dataArray) {
                        NSString * key = [dict allKeys][0];
                        [keyArr addObject:key];
                    }
                    //如果已经存在当前日期
                    if ([keyArr containsObject:people.add_time]) {
                        for (NSInteger i = 0; i<_dataArray.count;i++) {
                            NSDictionary * dic = _dataArray[i];
                            NSString * date = [dic allKeys][0];
                            if ([people.add_time isEqualToString:date]) {
                                NSMutableArray * arr = [NSMutableArray arrayWithArray:dic[date]];
                                [arr addObject:people];
                                NSDictionary * newDic = @{date:arr};
                                [_dataArray replaceObjectAtIndex:i withObject:newDic];
                                
                            }
                        }
                    }
                    //如果不包含当前日期
                    else{
                        NSMutableArray * arr = [NSMutableArray arrayWithObject:people];
                        NSDictionary * newDic = @{people.add_time:arr};
                        [_dataArray addObject:newDic];
                    }
                    
                }
                else{
                    NSMutableArray * arr = [NSMutableArray arrayWithObject:people];
                    NSDictionary * newDic = @{people.add_time:arr};
                    [_dataArray addObject:newDic];
                }
                
            }
            [self.peopleList reloadData];
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
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = _dataArray[section];
    NSArray * array = [dic.allValues firstObject];

    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic = _dataArray[section];
    return dic.allKeys[0];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"peopleCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        NSDictionary * dic = _dataArray[indexPath.section];
        NSArray * array = [dic.allValues firstObject];
        CXListPeople * model = array[indexPath.row];
        [cell setPeople:model];
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXFansTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCell"];
    NSDictionary * dic = _dataArray[indexPath.section];
    NSArray * array = [dic.allValues firstObject];
    CXListPeople * model = array[indexPath.row];
    cell.people = model;
    cell.followBtn.hidden = YES;
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _dataArray[indexPath.section];
    NSArray * array = [dic.allValues firstObject];
    CXListPeople * model = array[indexPath.row];
    CXUserHomeViewController * userHomeVC = [[CXUserHomeViewController alloc] init];
    userHomeVC.member_id = model.member_id;
    [self.navigationController pushViewController:userHomeVC animated:YES];
}




-(UITableView *)peopleList{
    if (!_peopleList) {
        _peopleList = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStyleGrouped];
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
    [self loadMyVisitorsListData];
}
-(void)reloadAllData{
    _currentPage = 1;
    [self loadMyVisitorsListData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
