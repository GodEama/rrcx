//
//  CXUserHomeRequest.m
//  rrcx
//
//  Created by 123 on 2017/9/13.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserHomeRequest.h"

@implementation CXUserHomeRequest















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
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
