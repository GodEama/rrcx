//
//  YMEditArticleViewController.m
//  YunMuFocus
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMEditArticleViewController.h"

@interface YMEditArticleViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, copy) NSString * placeHolder;

@end

@implementation YMEditArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizationView];
    [self initlizationData];
}
-(void)initlizationView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title =_contentType == titleType?@"设置标题": @"编辑文字";
    [self.view addSubview:self.textView];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveContent)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [rightItem setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    if (_contentType == titleType) {
        [self.textView setValue:@(40) forKey:@"limit"];
        self.placeHolder = @"标题最多不超过40个字";
        
    }
    _textView.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    [leftItem setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)cancelEdit{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认放弃编辑？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self pop];
    }
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveContent{
    [self.view endEditing:YES];
    [_textView endEditing:YES];
    if (_saveButtonIsDissMiss) {
        
        BOOL isDismiss = _saveButtonIsDissMiss(_textView.text);
        
        if (isDismiss) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)initlizationData{
    _textView.text = self.contentText;
    [_textView becomeFirstResponder];
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, KWidth - 16, KHeight - 8)];
    }
    return _textView;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeHolder;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    
    // same font
    _textView.font = [UIFont systemFontOfSize:13.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
    
    [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
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
