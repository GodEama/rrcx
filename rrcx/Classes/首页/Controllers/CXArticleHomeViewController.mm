//
//  CXArticleHomeViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXArticleHomeViewController.h"
#import "CXTopBar.h"
#import "CategoryTitleModel.h"
#import "CXHomeArticleListViewController.h"
#import "CategoryAddView.h"
#import "CXChannelManagementViewController.h"
#import "XLChannelControl.h"

#import "MLSearchViewController.h"
#import "CXhotSearchTagModel.h"
@interface CXArticleHomeViewController ()<CategoryAddViewDelegate>
@property (nonatomic,strong) CXTopBar * topBarView;
@property(nonatomic,strong) CategoryAddView *categoryAdd;
@property(nonatomic,strong) NSMutableArray * categoryArray;
@property(nonatomic,strong) NSMutableArray * hotSearchTags;
@property(nonatomic,strong) NSMutableArray * unusedCateArray;

@end

@implementation CXArticleHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.categoryAdd];
    CGFloat contentY = CGRectGetMaxY(self.topBarView.frame);
    self.categoryAdd.frame=CGRectMake(KWidth-40, contentY, 40, 40);
    _categoryArray = [NSMutableArray new];
    
    [self loadRequest];
    [self GetHotSearchTag];
    [self getUnusedCategories];
}
-(NSMutableArray *)hotSearchTags{
    if (!_hotSearchTags) {
        _hotSearchTags = [NSMutableArray new];
        
    }
    return _hotSearchTags;
}

-(NSMutableArray *)unusedCateArray{
    if (!_unusedCateArray) {
        _unusedCateArray = [NSMutableArray new];
    }
    return _unusedCateArray;
}

-(void)loadRequest{
    
    [CXHomeRequest getCategoryTitles:@{@"type":@"2"} responseCache:^(id responseCaches) {
        if ([responseCaches[@"code"] intValue] == 0) {
            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:responseCaches[@"data"]];
            _categoryArray = [NSMutableArray arrayWithArray:titlesArr];
            if (_categoryArray.count) {
                [self setCategoryTitleVCWithArray:titlesArr];
            }
            
            
        }
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:response[@"data"]];
            _categoryArray = [NSMutableArray arrayWithArray:titlesArr];
            if (_categoryArray.count) {
                [self setCategoryTitleVCWithArray:titlesArr];
            }

            
        }
    } failure:^(NSError *error) {
        
    }];
    
    [CXHomeRequest getAliyunToken:@{@"type":@"article_image"} success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
       
}


-(void)setCategoryTitleVCWithArray:(NSArray*)resultModel{
    
    //[self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
   // CGFloat contentY = CGRectGetMaxY(self.topBarView.frame);
    
    // 移除之前所有子控制器
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    // 把对应标题保存到控制器中，并且成为子控制器，才能刷新

    
    
    
    
    for (CategoryTitleModel * category in resultModel) {
        CXHomeArticleListViewController *addVC = [[CXHomeArticleListViewController alloc] init];
        addVC.title = category.title;
        addVC.category = category;
        [self addChildViewController:addVC];
    }
    
    /*  设置标题渐变：标题填充模式 */
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleFont = [UIFont boldSystemFontOfSize:16];
    }];
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        // 标题填充模式
        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
        *norColor = RGB(75, 76, 78);
        *selColor = BasicColor;
    }];
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        //        *isUnderLineDelayScroll = YES;
        *isUnderLineEqualTitleWidth = YES;
        *underLineColor = BasicColor;
    }];
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight -kTabBarHeight);
    }];
    // 注意：必须先确定子控制器
    [self refreshDisplay];
   
    [self.view bringSubviewToFront:self.categoryAdd];
    

}

-(void)GetHotSearchTag{
    [CXHomeRequest getHotSearchTagWithParameters:nil responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[CXhotSearchTagModel class] json:response[@"data"]];
            self.hotSearchTags = [NSMutableArray arrayWithArray:array];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(CXTopBar *)topBarView
{
    if(!_topBarView){
        _topBarView=[CXTopBar new];
        WeakSelf(weakSelf)
        _topBarView.searchClickBlock = ^{
            MLSearchViewController * searchVC = [[MLSearchViewController alloc] init];
            searchVC.tagsArray = weakSelf.hotSearchTags;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
            [weakSelf presentViewController:nav  animated:YES completion:nil];
        };
        
    }
    return _topBarView;
}

-(CategoryAddView *)categoryAdd
{
    if(!_categoryAdd){
        _categoryAdd=[CategoryAddView new];
        _categoryAdd.delegate=self;
    }
    return _categoryAdd;
}



-(void)getUnusedCategories{
    [CXHomeRequest getCategoryTitles:@{@"type":@1,@"other":@1} responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        NSArray *titlesArr=[NSArray yy_modelArrayWithClass:[CategoryTitleModel class] json:response[@"data"]];
        self.unusedCateArray = [NSMutableArray arrayWithArray:titlesArr];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark  添加分类 点击事件

-(void)clickAddCategory
{
    
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:_categoryArray unUseTitles:self.unusedCateArray finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        NSMutableArray * array = [NSMutableArray new];
        for (CategoryTitleModel * cate in inUseTitles) {
            [array addObject:cate.ID];
        }
        NSDictionary * dic = @{@"used":array};
        [CXHomeRequest setHomeCategoriesWithParameters:@{@"type":@0,@"nav":[PPNetworkCache dataWithJSONObject:dic]} success:^(id response) {
            [self loadRequest];
            [self getUnusedCategories];
        } failure:^(NSError *error) {
            
        }];
    }];

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
