//
//  CXLoactionsViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXLoactionsViewController.h"

@interface CXLoactionsViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    AMapSearchAPI* _search;
    AMapPOIAroundSearchRequest *request;
}


@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) UITableView * locationTable;
@property (nonatomic, strong) NSMutableArray * loactionsArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSIndexPath * lastIndex;
@property (nonatomic, assign) BOOL isAdd;//是否把之前选过的poi放在了前面
@property (nonatomic, strong) AMapPOI * poi;
@end

@implementation CXLoactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"位置";
    _loactionsArray = [[NSMutableArray alloc] init];
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.page = 1;
    [self sendRequest];
    if (self.lastPoi) {
        [_loactionsArray addObject:self.lastPoi];
        _lastIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    else{
        _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initlizationViews];
}

-(void)initlizationViews{
    
    UIBarButtonItem * rightIteam = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClick)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [rightIteam setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightIteam;
    
    UIBarButtonItem * leftIteam = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSend)];
    
    NSDictionary *attrsDic1=@{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:16],
                              };
    [leftIteam setTitleTextAttributes:attrsDic1 forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftIteam;
    [self.view addSubview:self.locationTable];
}

-(void)sendButtonClick{
    if (self.selectAddressBlock) {
        self.selectAddressBlock(self.poi);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelSend{
    [self.navigationController popViewControllerAnimated:YES];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _loactionsArray.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"loactionCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"loactionCell"];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"不显示位置";
        cell.detailTextLabel.text = @"";
        
    }
    else{
        AMapPOI * poi = _loactionsArray[indexPath.row - 1];
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;
        
    }
   
       cell.accessoryType = _lastIndex.row == indexPath.row?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
   
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_lastIndex) {
        if (_lastIndex.row != indexPath.row) {
            UITableViewCell * lastCell = [tableView cellForRowAtIndexPath:_lastIndex];
            lastCell.accessoryType = UITableViewCellAccessoryNone;
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _lastIndex = indexPath;
        }
        self.poi = indexPath.row == 0?nil:_loactionsArray[indexPath.row -1];
    }
    
}


-(UITableView *)locationTable{
    if (!_locationTable) {
        _locationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight-kTopHeight) style:UITableViewStylePlain];
        _locationTable.delegate = self;
        _locationTable.dataSource = self;
//        [_locationTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"loactionCell"];
        [FuncManage addRefurbishWithTarget:self scrollView:_locationTable upSel:@selector(loadMoreData) downSel:nil];
        _locationTable.estimatedRowHeight = 0;
        _locationTable.estimatedSectionHeaderHeight = 0;
        _locationTable.estimatedSectionFooterHeight = 0;
    }
    return _locationTable;
}

- (void)loadNewData {
    [self.loactionsArray removeAllObjects];
    [self.locationTable reloadData];
    self.page = 1;
    [self sendRequest];
}

- (void)loadMoreData {
    self.page ++;
    request.page = self.page;
    [_search AMapPOIAroundSearch: request];
}
//***************************************位置相关******************************
- (void) sendRequest {
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    request = [[AMapPOIAroundSearchRequest alloc] init];
    request.keywords = nil;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"地名地址信息|体育休闲服务|科教文化服务|公司企业|风景名胜";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.page = self.page;
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 5;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 5;
    
    // 带逆地理（返回坐标和地址信息）
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"失败" message:@"获取位置失败，试试右上角的“刷新位置”？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            //            [alertview show];
            
        }
        AMapPOI *p = [[AMapPOI alloc] init];
        p.name = [NSString stringWithFormat:@"%@%@", regeocode.city == nil ? @"" : regeocode.city, regeocode.district == nil ? @"" : regeocode.district];
        p.address = regeocode.province;
        [self.loactionsArray addObject:p];
        CLLocationCoordinate2D coor = location.coordinate;
        request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
        [_search AMapPOIAroundSearch: request];
    }];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count != 0)
    {
        for (AMapPOI * poi in response.pois) {
            if (![poi.uid isEqualToString:self.lastPoi.uid]) {
                [self.loactionsArray addObject:poi];
            }
        }
        [self.locationTable reloadData];
        
    } else {
        
    }
    
    
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
