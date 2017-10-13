//
//  RRCXHeader.h
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#ifndef RRCXHeader_h
#define RRCXHeader_h

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define navigationBarColor RGB(33, 192, 174)
#define separaterColor RGB(200, 199, 204)

#define BasicColor UIColorFromRGB(0xff8d53)

#define USERKEY [[NSUserDefaults standardUserDefaults] objectForKey:@"user_key"]

// 3.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 4.屏幕大小尺寸
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//数据库地址
#define CXDBPath [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@"CXDB"]
//友盟AppKey
#define UM_APPKEY @"597ee8761061d247aa000348"
//极光推送AppKey
#define JPush_AppKey @"6c7d17488b5c111613473f5f"
//token
#define TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]
//username 手机号
#define USERNAME [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"]
//userid 用户ID
#define User_id [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]

#define User_avatar [[NSUserDefaults standardUserDefaults] objectForKey:@"member_avatar"]
#define User_nick [[NSUserDefaults standardUserDefaults] objectForKey:@"member_nick"]

#define WX_APPID @"wx89bf19150192e852"
#define WX_APP_SECRET @"7a6fbb95f35a1d7bb2acfa081a4f38db"
#define QQ_APPID @"1106432122"
#define QQ_APPKey @"9rc6vbTvra5i2hI1"
#define Sina_APPKey @"1238791805"
#define Sina_APP_SECRET @"93ab0a41d5823a1117567741723412cc"




//当前城市
#define CURRENTCITY [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]
//历史搜索
#define  Search_History    [[NSUserDefaults standardUserDefaults] objectForKey:@"search_his"]
//上次检查版本时间
#define LAST_CHECK_VERSION_TIME [[NSUserDefaults standardUserDefaults] objectForKey:@"checkTime"]

//重新设定view的Y值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)


//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y


#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//5.常用对象
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

//支付宝回调
#define AlipayAppScheme @"com.ddm.jinglcat.alipay"
//是否已经有正在维护页面
#define ISUPDATE [[NSUserDefaults standardUserDefaults] objectForKey:@"isUpdate"]
//6.经纬度
#define LATITUDE_DEFAULT 39.983497
#define LONGITUDE_DEFAULT 116.318042


#define DOCUMENTDIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
//7.
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 服务器地址
#define SERVER_ADDRESS @"http://ceshi.51rrcx.com"
#define user_key [[NSUserDefaults standardUserDefaults] objectForKey:@"USERKEY"]
#define Draft_Article [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"Article.archiver"]


#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

// 按照效果图适应比例 iphone6尺寸
#define AutoWith(x) (x/375.0*[UIScreen mainScreen].bounds.size.width)
#define AutoHeight(x) (x/667.0*[UIScreen mainScreen].bounds.size.height)
#endif
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif



