//
//  CXChangePhoneViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXChangePhoneViewController.h"
#import "CXChangPhoneStepViewController.h"
@interface CXChangePhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currentPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;










@end

@implementation CXChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 4;
    [_currentPhoneTF setValue:@11 forKey:@"limit"];
    [_PhoneTF setValue:@11 forKey:@"limit"];
}




- (IBAction)nextBtnClick:(id)sender {
    if ([FuncManage theStringIsPhone:_currentPhoneTF.text]&&[FuncManage theStringIsPhone:_PhoneTF.text]) {
        if ([_currentPhoneTF.text isEqualToString:_PhoneTF.text]) {
            [Message showMiddleHint:@"两个手机号不能相同"];
            
        }
        else{
            CXChangPhoneStepViewController * changePhoneVC = [[CXChangPhoneStepViewController alloc] init];
            [self.navigationController pushViewController:changePhoneVC animated:YES];
        }
    }
    else{
        [Message showMiddleHint:@"请输入正确的手机号"];
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
