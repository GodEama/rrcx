//
//  CXMainTableViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMainTableViewController.h"
#import "MainNavigationController.h"
#import "MainTabBar.h"
#import "CXHomeArticleListViewController.h"
#import "CXArticleHomeViewController.h"
#import "CXMineViewController.h"
#import "CXPostArticleViewController.h"
#import "CXLoginViewController.h"
#import "HyPopMenuView.h"
#import "CXPostImagesViewController.h"
#import "CXPostVideoViewController.h"
#import "CXPostIdeaViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
@interface CXMainTableViewController ()<MainTabBarDelegate,HyPopMenuViewDelegate,TZImagePickerControllerDelegate>
@property(nonatomic, weak)MainTabBar *mainTabBar;
@property(nonatomic, strong)CXArticleHomeViewController *homeVc;
@property(nonatomic, strong)CXMineViewController *MineVC;

@property (nonatomic, strong) HyPopMenuView* menu;
@end

@implementation CXMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetupMainTabBar];
    [self SetupAllControllers];
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [PopMenuModel
                           allocPopMenuModelWithImageNameString:@"tabbar_compose_idea"
                           AtTitleString:@"文章"
                           AtTextColor:[UIColor grayColor]
                           AtTransitionType:PopMenuTransitionTypeCustomizeApi
                           AtTransitionRenderingColor:nil];
    
    PopMenuModel* model1 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_photo"
                            AtTitleString:@"图集"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model2 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_camera"
                            AtTitleString:@"视频"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model3 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_lbs"
                            AtTitleString:@"动态"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    
    _menu.dataSource = @[ model, model1, model2, model3];
    _menu.delegate = self;
    _menu.popMenuSpeed = 12.0f;
    _menu.automaticIdentificationColor = false;
    _menu.animationType = HyPopMenuViewAnimationTypeViscous;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)SetupMainTabBar{
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{
    NSArray *titles = @[@"首页", @"我的"];
    NSArray *images = @[@"home", @"personal"];
    NSArray *selectedImages = @[@"home-c", @"personal-c"];
    
    CXArticleHomeViewController * homeVc = [[CXArticleHomeViewController alloc] init];
    self.homeVc = homeVc;
    
    CXMineViewController * meVC = [[CXMineViewController alloc] init];
    self.MineVC = meVC;
    
    
    
    NSArray *viewControllers = @[homeVc, meVC];
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *childVc = viewControllers[i];
        [self SetupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;

    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}


- (void)popMenuView:(HyPopMenuView*)popMenuView
didSelectItemAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            CXPostArticleViewController * postVC = [[CXPostArticleViewController alloc] init];
            postVC.loadType = localLoadType;
            MainNavigationController * nav = [[MainNavigationController alloc] initWithRootViewController:postVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            
            break;
        case 1:
        {
//            CXPostImagesViewController * postVC = [[CXPostImagesViewController alloc] init];
//            MainNavigationController * nav = [[MainNavigationController alloc] initWithRootViewController:postVC];
//            [self presentViewController:nav animated:YES completion:nil];
            [self pushImagePickerControllerWithType:1];
        }
            
            
            break;
        case 2:
        {
            [self pushImagePickerControllerWithType:2];
        }
            
            
            break;
        case 3:
        {
            CXPostIdeaViewController * postVC = [[CXPostIdeaViewController alloc] init];
            MainNavigationController * nav = [[MainNavigationController alloc] initWithRootViewController:postVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            
            break;
            
        default:
            break;
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerControllerWithType:(NSInteger)type {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    //    if (self.selecteMaxCount > 1) {
    //        // 1.设置目前已经选中的图片数组
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
   
    if (type == 2) {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = NO;
        imagePickerVc.needCircleCrop = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.isSelectOriginalPhoto = YES;

    }
    else if(type == 1){
        imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = NO;
        imagePickerVc.needCircleCrop = NO;
    }
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    CXPostImagesViewController * postVC = [[CXPostImagesViewController alloc] init];
    postVC.firstAsset = assets;
    MainNavigationController * nav = [[MainNavigationController alloc] initWithRootViewController:postVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    CXPostVideoViewController * postVC = [[CXPostVideoViewController alloc] init];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        DLog(@"sdasda%ld  ",phAsset.sourceType);
        postVC.asset = phAsset;
    }

    MainNavigationController * nav = [[MainNavigationController alloc] initWithRootViewController:postVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}




#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
}

- (void)tabBarClickWriteButton:(MainTabBar *)tabBar{
    if (!TOKEN) {
        CXLoginViewController *writeVc = [[CXLoginViewController alloc] init];
        MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        _menu.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
        [_menu openMenu];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
