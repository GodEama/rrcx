//
//  Const.m
//  rrcx
//
//  Created by 123 on 2017/8/31.
//  Copyright © 2017年 123. All rights reserved.
//

#import "Const.h"

@implementation Const

NSString * const CXAMapKey = @"d654365ce0dc91fe4ea1032faa3b5b0d";

NSString *const CXAliyunToken = @"/Api/Common/getAliyunOssUploadToken";


NSString * const CXGetSmsCaptcha = @"/Api/Common/sendSmsCaptcha";

NSString * CXHostURL = @"http://lf.snssdk.com/";
NSString *const CXVersion_Code=@"6.2.6";
NSString *const CXVid=@"3678164C-BC97-4BDE-90C3-3796BF8C39DA";
NSString *const CXDriveID=@"3002398707";
NSString *const CXOpenudid=@"5f892e162435cdbae5dc2856c69bb9ecbc678040";
NSString *const CXIdfv=@"3678164C-BC97-4BDE-90C3-3796BF8C39DA";
NSString *const CXIid=@"12374638189";
NSString *const CXSendSmsCaptche = @"/Api/Common/sendSmsCaptcha";//获取短信验证码
NSString *const CXGetImageCaptche = @"/Api/Common/imageCaptcha";//获取图形验证码
NSString *const CXUploadImage = @"/Api/Common/uploadImage";//上传图片
NSString *const CXGetHangyeList = @"/Api/Common/hangyeList";//获取行业列表
NSString *const CXGetAreaList = @"/Api/Common/regionList";//获取地区列表
NSString *const CXRegistWithPhone = @"/Api/Register/register";//手机号注册
NSString *const CXEditProfile = @"/Api/Register/editProfile";//填写必要个人信息
NSString *const CXLoginURL = @"/Api/Login/login";//登录
NSString *const CXCheckPhone = @"/Api/Findpassword/checkPhone";//检验手机号
NSString *const CXFindPassword = @"/Api/Findpassword/restPassword";//重置密码
NSString *const CXSelfInfo = @"/Api/My/info";//


NSString *const CXCategoryTitlesURL=@"/Api/Home/getNav";//分类
NSString *const CXCategoryExtra=@"article/category/get_extra/v1/";
NSString *const CXCategoryRecommend=@"user/relation/user_recommend/v1/supplement_recommends/";
NSString *const CXSearchSuggest=@"search/suggest/homepage_suggest/";
NSString *const CXFocusonUser=@"2/relation/follow/v2/";
NSString *const CXUnFocusonUser=@"2/relation/unfollow/";
NSString *const CXGetFeedNews=@"api/news/feed/v58/";
NSString *const CXZangWeibo=@"CXdiscuss/v1/commit/threaddigg/";
NSString *const CXGetWeiboContent=@"CXdiscuss/v1/thread/detail/content";

NSString *const CXCategoryTitleModelMe=@"CategoryTitleModelMe";
NSString *const CXCategoryTitleModelOther=@"CategoryTitleModelOther";

NSString * const CXHomeBanner = @"/Api/Home/getAds";                   //首页banner
NSString * const CXArticleList = @"/Api/Home/argicleList";                  //文章列表
NSString * const CXNewsList = @"/Api/Home/findList";                     //动态列表
NSString * const CXArticleDetail = @"/Api/Home/article";                //文章／动态详情
NSString * const CXZanContent = @"/Api/Home/articleUpDown";//点赞

NSString *const CXCommentReplayList = @"/Api/Comment/replyList";
NSString *const CXCommentList = @"/Api/Comment/comList";
NSString *const CXReplayComment = @"/Api/CommentL/add";
NSString *const CXZanComment = @"/Api/Comment/like";

NSString *const CXCollectArticle = @"/Api/ArticleCollect/add";
NSString *const CXCancelCollectArticle = @"/Api/ArticleCollect/remove";
NSString *const CXFocusUser = @"/Api/MemberFansL/add";
NSString *const CXShareArticle = @"/Api/Share/share";
NSString *const CXReportArticle = @"/Api/Report/report";

NSString *const CXUserHomeInfo = @"/Api/Person/index";
NSString *const CXUserArticleList = @"/Api/Person/articleList";
NSString *const CXUserFindList = @"/Api/Person/microblogList";
NSString *const CXUserVideoList = @"/Api/Person/videoList";


NSString *const CXPostArticle = @"/Api/My_Article/add";
NSString *const CXPostImagesArticle = @"";
NSString *const CXPostUserFind = @"/Api/My_Microblog/add";

NSString *const CXMyArticleList = @"/Api/My_Article/lists";
NSString *const CXArticleTop = @"/Api/My_Article/applyTop";
NSString *const CXDeleteArticle = @"/Api/My_Article/delete";
NSString *const CXFixArticle = @"/Api/My_Article/edit";
NSString *const CXMyArticleInfo = @"/Api/My_Article/getArticleInfoForEdit";


NSString *const CXCollectArticleList = @"/Api/My/collect";
NSString *const CXCollectFindList = @"/Api/My/collect";
NSString *const CXChangeUserInfo = @"/Api/My/settingSet";


NSString *const CXHotSearchTag = @"/Api/Home/searchHeat";
NSString *const CXSetHomeCategories = @"/Api/Home/setNav";
NSString *const CXSerchResultArticleList = @"/Api/Home/search";

NSString *const CXSetHangye = @"/Api/My/setHangye";

NSString *const CXMyFansListURL = @"/Api/Person/following";
NSString *const CXMyFollowsListURL = @"/Api/Person/followed";
NSString *const CXMyVisitorsListURL = @"/Api/Person/visitors";
NSString *const CXMyCommentsListURL = @"/Api/CommentL/myCommentList";
NSString *const CXDeleteMyCommentURL = @"/Api/CommentL/myCommentDelete";




NSString *const CXJPushAppKey = @"23ac5730ef79f2e1168dfe32";



@end
