//
//  YMReportViewController.m
//  YunMuFocus
//
//  Created by apple on 2017/5/5.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMReportViewController.h"

@interface YMReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString * placeHolder;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@end

@implementation YMReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title  = @"举报";
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:[UIColor blackColor],
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [leftBar setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    

    
    self.placeHolder = @"请填写您举报的原因";
    _reportBtn.layer.masksToBounds = YES;
    _reportBtn.layer.cornerRadius = 6;
    [_textView setValue:@(150) forKey:@"limit"];
}

- (IBAction)reportClick:(id)sender {
    //index.php?m=Api&c=Index&a=report&key=令牌
    /*
     post内容
     type_id 具备内容类型1用户2文章
     item_id 文章或者用户id
     con 举报内容 最长150字
     */
    if (_textView.text.length == 0) {
        [Message showMiddleHint:@"请填写举报原因"];
    }
    else{
        
        [CXHomeRequest reportArticleWithParameters:@{@"type":@(self.reportType),@"id":self.articleId,@"content":_textView.text} success:^(id response) {
            if ([response[@"code"] integerValue] == 0) {
                [Message showMiddleHint:@"已举报"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Message showMiddleHint:response[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}


-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =  NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
