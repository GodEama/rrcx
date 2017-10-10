//
//  CXRegistViewController.m
//  rrcx
//
//  Created by 123 on 2017/8/30.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXRegistViewController.h"
#import "PooCodeView.h"
#import "CXRegisteCompleteViewController.h"
@interface CXRegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *usernameView;

@property (weak, nonatomic) IBOutlet UIView *imageCodeView;
@property (weak, nonatomic) IBOutlet UIView *phoneCodeView;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *imageCodeTF;
@property (weak, nonatomic) IBOutlet PooCodeView *pooCodeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;






@end

@implementation CXRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    _usernameView.layer.masksToBounds = YES;
    _usernameView.layer.cornerRadius = 20;
    _usernameView.layer.borderWidth = 1;
    _usernameView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _imageCodeView.layer.masksToBounds = YES;
    _imageCodeView.layer.cornerRadius = 20;
    _imageCodeView.layer.borderWidth = 1;
    _imageCodeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _phoneCodeView.layer.masksToBounds = YES;
    _phoneCodeView.layer.cornerRadius = 20;
    _phoneCodeView.layer.borderWidth = 1;
    _phoneCodeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
 
    
    _registBtn.layer.masksToBounds = YES;
    _registBtn.layer.cornerRadius = 20;
    
    _pooCodeView.layer.masksToBounds = YES;
    _pooCodeView.layer.cornerRadius = 16;
    
    [_imageCodeTF addTarget:self action:@selector(authCode:) forControlEvents:UIControlEventAllEditingEvents];
    [_phoneTF addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventAllEditingEvents];
    [_phoneCodeTF addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventAllEditingEvents];
    _agreeBtn.layer.masksToBounds = YES;
    _agreeBtn.layer.cornerRadius = 2;
    _agreeBtn.layer.borderWidth = 1;
    _agreeBtn.layer.borderColor = RGB(255, 141, 83).CGColor;
    _registBtn.userInteractionEnabled = NO;
    _registBtn.backgroundColor = RGB(176, 178, 179);
    
    [_phoneTF setValue:@11 forKey:@"limit"];
    [_phoneCodeTF setValue:@6 forKey:@"limit"];
}

-(void)valuesChange:(UITextField*)sender{
    if ([FuncManage theStringIsPhone:_phoneTF.text]&&_phoneCodeTF.text.length >= 4) {
        _registBtn.userInteractionEnabled = YES;
        _registBtn.backgroundColor = BasicColor;
    }
    else{
        _registBtn.userInteractionEnabled = NO;
        _registBtn.backgroundColor = RGB(176, 178, 179);
        
    }
    
}


/**
 验证图片验证码，不区分大小写

 @param TF imageCodeTF
 */
-(void)authCode:(UITextField *)TF{
    if (TF.text.length == 4) {
        int result1 = [_pooCodeView.changeString compare:_imageCodeTF.text options:NSCaseInsensitiveSearch];
        
        if ((_pooCodeView.changeString.length == _imageCodeTF.text.length ) && (result1 == 0)) {
            NSLog(@"匹配正确");
        }
        else{
            NSLog(@"验证码错误");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_pooCodeView changeCode];
                
                _imageCodeTF.text = @"";
            });
        }
    }
    
    
}

/**
 获取验证码

 @param sender btn
 */
- (IBAction)sendCodeBtnClick:(id)sender {
    
    if (_phoneTF.text.length != 11||![FuncManage theStringIsPhone:_phoneTF.text]) {
        [Message showMiddleHint:@"请输入正确的手机号"];
        
    }
    else{
        _sendCodeBtn.userInteractionEnabled = NO;
        
        [CXHomeRequest sendSmsCode:@{@"sms_type":@"register_captcha",@"phone":_phoneTF.text,@"image_captcha":@""} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [self openCountdown];
            }
        } failure:^(NSError *error) {
            _sendCodeBtn.userInteractionEnabled = YES;
            
        }];
        
    }
    
    
}

/**
 注册

 @param sender btn
 */
- (IBAction)registUser:(id)sender {
    
    
//    CXRegisteCompleteViewController * registVC = [[CXRegisteCompleteViewController alloc] init];
//    [self.navigationController pushViewController:registVC animated:YES];

    [CXHomeRequest registUser:@{@"phone":_phoneTF.text,@"sms_code":_phoneCodeTF.text} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:response[@"data"][@"Auth-Token"] forKey:@"USERTOKEN"];
            CXRegisteCompleteViewController * registVC = [[CXRegisteCompleteViewController alloc] init];
            [self.navigationController pushViewController:registVC animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)agreeClick:(id)sender {
    
}
- (IBAction)lookTheProtcol:(id)sender {
    
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
                [_sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                _sendCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%.2ds后重发", seconds] forState:UIControlStateNormal];
                _sendCodeBtn.userInteractionEnabled = NO;
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
