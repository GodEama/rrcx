//
//  CXResetPwViewController.m
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXResetPwViewController.h"

@interface CXResetPwViewController ()
@property (weak, nonatomic) IBOutlet UIView *pwView;
@property (weak, nonatomic) IBOutlet UIView *confirmPwView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;







@end

@implementation CXResetPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(248, 249, 250);
    self.title = @"重置密码";
    _pwView.layer.masksToBounds = YES;
    _pwView.layer.cornerRadius = 20;
    _pwView.layer.borderWidth = 1;
    _pwView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _confirmPwView.layer.masksToBounds = YES;
    _confirmPwView.layer.cornerRadius = 20;
    _confirmPwView.layer.borderWidth = 1;
    _confirmPwView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 20;
    [_pwTF setValue:@16 forKey:@"limit"];
    [_confirmTF setValue:@16 forKey:@"limit"];
    
}


- (IBAction)submitClick:(id)sender {
    if (_pwTF.text.length <6 ) {
        [Message showMiddleHint:@"密码长度至少6位"];
    }
    else if (![_pwTF.text isEqualToString:_confirmTF.text]){
        [Message showMiddleHint:@"两次输入密码不一致"];
    }
    else{
        [CXHomeRequest resetPassword:@{@"password":_pwTF.text,@"phone":_phone,@"sms_code":_sms_code} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [Message showMiddleHint:response[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
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
