//
//  CXHomeRequest.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXHomeRequest.h"

@implementation CXHomeRequest
+(NSURLSessionTask *)getAliyunToken:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXAliyunToken];
    return[self GETrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getCategoryTitles:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCategoryTitlesURL];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)getHomeBanner:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXHomeBanner];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)getOneArticleListWithUrl:(NSString *)url andParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,url];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)getNewsListWithUrl:(NSString *)url andParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,url];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)getArticleDetail:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXArticleDetail];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)zanArticle:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXZanContent];
    return[self GETrequestWithURL:url parameters:parameters  success:success failure:failure];
    
}
+(NSURLSessionTask *)sendSmsCode:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXSendSmsCaptche];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}


+(NSURLSessionTask *)registUser:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXRegistWithPhone];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getHangyeData:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXGetHangyeList];
    return[self GETrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)completeRegist:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXEditProfile];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)loginWithPhone:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXLoginURL];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)getAreaData:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXGetAreaList];
    return[self POSTrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)checkPhone:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCheckPhone];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)resetPassword:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXFindPassword];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getSelfInfo:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXSelfInfo];
    return[self POSTrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)postArticleWithUrl:(NSString*)url andParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,url];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)postMyBlogWithUrl:(NSString*)url andParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,url];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getMyArticleDataWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXMyArticleInfo];
    return[self GETrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)getUserBasicInfo:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXUserHomeInfo];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)collectArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCollectArticle];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)cancelCollectArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCancelCollectArticle];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
//举报文章
+(NSURLSessionTask *)reportArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXReportArticle];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
//删除文章
+(NSURLSessionTask *)deleteArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXDeleteArticle];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
//置顶文章
+(NSURLSessionTask *)setTopArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXArticleTop];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getArticleCommentsWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCommentList];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)commentArticleWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXReplayComment];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}

+(NSURLSessionTask *)getReplayListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCommentReplayList];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)getHotSearchTagWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXHotSearchTag];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
//设置频道
+(NSURLSessionTask *)setHomeCategoriesWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXSetHomeCategories];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)attentionUserWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXFocusUser];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)setHangyeWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXSetHangye];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}
+(NSURLSessionTask *)getMyFansListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXMyFansListURL];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)getMyfollowsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXMyFollowsListURL];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)getMyVisitorsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXMyVisitorsListURL];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)getMycollectionArticleListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXCollectArticleList];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}

+(NSURLSessionTask *)getMyCommentsListWithParameters:(id)parameters responseCache:(PPHttpRequestCache)responseCache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXMyCommentsListURL];
    return[self GETrequestWithURL:url parameters:parameters responseCaches:responseCache success:success failure:failure];
    
}
+(NSURLSessionTask *)deleteMyCommentsWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXDeleteMyCommentURL];
    return[self GETrequestWithURL:url parameters:parameters success:success failure:failure];
    
}







+(NSURLSessionTask *)changeMyInfoWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,CXChangeUserInfo];
    return[self POSTrequestWithURL:url parameters:parameters success:success failure:failure];
    
}


#pragma mark - 请求的公共方法
+ (NSURLSessionTask *)GETrequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
    [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
    [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
    // 发起请求
    return [PPNetworkHelper GET:URL parameters:parameter success:^(id responseObject) {
        [self removeLocalUserTokenWithResult:responseObject];
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (NSURLSessionTask *)GETrequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCaches:(PPHttpRequestCache)cache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
    [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
    [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
    // 发起请求
    return [PPNetworkHelper GET:URL parameters:parameter responseCache:^(id responseCache) {
        cache(responseCache);
    } success:^(id responseObject) {
        [self removeLocalUserTokenWithResult:responseObject];
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}

+ (NSURLSessionTask *)POSTrequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter  success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
    [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
    [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
    // 发起请求
    return [PPNetworkHelper POST:URL parameters:parameter success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        [self removeLocalUserTokenWithResult:responseObject];
        success(responseObject);
        
    } failure:^(NSError *error) {
        // 同上
        failure(error);
    }];
}
+ (NSURLSessionTask *)POSTrequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCaches:(PPHttpRequestCache)cache success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
    [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
    [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
    
    
    // 发起请求
    return [PPNetworkHelper POST:URL parameters:parameter responseCache:^(id responseCache) {
        cache(responseCache);
    } success:^(id responseObject) {
        [self removeLocalUserTokenWithResult:responseObject];
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)removeLocalUserTokenWithResult:(id)responseObject{
    if ([responseObject[@"code"] integerValue] == -1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERTOKEN"];
    }
}
@end
