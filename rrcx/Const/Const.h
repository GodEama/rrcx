//
//  Const.h
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject
//************************** 接口URL ******************************//
extern NSString * CXHostURL;                   // 主地址
extern NSString *const CXVersion_Code;              // 接口版本
extern NSString *const CXVid;
extern NSString *const CXDriveID;
extern NSString *const CXOpenudid;
extern NSString *const CXIdfv;
extern NSString *const CXIid;

extern NSString *const CXAliyunToken;



extern NSString *const CXCategoryTitlesURL;              // 获取导航分类
extern NSString *const CXCategoryExtra;                 //获取导航标题 扩展
extern NSString *const CXCategoryRecommend;             //获得推荐的关注列表
extern NSString *const CXSearchSuggest;                 //搜索建议
extern NSString *const CXFocusonUser;                   //关注某人
extern NSString *const CXUnFocusonUser;                 //取消关注某人
extern NSString *const CXGetFeedNews;                   //取feed数据
extern NSString *const CXZangWeibo;                     //点赞某条微博
extern NSString *const CXGetWeiboContent;               //获取微博内容的正文数据

extern NSString *const CXCategoryTitleModelMe;
extern NSString *const CXCategoryTitleModelOther;

extern NSString * const CXHomeBanner;                   //首页banner
extern NSString * const CXArticleList;                  //文章列表
extern NSString * const CXNewsList;                     //动态列表
extern NSString * const CXArticleDetail;                //文章／动态详情
extern NSString * const CXZanContent;                   //点赞


extern NSString *const CXSendSmsCaptche;//获取短信验证码
extern NSString *const CXGetImageCaptche;//获取图形验证码
extern NSString *const CXUploadImage;//上传图片
extern NSString *const CXGetHangyeList;//获取行业列表
extern NSString *const CXGetAreaList;//获取地区列表
extern NSString *const CXRegistWithPhone;//手机号注册
extern NSString *const CXEditProfile;//填写必要个人信息
extern NSString *const CXLoginURL;//登录
extern NSString *const CXCheckPhone;//检查手机号
extern NSString *const CXFindPassword;//、重置密码
extern NSString *const CXSelfInfo;//



extern NSString *const CXCommentReplayList;
extern NSString *const CXCommentList;
extern NSString *const CXReplayComment;
extern NSString *const CXZanComment;

extern NSString *const CXCollectArticle;//收藏
extern NSString *const CXCancelCollectArticle;
extern NSString *const CXFocusUser;//关注
extern NSString *const CXShareArticle;
extern NSString *const CXReportArticle;

extern NSString *const CXUserHomeInfo;
extern NSString *const CXUserArticleList;
extern NSString *const CXUserFindList;
extern NSString *const CXUserVideoList;


extern NSString *const CXPostArticle;
extern NSString *const CXPostImagesArticle;
extern NSString *const CXPostUserFind;

extern NSString *const CXMyArticleList;
extern NSString *const CXArticleTop;
extern NSString *const CXDeleteArticle;
extern NSString *const CXFixArticle;
extern NSString *const CXMyArticleInfo;


extern NSString *const CXCollectArticleList;
extern NSString *const CXCollectFindList;
extern NSString *const CXChangeUserInfo;

extern NSString *const CXHotSearchTag;
extern NSString *const CXSetHomeCategories;
extern NSString *const CXSerchResultArticleList;

extern NSString *const CXSetHangye;
extern NSString *const CXMyFansListURL;
extern NSString *const CXMyFollowsListURL;
extern NSString *const CXMyVisitorsListURL;

extern NSString *const CXMyCommentsListURL;
extern NSString *const CXDeleteMyCommentURL;


extern NSString *const CXAMapKey;//高德地图key
extern NSString *const CXGetSmsCaptcha;//获取短信验证码

extern NSString *const CXJPushAppKey;


@end
