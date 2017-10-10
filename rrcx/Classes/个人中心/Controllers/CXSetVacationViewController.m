//
//  CXSetVacationViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSetVacationViewController.h"
#import "JSDropDownMenu.h"
#import "CXHangye.h"
@interface CXSetVacationViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>
{
    NSInteger  _currentDataIndex;
}
@property (weak, nonatomic) IBOutlet UIView *vacationView;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *sendcodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;


@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (nonatomic, strong) NSMutableArray * data;
@property (nonatomic, strong) JSDropDownMenu * menu;
@property (nonatomic, strong) CXHangye * hangye;




@end

@implementation CXSetVacationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"设置行业";
    _vacationView.layer.masksToBounds = YES;
    _vacationView.layer.cornerRadius = 4;
    _vacationView.layer.borderWidth = 1;
    _vacationView.layer.borderColor = RGB(210, 212, 213).CGColor;
    
    _phoneView.layer.masksToBounds = YES;
    _phoneView.layer.cornerRadius = 4;
    _phoneView.layer.borderWidth = 1;
    _phoneView.layer.borderColor = RGB(210, 212, 213).CGColor;
    
    _codeView.layer.masksToBounds = YES;
    _codeView.layer.cornerRadius = 4;
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = RGB(210, 212, 213).CGColor;
    
    [_codeTF setValue:@6 forKey:@"limit"];
    [_phoneTF setValue:@11 forKey:@"limit"];
    [_codeTF addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventAllEditingEvents];
    [_phoneTF addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventAllEditingEvents];
    [self loadHangyeData];
}

- (IBAction)sendCodeBtnClick:(id)sender {
    _sendcodeBtn.userInteractionEnabled = NO;
    [CXHomeRequest sendSmsCode:@{@"sms_type":@"change_info_captcha",@"phone":_phoneTF.text,@"image_captcha":@""} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [self openCountdown];
        }
        else{
            [Message showMiddleHint:response[@"code"]];
        }
    } failure:^(NSError *error) {
        _sendcodeBtn.userInteractionEnabled = YES;
        
    }];
    
}

- (IBAction)setVationBtnClick:(id)sender {
    [CXHomeRequest setHangyeWithParameters:@{@"hy_id":_hangye.ID} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadHangyeData{
    [CXHomeRequest getHangyeData:nil success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXHangye class] json:response[@"data"][@"list"]];
            _data = [NSMutableArray arrayWithArray:array];
            _menu = [[JSDropDownMenu alloc] initWithRect:CGRectMake(CGRectGetMinX(self.vacationView.frame),CGRectGetMinY(self.vacationView.frame), CGRectGetWidth(_vacationView.bounds), CGRectGetHeight(_vacationView.bounds)) andHeight:40];
            _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
            _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
            _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
            _menu.dataSource = self;
            _menu.delegate = self;
        _currentDataIndex = 0;
        [_bgView addSubview:self.menu];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark -
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    return _data.count;
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}


-(NSInteger)menu:(JSDropDownMenu *)menu currentLeftSelectedRow:(NSInteger)column{
    return _currentDataIndex;

}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    return @"选择行业";
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    CXHangye * cate = _data[indexPath.row];
    return cate.title;
    
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    _currentDataIndex = indexPath.row;
    _hangye = _data[indexPath.row];
    
    
}




-(void)valueChanged{
    if ([FuncManage theStringIsPhone:_phoneTF.text]&&_codeTF.text.length >= 4) {
        _changeBtn.backgroundColor = BasicColor;
        _changeBtn.userInteractionEnabled = YES;
    }
    else{
        _changeBtn.backgroundColor = RGB(191, 191, 191);
        _changeBtn.userInteractionEnabled = NO;
    }
    
}



// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [_sendcodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                _sendcodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_sendcodeBtn setTitle:[NSString stringWithFormat:@"%.2ds后重发", seconds] forState:UIControlStateNormal];
                _sendcodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
