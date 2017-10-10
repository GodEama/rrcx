//
//  CXSelectAreaViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/13.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSelectAreaViewController.h"
#import "CXArea.h"
@interface CXSelectAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * areaTable;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CXSelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizationDatas];
    [self initlizationViews];
    self.automaticallyAdjustsScrollViewInsets = NO;

}
-(void)initlizationViews{
    [self.view addSubview:self.areaTable];
}
-(void)initlizationDatas{
    _dataArray = [NSMutableArray new];
    [self getAreaData];
}



-(void)getAreaData{
   
    [CXHomeRequest getAreaData:@{@"pid":_provinceId?_provinceId:@"0"} responseCache:^(id responseCaches) {
         [self reloadAreaDataWithResult:responseCaches];
    } success:^(id response) {
        [self.areaTable.mj_header endRefreshing];
        [self reloadAreaDataWithResult:response];
    } failure:^(NSError *error) {
        [self.areaTable.mj_header endRefreshing];
    }];
    
    
}
-(void)reloadAreaDataWithResult:(id)responseObject{
    if ([responseObject[@"code"] intValue] == 1) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[CXArea class] json:responseObject[@"data"][@"list"]];
        _dataArray = [NSMutableArray arrayWithArray:array];
        [self.areaTable reloadData];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CXArea * area = _dataArray[indexPath.row];
    switch (_type) {
        case 1:
            cell.textLabel.text = area.area_name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = area.area_name;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            cell.textLabel.text = area.area_name;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXArea * area = _dataArray[indexPath.row];
    switch (_type) {
        case 1:
        {
            CXSelectAreaViewController * selectVC = [[CXSelectAreaViewController alloc] init];
            selectVC.type = 2;
            
            selectVC.provinceId = area.area_id;
            selectVC.provinceName = area.area_name;
            selectVC.selectAreaBlock = ^(NSString *provinceId, NSString *provinceName, NSString *cityId, NSString *cityName) {
                if (self.selectAreaBlock) {
                    self.selectAreaBlock(provinceId, provinceName, cityId, cityName);
                }
            };
            [self.navigationController pushViewController:selectVC animated:YES];
        }
            break;
        case 2:
        {
            if (self.selectAreaBlock) {
                self.selectAreaBlock(self.provinceId, self.provinceName, self.cityId, self.cityName);
            }
            NSInteger count  = [self.navigationController.viewControllers count];
            [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
//            CXSelectAreaViewController * selectVC = [[CXSelectAreaViewController alloc] init];
//            selectVC.type = 3;
//            selectVC.provinceId = self.provinceId;
//            selectVC.provinceName = self.provinceName;
//            selectVC.cityId = area.area_id;
//            selectVC.cityName = area.area_name;
//            selectVC.selectAreaBlock = ^(NSString *provinceId, NSString *provinceName, NSString *cityId, NSString *cityName) {
//                if (self.selectAreaBlock) {
//                    self.selectAreaBlock(provinceId, provinceName, cityId, cityName);
//                }
//            };
//            [self.navigationController pushViewController:selectVC animated:YES];
        }
            break;
        case 3:
        {
            if (self.selectAreaBlock) {
                self.selectAreaBlock(self.provinceId, self.provinceName, self.cityId, self.cityName);
            }
            NSInteger count  = [self.navigationController.viewControllers count];
            [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
            //            for (UIViewController *controller in self.navigationController.viewControllers) {
            //
            //                if ([controller isKindOfClass:[JCaddressDetailViewController class]]) {
            //
            //                    [self.navigationController popToViewController:(JCaddressDetailViewController *)controller animated:YES];
            //
            //                }
            //
            //            }
            
            
        }
            break;
            
        default:
            break;
    }
}
-(UITableView *)areaTable{
    if (!_areaTable) {
        _areaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight-kTopHeight) style:UITableViewStylePlain];
        _areaTable.delegate = self;
        _areaTable.dataSource = self;
        [_areaTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [FuncManage addRefurbishWithTarget:self scrollView:_areaTable upSel:nil downSel:@selector(refreshData)];
        _areaTable.estimatedRowHeight = 0;
        _areaTable.estimatedSectionHeaderHeight = 0;
        _areaTable.estimatedSectionFooterHeight = 0;
    }
    return _areaTable;
}
-(void)refreshData{
    [self getAreaData];
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
