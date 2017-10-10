//
//  CXRegisteCompleteViewController.m
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXRegisteCompleteViewController.h"
#import "JSDropDownMenu.h"
#import "CXHangye.h"
#import "CXArea.h"
@interface CXRegisteCompleteViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *pwView;
@property (weak, nonatomic) IBOutlet UIView *confirmPwView;
@property (weak, nonatomic) IBOutlet UIView *selectView;


@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@property (nonatomic, strong) JSDropDownMenu * menu;

@property (nonatomic, strong) NSMutableArray * data;
@property (nonatomic, strong) NSMutableArray * provinceData;
@property (nonatomic, strong) NSMutableArray * cityData;
@property (nonatomic, strong) CXHangye * hangye;
@property (nonatomic, strong) JSDropDownMenu * provinceMenu;
@property (nonatomic, strong) JSDropDownMenu * cityMenu;
@property (nonatomic, copy)   NSString * provinceId;
@property (nonatomic, copy)   NSString * cityId;

@property (weak, nonatomic) IBOutlet UIView *provinceView;
@property (weak, nonatomic) IBOutlet UIView *cityView;


@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;

@end

@implementation CXRegisteCompleteViewController
{
    NSInteger  _currentDataIndex;
    NSInteger  _currentProvinceIndex;
    NSInteger  _currentCityIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    _usernameView.layer.masksToBounds = YES;
    _usernameView.layer.cornerRadius = 20;
    _usernameView.layer.borderWidth = 1;
    _usernameView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _pwView.layer.masksToBounds = YES;
    _pwView.layer.cornerRadius = 20;
    _pwView.layer.borderWidth = 1;
    _pwView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _confirmPwView.layer.masksToBounds = YES;
    _confirmPwView.layer.cornerRadius = 20;
    _confirmPwView.layer.borderWidth = 1;
    _confirmPwView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _completeBtn.layer.masksToBounds = YES;
    _completeBtn.layer.cornerRadius = 20;
    
    
    _selectView.layer.masksToBounds = YES;
    _selectView.layer.cornerRadius = 4;
    _selectView.layer.borderWidth = 1;
    _selectView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    
    [self loadHangyeData];
    _provinceData = [NSMutableArray new];
    _cityData = [NSMutableArray new];
    [self loadProvinceData];
    _currentDataIndex = -1;
    _currentCityIndex = -1;
    _currentProvinceIndex = -1;
   
    
}




-(void)loadHangyeData{
    [CXHomeRequest getHangyeData:nil success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXHangye class] json:response[@"data"][@"list"]];
            _data = [NSMutableArray arrayWithArray:array];
            _menu = [[JSDropDownMenu alloc] initWithRect:CGRectMake(CGRectGetMinX(self.selectView.frame),CGRectGetMinY(self.selectView.frame), CGRectGetWidth(_selectView.bounds), CGRectGetHeight(_selectView.bounds)) andHeight:40];
            _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
            _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
            _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
            _menu.dataSource = self;
            _menu.delegate = self;
            _currentDataIndex = 0;
            [_bgView addSubview:self.menu];
            [self.bgView addSubview:self.cityMenu];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)loadProvinceData{
    [CXHomeRequest getAreaData:@{@"pid":@"0"} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXArea class] json:response[@"data"][@"list"]];
            _provinceData = [NSMutableArray arrayWithArray:array];
            [self.bgView addSubview:self.provinceMenu];
            [self loadCityData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)loadCityData{
    [CXHomeRequest getAreaData:@{@"pid":_provinceId?:@"1"} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXArea class] json:response[@"data"][@"list"]];
            _cityData = [NSMutableArray arrayWithArray:array];
            
            [self.cityMenu reloadLeftTableData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}



- (IBAction)completeBtnClick:(id)sender {
    if (!_hangye) {
        [Message showMiddleHint:@"请选择自己所属行业"];
    }
    else if (!_provinceId){
        [Message showMiddleHint:@"请选择自己所在省份"];

    }
    else if (!_cityId){
        [Message showMiddleHint:@"请选择自己所在城市"];
        
    }
    else if (![_confirmTF.text isEqualToString:_passwordTF.text]){
        [Message showMiddleHint:@"两次密码输入不一致"];
    }else if(_nicknameTF.text.length == 0 ||_passwordTF.text.length == 0||_confirmTF.text.length == 0){
        [Message showMiddleHint:@"请输入完整信息"];
    }
    else{
        [CXHomeRequest completeRegist:@{@"member_nick":_nicknameTF.text,@"password":_passwordTF.text,@"password2":_confirmTF.text,@"hy_id":_hangye.ID,@"member_area":_provinceId?:@"",@"member_city":_cityId?:@""} success:^(id response) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
        
        }];
    }

    
}
-(JSDropDownMenu *)provinceMenu{
    if (!_provinceMenu ) {
        _provinceMenu = [[JSDropDownMenu alloc] initWithRect:CGRectMake(CGRectGetMinX(self.provinceView.frame),CGRectGetMinY(self.provinceView.frame), CGRectGetWidth(_provinceView.bounds), CGRectGetHeight(_provinceView.bounds)) andHeight:40];
        _provinceMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        _provinceMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
        _provinceMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        _provinceMenu.dataSource = self;
        _provinceMenu.delegate = self;
    }
    return _provinceMenu;
}
-(JSDropDownMenu *)cityMenu{
    if (!_cityMenu ) {
        _cityMenu = [[JSDropDownMenu alloc] initWithRect:CGRectMake(CGRectGetMinX(self.cityView.frame),CGRectGetMinY(self.cityView.frame), CGRectGetWidth(_cityView.bounds), CGRectGetHeight(_cityView.bounds)) andHeight:40];
        _cityMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        _cityMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
        _cityMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        _cityMenu.dataSource = self;
        _cityMenu.delegate = self;
    }
    return _cityMenu;
}

#pragma mark -
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (menu == _provinceMenu) {
        return _provinceData.count;
    }
    else if (menu == _cityMenu){
        return _cityData.count;
    }
    else{
        return _data.count;
    }
    
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}


-(NSInteger)menu:(JSDropDownMenu *)menu currentLeftSelectedRow:(NSInteger)column{
    if (menu == _provinceMenu) {
        return _currentProvinceIndex;
    }
    else if (menu == _cityMenu){
        return _currentCityIndex;
    }
    else{
        return _currentDataIndex;
    }
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    if (menu == _provinceMenu) {
        return @"选择省份";
    }
    else if (menu == _cityMenu){
        return @"选择城市";
    }
    else{
        return @"选择行业";
    }

}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (menu == _provinceMenu) {
        CXArea * pro = _provinceData[indexPath.row];
        return pro.area_name;
    }
    else if (menu == _cityMenu){
        
        CXArea * city = _cityData[indexPath.row];
        return city.area_name;
    }
    else{
        CXHangye * cate = _data[indexPath.row];
        return cate.title;
        
    }
    
   
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (menu == _provinceMenu) {
        CXArea * pro = _provinceData[indexPath.row];
        _provinceId = pro.area_id;
        _cityId = nil;
        [self loadCityData];
    }
    else if (menu == _cityMenu){
        CXArea * city = _cityData[indexPath.row];
        _cityId = city.area_id;
    }
    else{
        
        _currentDataIndex = indexPath.row;
        _hangye = _data[indexPath.row];
    }    
    
}












-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
