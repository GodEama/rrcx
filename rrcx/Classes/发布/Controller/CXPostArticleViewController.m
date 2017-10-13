//
//  CXPostArticleViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXPostArticleViewController.h"
#import "YMEditArticleViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import "YMCoverSelectViewController.h"
#import "YMArticleCon.h"
#import "YMArticleConTableViewCell.h"
#import "YMArticleTextTableViewCell.h"
#import "YMArticleVoiceTableViewCell.h"
#import "YMArticleAddTableViewCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "AudioController.h"
#import "YMPlayVoiceManager.h"
#import "CXArticleDetailModel.h"
#import <AliyunOSSiOS/OSSService.h>
@interface CXPostArticleViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,TZImagePickerControllerDelegate,YMPlayVoiceManagerDelegate,AudioControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGRect _menuRect;
    
    BOOL vocieIsOk;
    BOOL contentImgIsOk;
    BOOL coverImagIsOk;
    BOOL _isPosting;
    
}
typedef NS_ENUM(NSInteger,photoType){
    coverPhotoType = 0,
    contentPhotoType = 1
};
@property (nonatomic, assign) NSInteger photoType;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy)   NSString * addr;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIImageView * coverImg;
@property (nonatomic, strong) UITextField * titleTF;
@property (nonatomic, strong) NSMutableArray * coverImgUrls;
@property (nonatomic, strong) NSMutableArray * images;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UITableView * conTable;
@property (nonatomic, assign) NSInteger expandIndex;
@property (nonatomic, assign) NSInteger lastExpandIndex;
@property (nonatomic, assign) NSInteger currentExpandIndex;
@property (nonatomic, assign) NSUInteger waitUploadCoverCount;
@property (nonatomic, assign) NSUInteger waitUploadImageCount;
@property (nonatomic, assign) NSUInteger waitUploadVoiceCount;
@property (nonatomic, assign) NSUInteger clearWaitUploadCoverCount;
@property (nonatomic, assign) NSUInteger clearWaitUploadImageCount;
@property (nonatomic, assign) NSUInteger clearWaitUploadVoiceCount;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) YMArticleVoiceTableViewCell * voiceCell;
@property (nonatomic, strong) NSIndexPath * lastPlayIndexPath;
@property (nonatomic, strong) NSMutableDictionary * contentDic;
@property (nonatomic, strong) CXArticleDetailModel * articleModel;

@end

@implementation CXPostArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布文章";
    [self initlizationdatas];
    [self initlizationViews];
    [self initlizationData];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}
-(void)initlizationdatas{
    _coverImgUrls = [NSMutableArray new];
    _images = [NSMutableArray new];
    _dataArray = [NSMutableArray new];
    
}
-(void)initlizationData{
    _lastExpandIndex = -1;

    _selectedAssets = [NSMutableArray new];
    _selectedPhotos = [NSMutableArray new];
    _contentDic = [NSMutableDictionary dictionaryWithDictionary:@{@"cat_id":@"1",@"title":@"",@"addr":@"",@"images":[NSArray new],@"title":@"",@"voice":@"",@"digest":@"",@"ad_point":@"",@"ad_point_all":@"",@"is_original":@"",@"con_list":@""}];
//    [self getMyAddress];
#pragma mark - 如果是草稿
    if (_loadType == localLoadType) {
        NSMutableData *dataR = [[NSMutableData alloc]initWithContentsOfFile:Draft_Article];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:dataR];
        NSDictionary * dic = [unarchiver decodeObjectForKey:@"privacyArticle"];
        [unarchiver finishDecoding];
        if (dic) {
            [self loadDataFromDic:dic];
        }
        //根据dic更新数据
        
    }
#pragma mark - 如果获取网络数据
    //请求，更新数据
    if (_loadType == netLoadType) {
        //index.php?m=Api&c=Article&a=getArticleInfo&key=令牌&id=文章id
        [CXHomeRequest getMyArticleDataWithParameters:@{@"article_id":self.articleID} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                _articleModel = [CXArticleDetailModel yy_modelWithJSON:response[@"data"]];
                NSDictionary * dic = @{@"cat_id":_articleModel.cat_id,@"title":_articleModel.title,@"addr":_articleModel.addr?:@"",@"images":[NSArray new],@"digest":_articleModel.digest?:@"",@"is_original":_articleModel.is_original?:@"",@"con_list":_articleModel.con_list,@"cover_images":_articleModel.cover_images};
                
                [self loadDataFromDic:dic];

            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

/*
 * 根据字典内容***dic***加载数据
 */
-(void)loadDataFromDic:(NSDictionary *)dic{
    _contentDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([_contentDic[@"title"] isEqualToString:@""]) {
        _titleTF.text = @"请输入标题";
    }
    else{
        _titleTF.text = _contentDic[@"title"];
    
    }
    NSArray * arr = _contentDic[@"con_list"];
    for (NSDictionary * dict in arr) {
        YMArticleCon * con = [YMArticleCon parserWithDictionary:dict];
        [_dataArray addObject:con];
    }
    
    
    [_conTable reloadData];

    _coverImgUrls = [NSMutableArray arrayWithArray:_contentDic[@"cover_images"]];
    //_addr = _contentDic[@"addr"];
    if (_coverImgUrls.count) {
        NSString * coverImgUrl = _coverImgUrls[0];
        if ([coverImgUrl rangeOfString:@"http"].location == NSNotFound) {
            [self.coverImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",coverImgUrl]]]];
            [self uploadOneCoverImageWithFileName:coverImgUrl andIndex:0];
        }
        else{
            [self.coverImg sd_setImageWithURL:[NSURL URLWithString:coverImgUrl] placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];
        }
    }
}
-(void)initlizationViews{
    [self.conTable setTableHeaderView:self.headerView];
    [self.view addSubview:self.conTable];
    UIBarButtonItem * rightIteam = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClick)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [rightIteam setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightIteam;
    
    UIBarButtonItem * leftIteam = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSend)];
    
    NSDictionary *attrsDic1=@{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:16],
                              };
    [leftIteam setTitleTextAttributes:attrsDic1 forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftIteam;
    
}
-(void)cancelSend{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"是否保存草稿？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadAllContent];
        NSString *multiHomePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"Article.archiver"];
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archvier encodeObject:_contentDic forKey:@"privacyArticle"];
        [archvier finishEncoding];
        [data writeToFile:multiHomePath atomically:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)sendButtonClick{
    if ([self judgeIsHaveTitle]) {
        _waitUploadCoverCount = 0;
        _waitUploadImageCount = 0;
        _waitUploadVoiceCount = 0;
        _clearWaitUploadVoiceCount = 0;
        _clearWaitUploadCoverCount = 0;
        _clearWaitUploadImageCount = 0;
        vocieIsOk = NO;
        coverImagIsOk = NO;
        contentImgIsOk = NO;
        _isPosting = YES;
        _hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.label.text = @"正在上传...";
        _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        _hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:_hud];
        
        [_hud showAnimated:YES];
        
        
        [self uploadVoiceArray];
        [self uploadArticleContentImage];
        [self uploadCoverImage];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"%ld",(unsigned long)_dataArray.count);
    return _dataArray.count * 2 + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 40;
    if (indexPath.row %2 == 0) {
        rowHeight = 40;
        if (_currentExpandIndex >= 0) {
            if (indexPath.row == _currentExpandIndex) {
                rowHeight = 60;
            }
            else{
                rowHeight = 40;
            }
        }
    }
    else{
        NSInteger index = indexPath.row/2;
        YMArticleCon * con = _dataArray[index];
        if ([con.type isEqualToString:@"img"]) {
            rowHeight = (KWidth - 48) * 0.65 + 48;
        }
        else if ([con.type isEqualToString:@"voice"]){
            rowHeight = 100;
        }
        else{
            CGFloat cellConLab_W = KWidth - 60;
            
            NSString * string = con.value;
            NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
            rowHeight = [string boundingRectWithSize:CGSizeMake(cellConLab_W, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size.height + 32;
        }
    }
    return rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        
        YMArticleAddTableViewCell * cell = [_conTable dequeueReusableCellWithIdentifier:@"addCell"];
        cell.addBtn.tag = indexPath.row;
        [cell.addBtn addTarget:self action:@selector(expandTypeView:) forControlEvents:UIControlEventTouchUpInside];
        cell.textBtn.tag = indexPath.row;
        cell.imgBtn.tag = indexPath.row;
        [cell.imgBtn addTarget:self action:@selector(addImgCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.textBtn addTarget:self action:@selector(addTextCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.voiceBtn addTarget:self action:@selector(addVoiceCell:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else{
        NSInteger index =indexPath.row/2;
        YMArticleCon * con = _dataArray[index];
        if ([con.type isEqualToString:@"img"]) {
            YMArticleConTableViewCell * cell = [_conTable dequeueReusableCellWithIdentifier:@"imgCell"];
            
            if ([con.value rangeOfString:@"http"].location == NSNotFound) {
                [cell.imgView setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",con.value]]]];
            }
            else{
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:con.value] placeholderImage:[UIImage imageNamed:@"placeholder_blog"]];
            }
            cell.deleteBtn.tag = indexPath.row;
            cell.upBtn.tag = indexPath.row;
            cell.downBtn.tag = indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downBtn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.upBtn.hidden = index == 0 ;
            cell.downBtn.hidden = index == _dataArray.count -1;
            
            return cell;
        }
        else if([con.type isEqualToString:@"voice"]){
            YMArticleVoiceTableViewCell * cell = [_conTable dequeueReusableCellWithIdentifier:@"voiceCell"];
            cell.deleteBtn.tag = indexPath.row;
            cell.upBtn.tag = indexPath.row;
            cell.downBtn.tag = indexPath.row;
            YMArticleCon * con = _dataArray[index];
            cell.voiceNameLabel.text = con.voiceName;
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downBtn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];;
            cell.upBtn.hidden = YES;
            cell.downBtn.hidden = YES;
            cell.playBtn.tag = index;
            cell.voiceSlider.tag = index;
            cell.voiceSlider.value = 0;
            [cell.playBtn setBackgroundImage:[UIImage imageNamed:@"voice_start"] forState:UIControlStateNormal];
            cell.upBtn.hidden = index == 0 ;
            cell.downBtn.hidden = index == _dataArray.count -1;
            [cell.playBtn setBackgroundImage:[UIImage imageNamed:@"voice_start"] forState:UIControlStateNormal];
            [cell.playBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
            [cell.voiceSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
        else{
            YMArticleTextTableViewCell * cell = [_conTable dequeueReusableCellWithIdentifier:@"textCell"];
            cell.conLab.text = con.value;
            cell.deleteBtn.tag = indexPath.row;
            cell.upBtn.tag = indexPath.row;
            cell.downBtn.tag = indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downBtn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.upBtn.hidden = index == 0 ;
            cell.downBtn.hidden = index == _dataArray.count -1;
            
            return cell;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self hideTypeView];
    if (indexPath.row %2 == 1) {
        NSInteger index = indexPath.row/2;
        YMArticleCon * con = _dataArray[index];
        if ([con.type isEqualToString:@"text"]) {
            YMEditArticleViewController * editVC = [[YMEditArticleViewController alloc] init];
            editVC.contentType = ArticleContentType;
            editVC.contentText = con.value;
            
            //__block typeof(self) uvc = self;
            editVC.saveButtonIsDissMiss = ^(NSString *text) {
                YMArticleCon * content = [YMArticleCon parserWithDictionary:@{@"type":@"text",@"value":text}];
                [_dataArray replaceObjectAtIndex:index withObject:content];
                [_conTable reloadData];
                return YES;
            };
            [self.navigationController pushViewController:editVC animated:YES];
        }
        
    }
}
#pragma mark - 展开选择类型的视图
-(void)expandTypeView:(UIButton *)sender{
    if (_lastExpandIndex >=0&&_lastExpandIndex != sender.tag) {
        YMArticleAddTableViewCell * cell = [_conTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastExpandIndex inSection:0]];
        cell.TypeView.hidden = YES;
        cell.addBtn.hidden = NO;
    }
    YMArticleAddTableViewCell * cell = [_conTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.TypeView.hidden = NO;
    cell.addBtn.hidden = YES;
    _lastExpandIndex = sender.tag;
    _currentExpandIndex = sender.tag;
    [_conTable beginUpdates];
    [_conTable endUpdates];
}
-(void)addImgCell:(UIButton *)sender{
    [self hideTypeView];
    [self pushImagePickerController];
    
    
}
-(void)addTextCell:(UIButton *)sender{
    [self hideTypeView];
    YMEditArticleViewController * editVC = [[YMEditArticleViewController alloc] init];
    editVC.contentType = ArticleContentType;
    editVC.contentText = @"";
    //__block typeof(self) uvc = self;
    editVC.saveButtonIsDissMiss = ^(NSString *text) {
        YMArticleCon * con = [YMArticleCon parserWithDictionary:@{@"type":@"text",@"value":text}];
        [_dataArray insertObject:con atIndex:_lastExpandIndex/2];
        [_conTable reloadData];
        return YES;
    };
    [self.navigationController pushViewController:editVC animated:YES];
}
-(void)addVoiceCell:(UIButton *)sender{
    [self hideTypeView];
    AudioController * audioVC = [[AudioController alloc] init];
    audioVC.delegate = self;
    if ([YMPlayVoiceManager sharedInstance].lastUrl.length > 4) {
        [[YMPlayVoiceManager sharedInstance] removeAllNotice];
    }
    [self.navigationController pushViewController:audioVC animated:YES];
}



#pragma mark - 删除cell
-(void)deleteBtnClick:(UIButton *)sender{
    [self hideTypeView];
    NSInteger index = sender.tag/2;
    //YMArticleCon * con = _dataArray[index];
   
    [_dataArray removeObjectAtIndex:index];
    [_conTable beginUpdates];
    [_conTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0],[NSIndexPath indexPathForRow:sender.tag + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_conTable endUpdates];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_conTable reloadData];
    });
    
}
-(void)upBtnClick:(UIButton *)sender{
    if (sender.tag/2 > 0) {
        sender.userInteractionEnabled = NO;
        [_dataArray exchangeObjectAtIndex:sender.tag/2 withObjectAtIndex:sender.tag/2 -1];
        [_conTable beginUpdates];
        [_conTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag-2 inSection:0]];
        [_conTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag -2 inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        
        [_conTable endUpdates];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_conTable reloadData];
            sender.userInteractionEnabled = YES;
        });
    }
}
-(void)downBtnClick:(UIButton *)sender{
    if (sender.tag/2 < _dataArray.count -1) {
        sender.userInteractionEnabled = NO;
        [_dataArray exchangeObjectAtIndex:sender.tag/2 withObjectAtIndex:sender.tag/2 + 1];
        [_conTable beginUpdates];
        
        [_conTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag + 2 inSection:0]];
        [_conTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag  + 2 inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [_conTable endUpdates];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_conTable reloadData];
            sender.userInteractionEnabled = YES;
        });
    }
    
}
-(void)hideTypeView{
    if (_lastExpandIndex >=0) {
        YMArticleAddTableViewCell * cell = [_conTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastExpandIndex inSection:0]];
        cell.TypeView.hidden = YES;
        cell.addBtn.hidden = NO;
        
        [_conTable beginUpdates];
        _currentExpandIndex = -1;
        [_conTable endUpdates];
        
    }
}
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开编辑
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //允许移动
    return YES;
    //return NO;
}

-(UITableView *)conTable{
    if (!_conTable) {
        _conTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStyleGrouped];
        _conTable.delegate = self;
        _conTable.dataSource = self;
        [_conTable registerNib:[UINib nibWithNibName:@"YMArticleConTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"imgCell"];
        [_conTable registerNib:[UINib nibWithNibName:@"YMArticleTextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"textCell"];
        [_conTable registerNib:[UINib nibWithNibName:@"YMArticleVoiceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"voiceCell"];
        [_conTable registerNib:[UINib nibWithNibName:@"YMArticleAddTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"addCell"];
        [_conTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _conTable.estimatedRowHeight = 0;
        _conTable.estimatedSectionHeaderHeight = 0;
        _conTable.estimatedSectionFooterHeight = 0;
        
    }
    return _conTable;
}

#pragma mark - headerView
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 200)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.coverImg];
        _titleTF = [[UITextField alloc] init];
        [_headerView addSubview:_titleTF];
        _titleTF.placeholder = @"请输入标题";
        [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left).with.offset = 15;
            make.right.equalTo(_headerView.mas_right).with.offset = 15;
            make.top.equalTo(_headerView.mas_top).with.offset = 0;
            make.height.equalTo(@40);
        }];
        [_coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left).with.offset = 0;
            make.right.equalTo(_headerView.mas_right).with.offset = 0;
            make.top.equalTo(_headerView.mas_top).with.offset = 40;
            make.bottom.equalTo(_headerView.mas_bottom).with.offset = 0;
        }];
        self.coverImg.backgroundColor = [UIColor lightGrayColor];
        self.coverImg.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImg.clipsToBounds = YES;
        
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView.mas_right).with.offset = -10;
           
            make.bottom.equalTo(_headerView.mas_bottom).with.offset = -5;
            make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
        [button setTitle:@"编辑封面" forState:UIControlStateNormal];
        [button setTitleColor:RGB(58, 59, 60) forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(setArticleCoverImg) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    return _headerView;
}
#pragma mark - AudioControllerDelegate
-(void)audioController:(AudioController *)AudioController savePath:(NSString *)savePath andFileName:(NSString *)fileName{
    if (savePath&&fileName) {
#warning 上传语音
        [self uploadAudioWithSavePath:savePath andFileName:fileName];
        
    }
    
    
    
}
#pragma mark - 上传语音
-(void)uploadAudioWithSavePath:(NSString *)savePath andFileName:(NSString *)fileName{
    //index.php?m=Api&c=Article&a=voiceUploadByForm&key=令牌&type=文件扩展名
    NSData *data = [NSData dataWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:savePath]];
    [CXHomeRequest getAliyunToken:@{@"type":@"article_voice",@"num_files":@(1)} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [OSSLog enableLog];
            NSString * endPoint = response[@"data"][@"endpoint"];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 3;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
            [self uploadVoiceAsyncWithData:data andResponse:response andClient:client andSavePath:savePath andFileName:fileName];
        }
        
    } failure:^(NSError *error) {
        NSString * voiceUrl  = savePath;
        NSDictionary * dic = @{@"type":@"voice",@"value":voiceUrl,@"voiceName":fileName};
        YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
        
        [_dataArray insertObject:con atIndex:_lastExpandIndex/2];
        [_conTable reloadData];
    }];

    
}
// 异步上传
- (void)uploadVoiceAsyncWithData:(NSData *)uploadData andResponse:(NSDictionary *)response andClient:(OSSClient*)client andSavePath:(NSString *)savePath andFileName:(NSString *)fileName{
    
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = response[@"data"][@"bucket"];
    //objectKey为文件名 一般自己拼接
    request.objectKey = [NSString stringWithFormat:@"%@%@.mp3",response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
    
    //    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    request.uploadingData = uploadData;
    
    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //每次上传完一个文件都要回调
            NSString * voiceUrl  = savePath;
            voiceUrl = [NSString stringWithFormat:@"%@/%@%@.mp3",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
            
            NSDictionary * dic = @{@"type":@"voice",@"value":voiceUrl,@"voiceName":fileName};
            YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
            [_dataArray insertObject:con atIndex:_lastExpandIndex/2];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_conTable reloadData];
            });
            
        } else {
            
            //每上传失败一个文件后都要回调
            NSLog(@"upload object failed, error: %@" , task.error);
            //在即使上传失败后如果不作处理，那么上传时当调度组里面的方法执行了，不管方法执行成功还是失败，最后调度组执行完之后还是要回调，由于回调里只写了成功弹框，所以这里需要加上通知处理上传失败的结果
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            NSString * voiceUrl  = savePath;
            NSDictionary * dic = @{@"type":@"voice",@"voice":voiceUrl,@"voiceName":fileName};
            YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
            
            [_dataArray insertObject:con atIndex:_lastExpandIndex/2];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_conTable reloadData];
            });
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];

            }
            
        }
        return nil;
    }];
    
    //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
//    [putTask waitUntilFinished];
    
    //上传进度
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}
#pragma mark - 播放、暂停语音
- (void)playVoice:(UIButton *)sender{
//    [YMPlayVoiceManager sharedInstance].delegate = self;
//    NSString * voiceUrl;
//    if (_savePath) {
//        NSString * voicePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:_savePath];
//        NSURL * url = [NSURL fileURLWithPath:voicePath];
//        voiceUrl = url.absoluteString;
//        
//    }
//    else{
//        voiceUrl = _voiceUrl;
//        
//    }
//    //    if ([[YMPlayVoiceManager sharedInstance].lastUrl isEqualToString:voiceUrl]) {
//    //
//    //    }
//    
//    [[YMPlayVoiceManager sharedInstance] playWithArray:@[voiceUrl] andIndexPath:0];
//    if (!_isPlay) {
//        [[YMPlayVoiceManager sharedInstance] startPlay];
//        [sender setBackgroundImage:[UIImage imageNamed:@"voice_stop"] forState:UIControlStateNormal];
//        _isPlay = YES;
//    }
//    else
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"voice_start"] forState:UIControlStateNormal];
//        [[YMPlayVoiceManager sharedInstance] puasePlay];
//        _isPlay = NO;
//    }
    
}

-(void)changeProgress:(UISlider *)slider{
//    [YMPlayVoiceManager sharedInstance].delegate = self;
//    
//    NSString * playUrl;
//    if (_savePath) {
//        NSString * voicePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:_savePath];
//        NSURL * url = [NSURL fileURLWithPath:voicePath];
//        playUrl = url.absoluteString;
//        
//    }
//    else{
//        playUrl = _voiceUrl;
//    }
//    
//    AVPlayer * player = [YMPlayVoiceManager sharedInstance].player ;
//    
//    if ([[YMPlayVoiceManager sharedInstance].lastUrl isEqualToString:playUrl]) {
//        if(player.status == AVPlayerStatusReadyToPlay){
//            NSTimeInterval total = CMTimeGetSeconds(player.currentItem.duration);
//            NSTimeInterval toTime = total * slider.value;
//            [[YMPlayVoiceManager sharedInstance].player seekToTime:CMTimeMake(toTime, 1) toleranceBefore:CMTimeMake(0.1, 1) toleranceAfter:CMTimeMake(0.1, 1) completionHandler:^(BOOL finished) {
//                
//            }];
//        }
//        
//    }
    
    
    
}

-(void)getSongCurrentTime:(NSString *)currentTime andTotalTime:(NSString *)totalTime andProgress:(CGFloat)progress andTapCount:(NSInteger)tapCount{
//    _voiceCell.voiceSlider.value = progress;
//    DLog(@"播放进度：%f",progress);
//    if (progress>=0.999) {
//        [[YMPlayVoiceManager sharedInstance] puasePlay];
//        [_voiceCell.playBtn setBackgroundImage:[UIImage imageNamed:@"voice_start"] forState:UIControlStateNormal];
//        _voiceCell.voiceSlider.value = 0;
//        _isPlay = NO;
//    }
}
#pragma mark - 远程控制事件监听
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
//    if (_voiceCell) {
//        switch (event.subtype) {
//            case UIEventSubtypeRemoteControlPause:
//                [[YMPlayVoiceManager sharedInstance] puasePlay];
//                [_voiceCell.playBtn setBackgroundImage:[UIImage imageNamed:@"voice_start"] forState:UIControlStateNormal];
//                _isPlay = NO;
//                break;
//            case UIEventSubtypeRemoteControlPlay: //播放
//                [[YMPlayVoiceManager sharedInstance] startPlay];
//                [_voiceCell.playBtn setBackgroundImage:[UIImage imageNamed:@"voice_stop"] forState:UIControlStateNormal];
//                _isPlay = YES;
//                break;
//            default:
//                break;
//        }
//    }
    
}
#pragma mark - 更换封面
-(void)setArticleCoverImg{
    YMCoverSelectViewController * coverVC = [[YMCoverSelectViewController alloc] init];
    //    coverVC.conArray = self.dataArray;
    coverVC.coverImageUrls = self.coverImgUrls;
    coverVC.saveButtonIsDissMiss = ^(NSArray*selectPhotoUrls){
        _coverImgUrls = [NSMutableArray arrayWithArray:selectPhotoUrls];
        if (selectPhotoUrls.count) {
            self.coverImgUrls = [NSMutableArray arrayWithArray:selectPhotoUrls];
            NSString * url = selectPhotoUrls[0];
            if ([url rangeOfString:@"http"].location == NSNotFound) {
                [self.coverImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",url]]]];
                
            }else{
                [self.coverImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];
            }
            
        }
        else{
            [_coverImg setImage:nil];
        }
        return YES;
    };
    [self.navigationController pushViewController:coverVC animated:YES];
}



#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    //    if (self.selecteMaxCount > 1) {
    //        // 1.设置目前已经选中的图片数组
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
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
    imagePickerVc.circleCropRadius = 100;
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
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    //[self savePhotos:photos];
    
    
}


// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
}
#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (int i =0;i<assets.count;i++) {
        id asset = assets[i];
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        //        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        //        CGImageRef imgRef = [assetRep fullResolutionImage];
        //        UIImage * image = [UIImage imageWithCGImage:imgRef
        //                                                  scale:assetRep.scale
        //                                            orientation:(UIImageOrientation)assetRep.orientation];
        //[self savePhotosWith:fileName andImage:image];
        [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (!isDegraded) {
                //                [self uploadImage:photo andFileName:fileName];
                [self savePhotosWith:fileName andImage:photo andIndex:_lastExpandIndex/2 + i];
            }
            //            [self savePhotosWith:fileName andImage:photo];
        }];
    }
}

#pragma mark - 保存选择的图片
-(void)savePhotosWith:(NSString*)imageName andImage:(UIImage *)image andIndex:(NSInteger)index{
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
    
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:imageFilePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        
        [fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * imagePath = [imageFilePath stringByAppendingPathComponent:imageName];
    DLog(@"保存路径：%@",imagePath);
    if ([fileManager fileExistsAtPath:imagePath]) {
        NSDictionary * dic = @{@"type":@"img",@"value":imageName};
        YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
        [self.dataArray insertObject:con atIndex:_lastExpandIndex/2];
        
        [self.conTable reloadData];
        [self uploadOneImageWithFileName:imageName andIndex:_lastExpandIndex/2];
        
    }
    else{
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imagePath atomically:YES];
        if (success) {
            NSDictionary * dic = @{@"type":@"img",@"value":imageName};
            YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
            DLog(@">>>>>>>>>>>%@",con.value);
            [self.dataArray insertObject:con atIndex:_lastExpandIndex/2];
            [self.conTable reloadData];
            [self uploadOneImageWithFileName:imageName andIndex:_lastExpandIndex/2];
        }
        else{
            DLog(@"保存失败");
        }
    }
    
    
}

#pragma mark - 单张上传图片根据Image路径
-(void)uploadOneImageWithFileName:(NSString *)fileName andIndex:(NSInteger)index{
    NSString * imagePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",fileName]];
    //NSString * ex = [imagePath pathExtension];
    UIImage * imag = [UIImage imageWithContentsOfFile:imagePath];
    NSString * ext = [[fileName componentsSeparatedByString:@"."] lastObject];

    NSData * data = [self resetSizeOfImageData:imag maxSize:500];
    if (data.length) {
        [CXHomeRequest getAliyunToken:@{@"type":@"article_image",@"num_files":@(1)} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [OSSLog enableLog];
                NSString * endPoint = response[@"data"][@"endpoint"];
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3;
                conf.timeoutIntervalForRequest = 30;
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
                [self uploadImageAsyncWithData:data andResponse:response andClient:client andIndex:index andImageType:@"article_image" andExt:ext];
            }
            
        } failure:^(NSError *error) {
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];
                
            }
        }];
    }
    
}
// 异步上传
- (void)uploadImageAsyncWithData:(NSData *)uploadData andResponse:(NSDictionary *)response andClient:(OSSClient*)client andIndex:(NSInteger)index andImageType:(NSString*)imageType andExt:(NSString *)ext{
    
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = response[@"data"][@"bucket"];

    //objectKey为文件名 一般自己拼接
    request.objectKey = [NSString stringWithFormat:@"%@%@.png",response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
    
    //    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    request.uploadingData = uploadData;
    
    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            NSString * imageUrl = @"";
            imageUrl = [NSString stringWithFormat:@"%@/%@%@.png",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
            if ([imageType isEqualToString:@"article_image"]) {
                NSDictionary * dic = @{@"type":@"img",@"value":imageUrl};
                YMArticleCon * con = [YMArticleCon parserWithDictionary:dic];
                [_dataArray replaceObjectAtIndex:index withObject:con];
                _clearWaitUploadImageCount ++;
                if (_clearWaitUploadImageCount >= _waitUploadImageCount) {
                    contentImgIsOk = YES;
                    [self judgeAllContentIsReady];
                }
            }
            else if ([imageType isEqualToString:@"coverImage"]){
                _clearWaitUploadCoverCount ++;
                [_coverImgUrls replaceObjectAtIndex:index withObject:imageUrl];
                if (_clearWaitUploadCoverCount >= _waitUploadCoverCount) {
                    coverImagIsOk = YES;
                    [self judgeAllContentIsReady];
                }
            }
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_conTable reloadData];
//            });
            
        }
        else
        {
            
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];
                
            }
            
        }
        return nil;
    }];
    
    //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
    [putTask waitUntilFinished];
    
    //上传进度
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}







-(NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 640;
    CGFloat tempWidth = newSize.width / 640;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

#pragma mark - 获取当前位置
-(void)getMyAddress{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [AMapServices sharedServices].apiKey = CXAMapKey;
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [Message showMessageWithConfirm:YES title:@"获取定位失败"];
                return;
            }
        }
        
        //NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            self.addr = [NSString stringWithFormat:@"%@,%@,%@,%@",regeocode.province,regeocode.city,regeocode.district,regeocode.street];
        }
        else
        {
            
        }
    }];
}
#pragma mark - 单张上传封面图片根据Image路径
-(void)uploadOneCoverImageWithFileName:(NSString *)fileName andIndex:(NSInteger)index{
    NSString * imagePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",fileName]];
    //NSString * ex = [imagePath pathExtension];
    UIImage * imag = [UIImage imageWithContentsOfFile:imagePath];
    NSData * data = [self resetSizeOfImageData:imag maxSize:500];
    NSString * ext = [[fileName componentsSeparatedByString:@"."] lastObject];

    if (data.length) {
        [CXHomeRequest getAliyunToken:@{@"type":@"article_image",@"num_files":@(1)} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [OSSLog enableLog];
                NSString * endPoint = response[@"data"][@"endpoint"];
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3;
                conf.timeoutIntervalForRequest = 30;
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
                [self uploadImageAsyncWithData:data andResponse:response andClient:client andIndex:index andImageType:@"coverImage" andExt:ext];
            }
            
        } failure:^(NSError *error) {
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];
                
            }
        }];
    }
    

}
-(BOOL)judgeIsHaveTitle{
    if (!_titleTF.text) {
        [Message showMiddleHint:@"未设置标题"];
        return NO ;
    }
    else if (_titleTF.text.length == 0 ){
        [Message showMiddleHint:@"未设置标题"];
        return NO;
    }
    else{
        return YES;
    }
    
}

#pragma mark - 上传未获得网络路径的图片
-(void)uploadArticleContentImage{
    BOOL contentImgOK = YES;
    if (_dataArray.count) {
        for (int i = 0; i<_dataArray.count; i++) {
            YMArticleCon * con = _dataArray[i];
            if ([con.type isEqualToString:@"img"]) {
                if ([con.value rangeOfString:@"http"].location== NSNotFound) {
                    _waitUploadImageCount ++;
                    [self uploadOneImageWithFileName:con.value andIndex:i];
                    contentImgOK = NO;
                }
            }
        }
    }
    contentImgIsOk = contentImgOK;
    if (contentImgIsOk) {
        [self judgeAllContentIsReady];
    }
    
}
#pragma mark - 上传未获得网络路径的封面图片
-(void)uploadCoverImage{
    BOOL coverImgOK = YES;
    if (_coverImgUrls.count) {
        for (int i= 0; i<_coverImgUrls.count; i++) {
            NSString * coverImageUrl = _coverImgUrls[i];
            if ([coverImageUrl rangeOfString:@"http"].location == NSNotFound) {
                _waitUploadCoverCount ++;
                [self uploadOneCoverImageWithFileName:coverImageUrl andIndex:i];
                coverImgOK = NO;
            }
        }
    }
    coverImagIsOk = coverImgOK;
    if (coverImagIsOk) {
        [self judgeAllContentIsReady];
    }
  
}
#pragma mark - 上传未获得网络路径的语音
-(void)uploadVoiceArray{
    BOOL contentImgOK = YES;
    if (_dataArray.count) {
        for (int i = 0; i<_dataArray.count; i++) {
            YMArticleCon * con = _dataArray[i];
            if ([con.type isEqualToString:@"voice"]) {
                if ([con.value rangeOfString:@"http"].location== NSNotFound) {
                    _waitUploadVoiceCount ++;
                    [self uploadAudioWithSavePath:con.value andFileName:con.voiceName];
                    contentImgOK = NO;
                }
            }
        }
    }
    vocieIsOk = contentImgOK;
    if (vocieIsOk) {
        [self judgeAllContentIsReady];
    }
    
}

#pragma mark -  如果语音、封面、文章图片都上传完毕
-(void)judgeAllContentIsReady{
    if (vocieIsOk&&coverImagIsOk&&contentImgIsOk) {
        [self uploadMyArticle];
    }
}

-(void)uploadMyArticle{
    [self loadAllContent];
    //index.php?m=Api&c=Article&a=save&key=令牌
    NSString * conStr = [PPNetworkCache dataWithJSONObject:_contentDic];

    NSString * postUrl;
    NSDictionary * dic;
    switch (_loadType) {
        case localLoadType:
            postUrl = CXPostArticle;
            dic = @{@"data":conStr,@"type":@0};
            break;
        case netLoadType:
            postUrl = CXFixArticle;
            dic = @{@"data":conStr,@"type":@0,@"article_id":self.articleID};
            break;
            
        default:
            postUrl = CXPostArticle;
            dic = @{@"data":conStr,@"type":@0};
            break;
    }
    [CXHomeRequest postArticleWithUrl:postUrl andParameters:dic success:^(id response) {
        [_hud hideAnimated:YES];
        if ([response[@"code"] intValue] == 0) {
            [Message showMiddleHint:@"上传成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                if (self.loadType == localLoadType) {
                    _contentDic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"",@"addr":@"",@"cover_images":[NSArray new],@"digest":@"",@"con_list":[NSArray new]}];
                    NSMutableData *data = [[NSMutableData alloc]init];
                    NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archvier encodeObject:_contentDic forKey:@"privacyArticle"];
                    [archvier finishEncoding];
                    [data writeToFile:Draft_Article atomically:YES];
                }
                NSString * imagePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"MyImage"];
                [PPNetworkCache clearCacheWithFilePath:imagePath];
            }];
            
        }
        else{
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                
            }
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)loadAllContent{
    /*
     
  
     addr 地址
     title 标题
     cover_images 封面图片【数组['图片地址1','图片地址2','图片地址3']】【封面图片宽高比例为1:0.65】
     voice 音频
     digest 摘要
     con_list 文章主体 [{type:'text',text:'文本信息'},{type:'img',img:'图片地址'}]
   
     */
    
    NSMutableDictionary * conDic = [[NSMutableDictionary alloc] init];
    
    [conDic setObject:_titleTF.text forKey:@"title"];
    
    [conDic setObject:_coverImgUrls?_coverImgUrls:[NSArray new] forKey:@"cover_images"];
    
    [conDic setObject:_titleTF.text forKey:@"digest"];
    [conDic setObject:_addr?:@"" forKey:@"addr"];
    NSMutableArray * conArr = [NSMutableArray new];
    // BOOL isHaveVoice = [self judgeIsHaveVoice];
    for (YMArticleCon * con in _dataArray) {
        NSDictionary * dic = @{@"type":con.type,@"value":con.value};
        [conArr addObject:dic];
    }
    [conDic setObject:conArr forKey:@"con_list"];
    _contentDic = conDic;
//    NSString * conStr = [PPNetworkCache dataWithJSONObject:conArr];
//    [_contentDic setObject:conStr forKey:@"con_list"];
}


-(UIImageView *)coverImg{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc] init];
    }
    return _coverImg;
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
