//
//  CXChangPhoneStepViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXChangPhoneStepViewController.h"

@interface CXChangPhoneStepViewController ()



@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;



@end

@implementation CXChangPhoneStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _changeBtn.layer.masksToBounds = YES;
    _changeBtn.layer.cornerRadius = 4;
    _changeBtn.userInteractionEnabled = NO;
    [_codeTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTF setValue:@6 forKey:@"limit"];
}

- (IBAction)sendCodeClick:(id)sender {
    _sendCodeBtn.userInteractionEnabled = NO;
    [CXHomeRequest sendSmsCode:@{@"sms_type":@"change_info_captcha",@"phone":_phone,@"image_captcha":@""} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [self openCountdown];
        }
        else{
            [Message showMiddleHint:response[@"code"]];
        }
    } failure:^(NSError *error) {
        _sendCodeBtn.userInteractionEnabled = YES;
        
    }];
}

- (IBAction)changePhone:(id)sender {
    
    
}
-(void)valueChange:(UITextField *)textField{
    if (textField.text.length >5) {
        _sendCodeBtn.userInteractionEnabled = YES;
        _sendCodeBtn.backgroundColor = BasicColor;
    }
    else{
        _sendCodeBtn.userInteractionEnabled = NO;
        _sendCodeBtn.backgroundColor = RGB(176, 178, 179);
        
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
