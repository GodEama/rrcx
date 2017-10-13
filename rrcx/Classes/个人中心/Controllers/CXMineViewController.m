//
//  CXMineViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMineViewController.h"
#import "CXMineHeaderView.h"
#import "CXMineServiceTableViewCell.h"
#import "CXSettingViewController.h"
#import "CXLoginViewController.h"
#import "MainNavigationController.h"
#import "CXUser.h"
#import "CXUserHomeViewController.h"
#import "CXPeopleListViewController.h"
#import "CXMyVisitorsViewController.h"
#import "CXMyCollectViewController.h"
#import "CXMyCommentViewController.h"
@interface CXMineViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) CXMineHeaderView * headerView;
@property (nonatomic, strong) UITableView * mineTable;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) CXUser * user;

@end

@implementation CXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@[@"一键服务"],@[@"文章管理",@"动态管理",@"评论管理"],@[@"已购服务",@"我的收藏",@"服务号管理"],@[@"设置"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initializationView];
    
}

- (void)initializationView {

    [self.view addSubview:self.mineTable];
    WeakSelf(weakSelf)
    self.headerView.avatarClickBlock = ^{
        if (TOKEN && weakSelf.user.member_id) {
            CXUserHomeViewController * userHomeVC = [[CXUserHomeViewController alloc] init];
            userHomeVC.member_id = weakSelf.user.member_id;
            [weakSelf.navigationController pushViewController:userHomeVC animated:YES];
        }
        else{
            CXLoginViewController *writeVc = [[CXLoginViewController alloc] init];
            MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
            
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
        
    };
    
    
}
-(void)getUserData{
    [CXHomeRequest getSelfInfo:nil responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            _user = [CXUser yy_modelWithJSON:response[@"data"]];
            self.headerView.member_nick = _user.member_nick;
            self.headerView.member_follows = _user.member_follows;
            self.headerView.member_focus = _user.member_focus;
            self.headerView.member_visitor = _user.member_focus;
            self.headerView.member_avatar = _user.member_avatar;
            [[NSUserDefaults standardUserDefaults] setObject:_user.member_avatar forKey:@"member_avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:_user.member_nick forKey:@"member_nick"];
            

        }
        else{
            self.headerView.member_nick = @"点击登录";
            self.headerView.member_follows = @"0";
            self.headerView.member_focus = @"0";
            self.headerView.member_visitor = @"0";
            self.headerView.member_avatar = @"0";
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = _titleArr[section];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CXMineServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        cell.titleLab.text = @"一键服务";
        [cell.serviceSwitch setOn:NO];
        cell.hintLab.text = @"已下架";
        __weak CXMineServiceTableViewCell * weakCell = cell;
        cell.switchServiceBlock = ^(BOOL isOn) {
            weakCell.hintLab.text = isOn?@"已上架":@"已下架";
        };
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
        cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
        if (indexPath.section == 2&&indexPath.row == 2) {
            cell.textLabel.textColor = BasicColor;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!TOKEN) {
        [self goToLogin];
        return;
    }
    if (indexPath.section == 3) {
        CXSettingViewController * settingVC = [[CXSettingViewController alloc] init];
        settingVC.user = self.user;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0||indexPath.row == 1) {
            CXUserHomeViewController * userhomeVC = [[CXUserHomeViewController alloc] init];
            userhomeVC.member_id = _user.member_id;
            [self.navigationController pushViewController:userhomeVC animated:YES];
        }
        else if (indexPath.row == 2){
            CXMyCommentViewController * commentVC = [[CXMyCommentViewController alloc] init];
            [self.navigationController pushViewController:commentVC animated:YES];
            
            
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            CXMyCollectViewController * collectVC = [[CXMyCollectViewController alloc] init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = scrollView.contentOffset;
    if (point.y < -200) {
        CGRect rect = _headerView.frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        _headerView.frame = rect;
        _headerView.topImageHeight.constant =  - point.y;
    }
}


-(UITableView *)mineTable{
    if (!_mineTable) {
        _mineTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight -49) style:UITableViewStyleGrouped];
        _mineTable.delegate = self;
        _mineTable.dataSource = self;
        [_mineTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalCell"];
        [_mineTable registerClass:[CXMineServiceTableViewCell class] forCellReuseIdentifier:@"switchCell"];
        _mineTable.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        [_mineTable addSubview:self.headerView];
        _mineTable.estimatedRowHeight = 0;
        _mineTable.estimatedSectionHeaderHeight = 0;
        _mineTable.estimatedSectionFooterHeight = 0;
    }
    return _mineTable;
}
-(CXMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CXMineHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, -200, KWidth, 200);
        WeakSelf(weakSelf)
        _headerView.fansClickBlock = ^{
            if (TOKEN) {
                CXPeopleListViewController * listVC = [[CXPeopleListViewController alloc] init];
                listVC.member_id = weakSelf.user.member_id;
                listVC.listType = peopleListTypeMyFans;
                [weakSelf.navigationController pushViewController:listVC animated:YES];
            }
            else{
                [weakSelf goToLogin];
            }
            
        };
        _headerView.focusClickBlock = ^{
            if (TOKEN) {
                CXPeopleListViewController * listVC = [[CXPeopleListViewController alloc] init];
                listVC.member_id = weakSelf.user.member_id;
                listVC.listType = peopleListTypeMyFollows;
                [weakSelf.navigationController pushViewController:listVC animated:YES];
            }
            else{
                [weakSelf goToLogin];
            }
            
        };
        _headerView.visitorClickBlock = ^{
            if (TOKEN) {
                CXMyVisitorsViewController * listVC = [[CXMyVisitorsViewController alloc] init];
                listVC.member_id = weakSelf.user.member_id;
                [weakSelf.navigationController pushViewController:listVC animated:YES];
            }
            else{
                [weakSelf goToLogin];
            }
            
        };
    }
    return _headerView;
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





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self getUserData];
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
