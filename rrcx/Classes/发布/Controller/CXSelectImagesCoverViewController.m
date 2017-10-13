//
//  CXSelectImagesCoverViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/20.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXSelectImagesCoverViewController.h"
#import "CXImageItem.h"
#import "YMArticleConCollectionViewCell.h"
@interface CXSelectImagesCoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
    NSIndexPath* _lastIndex;
}
@property (nonatomic, strong) UICollectionView * photoCollectView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * selectPhotoUrls;

@end

@implementation CXSelectImagesCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initlizationView];
    [self initlizationData];
}
-(void)initlizationView{
    self.title = @"设置封面";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveCoverImges)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [right1 setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = right1;
    [self.view addSubview:self.photoCollectView];
    
    
}

-(void)saveCoverImges{
    
    if (_saveButtonIsDissMiss) {
        
        BOOL isDismiss = _saveButtonIsDissMiss(_currentCoverImageUrl);
        
        if (isDismiss) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}




-(void)initlizationData{
    _dataArray = [NSMutableArray new];
    _selectPhotoUrls = [NSMutableArray arrayWithObject:self.currentCoverImageUrl];
    _selectedAssets = [NSMutableArray new];
    _selectedPhotos = [NSMutableArray new];
    [self GetSourceData];
    
}
-(void)GetSourceData{
    
    _dataArray = [NSMutableArray arrayWithArray:_conArray];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YMArticleConCollectionViewCell * cell = [_photoCollectView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    CXImageItem * con = _dataArray[indexPath.row];
    
    if ([con.imagePath rangeOfString:@"http"].location != NSNotFound) {
        [cell.conImg sd_setImageWithURL:[NSURL URLWithString:con.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_blog"]];
    }else{
        [cell.conImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",con.imagePath]]]];
    }
    if ([self.currentCoverImageUrl isEqualToString:con.imagePath]) {
        _lastIndex = indexPath;
        cell.isSelected = YES;
    }
    else{
        cell.isSelected = NO;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_lastIndex.row != indexPath.row) {
        
        YMArticleConCollectionViewCell * cell = (YMArticleConCollectionViewCell*)[_photoCollectView cellForItemAtIndexPath:indexPath];
        cell.isSelected = YES;
        
        YMArticleConCollectionViewCell * lastCell = (YMArticleConCollectionViewCell*)[_photoCollectView cellForItemAtIndexPath:_lastIndex];
        lastCell.isSelected = NO;
        CXImageItem * model = _dataArray[indexPath.row];
        _currentCoverImageUrl = model.imagePath;
        _lastIndex = indexPath;
        
    }
    

    
   
    
    
}

-(UICollectionView *)photoCollectView{
    if (!_photoCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (KWidth - 2 * _margin - 4) / 3 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _photoCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _photoCollectView.alwaysBounceVertical = YES;
        _photoCollectView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _photoCollectView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _photoCollectView.dataSource = self;
        _photoCollectView.delegate = self;
        _photoCollectView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_photoCollectView registerNib:[UINib nibWithNibName:@"YMArticleConCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"photoCell"];
    }
    return _photoCollectView;
}

- (NSString*)getImagePath:(NSString *)name {
    
    
    NSString *docPath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"MyImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *finalPath = [docPath stringByAppendingPathComponent:name];
    
    
    
    // Remove the filename and create the remaining path
    
    [fileManager createDirectoryAtPath:[finalPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];//stringByDeletingLastPathComponent是关键
    
    
    
    return finalPath;
    
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
