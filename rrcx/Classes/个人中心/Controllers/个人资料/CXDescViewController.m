//
//  CXDescViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/25.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXDescViewController.h"

@interface CXDescViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;


@end

@implementation CXDescViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainViewHeight.constant = self.view.mj_h;
    [self initializationView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}
- (void)initializationView {
    UIBarButtonItem * leftIteam = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    NSDictionary *attrsDic1=@{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:16],
                              };
    [leftIteam setTitleTextAttributes:attrsDic1 forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftIteam;
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    _saveButton.exclusiveTouch = YES;
    _saveButton.backgroundColor = [UIColor clearColor];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor colorWithRed:0.875 green:0.184 blue:0.271 alpha:1.000] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor colorWithRed:0.875 green:0.184 blue:0.271 alpha:0.300] forState:UIControlStateDisabled];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    
  
    
    _textView.text = self.text;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1;

}
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)valueChanged:(UITextView *)textField {
    
    if (textField.text.length == 0 || [textField.text isEqualToString:_text]) {
        
        _saveButton.enabled = NO;
    }
    else {
        
        _saveButton.enabled = YES;
    }
}

- (void)saveButton:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(descViewController:saveText:)]) {
        
        [_delegate descViewController:self saveText:_textView.text];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setText:(NSString *)text {
    
    _text = text;
    _textView.text = text;
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
