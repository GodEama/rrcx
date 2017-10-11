//
//  CXLoginViewController.m
//  rrcx
//
//  Created by 123 on 2017/8/30.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXLoginViewController.h"
#import "PooCodeView.h"
#import "CXRegistViewController.h"
#import "CXForgetPwViewController.h"
#import "CXHomeArticleListViewController.h"
#import "CXArticleHomeViewController.h"


@interface CXLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *pwView;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;


@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;

@property (weak, nonatomic) IBOutlet UIButton *showPwBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet PooCodeView *pooCodeView;








@end

@implementation CXLoginViewController
{
    BOOL _showPw;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameView.layer.masksToBounds = YES;
    _usernameView.layer.cornerRadius = 20;
    _usernameView.layer.borderWidth = 1;
    _usernameView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _pwView.layer.masksToBounds = YES;
    _pwView.layer.cornerRadius = 20;
    _pwView.layer.borderWidth = 1;
    _pwView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _codeView.layer.masksToBounds = YES;
    _codeView.layer.cornerRadius = 20;
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _codeImg.layer.masksToBounds = YES;
    _codeImg.layer.cornerRadius = 15;
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 20;
    
    _pooCodeView.layer.masksToBounds = YES;
    _pooCodeView.layer.cornerRadius = 16;
    
    [_codeTF addTarget:self action:@selector(authCode:) forControlEvents:UIControlEventAllEditingEvents];
    
    
}

- (IBAction)showPwClick:(id)sender {
    _showPw  = !_showPw;
    [_showPwBtn setImage:[UIImage imageNamed:_showPw?@"eyes-open":@"eyes-closed"] forState:UIControlStateNormal];
    _pwTF.secureTextEntry = !_showPw;
    
}
-(void)authCode:(UITextField *)TF{
    if (TF.text.length == 4) {
        int result1 = [_pooCodeView.changeString compare:_codeTF.text options:NSCaseInsensitiveSearch];
        
        if ((_pooCodeView.changeString.length == _codeTF.text.length ) && (result1 == 0)) {
            NSLog(@"匹配正确");
        }
        else{
            NSLog(@"验证码错误");
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20,@20,@-20];
            //        [authCodeView.layer addAnimation:anim forKey:nil];
            [_codeView.layer addAnimation:anim forKey:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_pooCodeView changeCode];
                _codeTF.text = @"";
                
            });
        }
    }
    
    
}


- (IBAction)loginClick:(id)sender {
    [CXHomeRequest loginWithPhone:@{@"phone":_usernameTF.text,@"password":_pwTF.text} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:response[@"data"][@"auth_token"] forKey:@"USERTOKEN"];
            [[NSUserDefaults standardUserDefaults] setObject:response[@"data"][@"member_id"] forKey:@"USERID"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        DLog(@">>>>%@",error);
    }];

}

- (IBAction)registClick:(id)sender {
    CXRegistViewController * registeVC = [[CXRegistViewController alloc] init];
    [self.navigationController pushViewController:registeVC animated:YES];
}

- (IBAction)forgetPwClick:(id)sender {
    CXForgetPwViewController * forgetPwVC = [[CXForgetPwViewController alloc] init];
    [self.navigationController pushViewController:forgetPwVC animated:YES];
}

- (IBAction)qqLogin:(id)sender {
    
}

- (IBAction)weiboLogin:(id)sender {
}

- (IBAction)weixinLogin:(id)sender {
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)cancelLogin:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
