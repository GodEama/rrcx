//
//  CXForgetPwViewController.m
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXForgetPwViewController.h"
#import "CXResetPwViewController.h"
@interface CXForgetPwViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;





@end

@implementation CXForgetPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = RGB(248, 249, 250);
    _phoneView.layer.masksToBounds = YES;
    _phoneView.layer.cornerRadius = 20;
    _phoneView.layer.borderWidth = 1;
    _phoneView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    
    _codeView.layer.masksToBounds = YES;
    _codeView.layer.cornerRadius = 20;
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 20;
}
- (IBAction)sendCode:(id)sender {
    
    if (_phoneTF.text.length != 11||![FuncManage theStringIsPhone:_phoneTF.text]) {
        [Message showMiddleHint:@"请输入正确的手机号"];
        
    }
    else{
        _sendCodeBtn.userInteractionEnabled = NO;
        
        [CXHomeRequest sendSmsCode:@{@"sms_type":@"change_pwd_captcha",@"phone":_phoneTF.text,@"image_captcha":@""} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [self openCountdown];
            }
        } failure:^(NSError *error) {
            _sendCodeBtn.userInteractionEnabled = YES;
            
        }];
        
    }
    
    
}

- (IBAction)nextStep:(id)sender {
    [CXHomeRequest checkPhone:@{@"phone":_phoneTF.text,@"sms_code":_codeTF.text} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            CXResetPwViewController * resetPwVC = [[CXResetPwViewController alloc] init];
            resetPwVC.phone = _phoneTF.text;
            resetPwVC.sms_code = _codeTF.text;
            [self.navigationController pushViewController:resetPwVC animated:YES];
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
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
