//
//  CXHomeRequest.h
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 请求成功的block
 
 
 @param response 响应体数据
 */
typedef void(^PPRequestSuccess)(id response);
/**
 请求失败的block
 
 */
typedef void(^PPRequestFailure)(NSError *error);

/// 缓存的Block
typedef void(^PPHttpRequestCache)(id responseCaches);
@interface CXHomeRequest : NSObject


+(NSURLSessionTask *)getAliyunToken:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取首页分类

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getCategoryTitles:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取首页banner

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getHomeBanner:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取文章列表

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getOneArticleListWithUrl:(NSString *)url andParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取动态列表

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getNewsListWithUrl:(NSString *)url andParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取文章详情

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getArticleDetail:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 赞文章 赞动态

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)zanArticle:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;



/**
 发送短信验证码

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)sendSmsCode:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/**
 注册用户

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)registUser:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取行业数据

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getHangyeData:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 注册完成

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)completeRegist:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 手机号登录

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)loginWithPhone:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取地区数据

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getAreaData:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 检查手机号

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)checkPhone:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 找回密码

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)resetPassword:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取个人信息

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getSelfInfo:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


/**
 发布文章、

 @param url <#url description#>
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)postArticleWithUrl:(NSString*)url andParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


/**
 发布动态

 @param url <#url description#>
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)postMyBlogWithUrl:(NSString*)url andParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/**
 获取文章信息

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getMyArticleDataWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;










/**
 举报文章、动态

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)reportArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 删除文章

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)deleteArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
//置顶文章
+(NSURLSessionTask *)setTopArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/**
 收藏文章、动态

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)collectArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/**
 取消收藏

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)cancelCollectArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;




/**
 获取文章评论列表

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getArticleCommentsWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 关注用户、取消关注

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)attentionUserWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 评论、回复

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)commentArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取回复列表

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getReplayListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 获取用户信息

 @param parameters <#parameters description#>
 @param responseCache <#responseCache description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getUserBasicInfo:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;



/**
 修改个人信息

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)changeMyInfoWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;



/**
 获取热搜标签

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)getHotSearchTagWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


/**
 设置订阅频道

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)setHomeCategoriesWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/**
 修改行业

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionTask *)setHangyeWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


//粉丝列表
+(NSURLSessionTask *)getMyFansListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

//关注列表
+(NSURLSessionTask *)getMyfollowsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

//访客列表
+(NSURLSessionTask *)getMyVisitorsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
//我的收藏列表
+(NSURLSessionTask *)getMycollectionArticleListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
//我的评论
+(NSURLSessionTask *)getMyCommentsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
//删除我的评论
+(NSURLSessionTask *)deleteMyCommentsWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
@end
