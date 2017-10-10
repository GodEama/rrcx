//
//  CXSettingViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/8.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSettingViewController.h"
#import "CXCacheTableViewCell.h"
#import "CXUserInfoViewController.h"
#import "CXChangePhoneViewController.h"
#import "CXForgetPwViewController.h"
#import "CXSetVacationViewController.h"

@interface CXSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * settingTable;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,strong) UIButton * logoutBtn;
@end

@implementation CXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"设置";
    _dataArray = @[@[@"编辑资料",@"修改密码",@"更换手机号"],@[@"行业",@"申请加V",@"清除缓存",@"检查更新"]];
    [self.view addSubview:self.settingTable];
    
 
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = _dataArray[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 &&indexPath.row == 2) {
        CXCacheTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cacheCell"];
        cell.titleLab.text = _dataArray[indexPath.section][indexPath.row];
        long long size =[[SDImageCache sharedImageCache]getSize] + [PPNetworkCache getAllHttpCacheSize];
        cell.hintLab.text = [NSString stringWithFormat:@"当前缓存%.2fMb",size/1024.0/1024.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
            CXUserInfoViewController * userinfoVC = [[CXUserInfoViewController alloc] init];
                userinfoVC.user = self.user;
                [self.navigationController pushViewController:userinfoVC animated:YES];
            }
                
                break;
            case 1:{
                CXForgetPwViewController * resetPwVC = [[CXForgetPwViewController alloc] init];
                [self.navigationController pushViewController:resetPwVC animated:YES];
            }
                
                break;
            case 2:{
                CXChangePhoneViewController * changeVC = [[CXChangePhoneViewController alloc] init];
                [self.navigationController pushViewController:changeVC animated:YES];
            }
                
                break;
                
            default:
                break;
        }
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CXSetVacationViewController * hyVC = [[CXSetVacationViewController alloc] init];
            [self.navigationController pushViewController:hyVC animated:YES];
        }
        else if (indexPath.row == 1){
            
        }
        else if (indexPath.row == 2) {
            [self clearCache];
        }
    }
    
    
}

/**
 清除缓存
 */
-(void)clearCache{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [PPNetworkCache removeAllHttpCache];
            [_settingTable reloadData];
        }];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



-(UITableView *)settingTable{
    if (!_settingTable) {
        _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStyleGrouped];
        _settingTable.delegate = self;
        _settingTable.dataSource = self;
        _settingTable.rowHeight = 45;
        [_settingTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_settingTable registerClass:[CXCacheTableViewCell class] forCellReuseIdentifier:@"cacheCell"];
        [_settingTable setTableFooterView:self.footerView];
        _settingTable.estimatedRowHeight = 0;
        _settingTable.estimatedSectionHeaderHeight = 0;
        _settingTable.estimatedSectionFooterHeight = 0;
    }
    return _settingTable;
}
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 60 + 45 + 2 +60)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = RGB(227, 227, 227);
        [_footerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.top.equalTo(_footerView).offset(60);
            make.height.equalTo(@1);
        }];
        [_footerView addSubview:self.logoutBtn];
        [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.top.equalTo(line.mas_bottom);
            make.right.equalTo(_footerView);
            make.height.equalTo(@45);
        }];
        
        
        UIView * line1 = [[UIView alloc] init];
        line1.backgroundColor = RGB(227, 227, 227);
        [_footerView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.bottom.equalTo(_footerView).offset(-60);
            make.height.equalTo(@1);
        }];
        
        [self.logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footerView;
}

-(UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.backgroundColor = [UIColor whiteColor];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:BasicColor forState:UIControlStateNormal];
    }
    return _logoutBtn;
}

-(void)logoutClick{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定退出当前帐号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERTOKEN"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
