//
//  JCWebViewController.m
//  JingleCat
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 Henan jingle cats electronic commerce co., LTD. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCWebProgressLayer.h"
@interface JCWebViewController ()<UIWebViewDelegate>
{
    JCWebProgressLayer *_progressLayer; ///< 网页加载进度条
    
}
@end

@implementation JCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView * web = [[UIWebView alloc] init];
    [self.view addSubview:web];
    web.delegate = self;
    web.frame = self.view.bounds;
    if (!_url) {
        _url = @"http://www.ddmzl.com/m/html/system.html";
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [JCWebProgressLayer layerWithFrame:CGRectMake(0, 64, KWidth, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
