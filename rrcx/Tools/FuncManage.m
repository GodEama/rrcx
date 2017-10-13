//
//  FuncManage.m
//  nq
//
//  Created by 一仓科技 on 15/12/21.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import "FuncManage.h"
#import <CommonCrypto/CommonDigest.h>
#import "CXLoginViewController.h"
#import "JPushService.h"
@implementation FuncManage

+ (id)modelWithDictionary:(NSDictionary *)dictionary
                   className:(NSString *)className {
    
    if (!dictionary || !className || className.length == 0) {
        
        return nil;
    }
    id model = [[NSClassFromString(className) alloc]init];
    [FuncManage updateModelWithModel:model dictionary:dictionary];
    return model;
}

+ (NSArray *)modelsWithArray:(NSArray *)array className:(NSString *)className {
    if (array.count == 0) {
        return nil;
    }
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        
        id model = [FuncManage modelWithDictionary:array[i] className:className];
        [models addObject:model];
    }
    return models;
}

+ (id)valueWithPath:(NSString *)path mod:(id)mod {
    
    id object = nil;
    @try {
        
        object = [mod valueForKey:path];
    }
    @catch (NSException *exception) {
        
        
    }
    @finally {
        
        return object;
    }
}

+ (void)updateModelWithModel:(id)model dictionary:(NSDictionary *)dictionary {
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        @try {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    
                    obj = nil;
                }
                if ([key isEqualToString:@"id"]) {
                    
                    key = @"id_";
                }
                [model setValue:[FuncManage modelWithDictionary:obj
                                                      className:key]
                     forKeyPath:key];
            }
            else {
                
                if ([obj isKindOfClass:[NSNull class]]) {
                    
                    obj = nil;
                }
                if ([key isEqualToString:@"id"]) {
                    
                    key = @"id_";
                }
                
                [model setValue:obj forKeyPath:key];
            }
        }
        @catch (NSException *exception) {
            
          
        }
    }];
}

+ (void)setStraImageWithImages:(NSArray *)images
                         image:(UIImage *)image
                   selectImage:(UIImage *)selectImage
                          star:(NSInteger)stra {
    
    for (int i = 1; i <= 5; i++) {
        
        UIImageView *imageView = images[i - 1];
        if (i <= stra && stra > 0) {
            
            imageView.image = selectImage;
        }
        else {
            
            imageView.image = image;
        }
    }
}

+ (NSString *)timeWithTimeString:(NSString *)timeString {
    
    static NSDateFormatter *dateForMatter1 = nil;
    static NSDateFormatter *dateForMatter2 = nil;
    if (!dateForMatter1) {
        
        dateForMatter1 = [[NSDateFormatter alloc] init];
        [dateForMatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (!dateForMatter2) {
        
        dateForMatter2 = [[NSDateFormatter alloc] init];
        [dateForMatter2 setDateFormat:@"yyyy.MM.dd"];
    }
    NSDate *date = [dateForMatter1 dateFromString:timeString];
    return [dateForMatter2 stringFromDate:date];
}

+ (NSString *)timeWithDate:(NSDate *)date {
    
    static NSDateFormatter *dateForMatter = nil;
    if (!dateForMatter) {
        
        dateForMatter = [[NSDateFormatter alloc] init];
        [dateForMatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateForMatter stringFromDate:date];
}
+ (NSString *)timeFormDate:(NSDate *)date andForMatterString:(NSString *)formatter {
    
    static NSDateFormatter *dateForMatter = nil;
    if (!dateForMatter) {
        
        dateForMatter = [[NSDateFormatter alloc] init];
        [dateForMatter setDateFormat:formatter];
    }
    return [dateForMatter stringFromDate:date];
}


+ (NSString *)timeWithNumberString:(NSString *)numString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[numString longLongValue]/1000];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSDate *)dateWithTime:(NSString *)time {
    
    static NSDateFormatter *dateForMatter = nil;
    if (!dateForMatter) {
        
        dateForMatter = [[NSDateFormatter alloc] init];
        [dateForMatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateForMatter dateFromString:time];
}

+ (NSDate *)dateWithAgeTime:(NSString *)time {
    
    time = [time substringToIndex:10];
    NSDateFormatter *dateForMatter = nil;

    dateForMatter = [[NSDateFormatter alloc] init];
    
    [dateForMatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateForMatter dateFromString:time];
}

+ (NSInteger)ageWithDate:(NSDate *)date {
    
    static NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear;
    static NSCalendar *gregorian;
    if (!gregorian) {
        
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    return [components year];
}

+ (NSString *)passwordWithString:(NSString *)password {
    
    static NSString *invariant_12 = nil;
    static NSString *invariant_4 = nil;
    password = [FuncManage md5EncryptWithString:password];
    if (!invariant_12) {
        
        NSString *string = [FuncManage md5EncryptWithString:@"sp_"];
        invariant_12 = [string substringWithRange:NSMakeRange(0, 12)];
        invariant_4 = [string substringWithRange:NSMakeRange(string.length - 4, 4)];
    }
    return [NSString stringWithFormat:@"%@%@%@", invariant_12, password, invariant_4];
}

+ (NSString *)md5EncryptWithString:(NSString *)string {
    
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+ (BOOL)theStringIsUserName:(NSString *)string {
    //^[\u4e00-\u9fa5A-Za-z0-9-_]*$
    //^[a-zA-Z0-9\u4e00-\u9fa5]+$原来的
    NSString *sumRegex = @"^[\u4e00-\u9fa5A-Za-z0-9-_]*$";
    NSPredicate *sumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sumRegex];
    //NSString *cnTegex = @"^[a-zA-Z0-9]+$";
    //NSPredicate *cnText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cnTegex];
    BOOL sun = [sumTest evaluateWithObject:string];
    //BOOL cn = ![cnText evaluateWithObject:string];
    return sun;
}

+ (BOOL)theStringIsPhone:(NSString *)string {
    //^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$
//    NSString *phoneRegex = @"^1[3458]{1}\\d{9}$";
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

+ (BOOL)theStringIsPassword:(NSString *)string {
    
    if (string.length < 6 ||string.length > 18) {
        return NO;
    }
    //NSString *pwRegex = @"^[a-zA-Z]\\w{5,17}+$";
    //6-18位字母和数字组合
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pwText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pwText evaluateWithObject:string];

}

+ (BOOL)theStringIsEmpty:(NSString *)string {
    
    if (string.length == 0) {
        
        return YES;
    }
    NSString *emptyRegex = @"^[ \t\n\r]+$";
    NSPredicate *emptyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emptyRegex];
    return [emptyTest evaluateWithObject:string];
}

+ (BOOL)theStringIsChinese:(NSString *)string {
    
    NSString *cnRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *cnText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cnRegex];
    return [cnText evaluateWithObject:string];
}

+ (BOOL)theStringIsIdCard:(NSString *)string {
    
    NSString *idCardRegex = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate *idCardText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    return [idCardText evaluateWithObject:string];
}

+ (BOOL)theStringIsEmail:(NSString *)string {
    
    NSString *emailRegex = @"^1[3458]{1}\\d{9}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (BOOL)alipayPayEndSuccess:(NSString *)success {
    
    if ([success integerValue] == 9000) {
        
        return YES;
    }
    else if ([success integerValue] == 8000) {
        
        [Message showMessageWithConfirm:NO title:@"正在处理中"];
        return NO;
    }
    else if ([success integerValue] == 4000) {
        
        [Message showMessageWithConfirm:NO title:@"订单支付失败"];
        return NO;
    }
    else if ([success integerValue] == 6001) {
        
        [Message showMessageWithConfirm:NO title:@"用户中途取消"];
        return NO;
    }
    else if ([success integerValue] == 6002) {
        
        [Message showMessageWithConfirm:NO title:@"网络连接出错"];
        return NO;
    }
    else
    {
        [Message showMessageWithConfirm:NO title:@"订单支付失败"];
        return NO;
    }
   
}

+ (void)addRefurbishWithTarget:(id)target
                    scrollView:(UIScrollView *)scrollView
                         upSel:(SEL)upSel
                       downSel:(SEL)downSel {
    
//    static NSArray *images = nil;
//    if (!images) {
//        
//        images = @[GET_IMAGE_X(@"loding1"), GET_IMAGE_X(@"loding1"), GET_IMAGE_X(@"loding2"), GET_IMAGE_X(@"loding3"), GET_IMAGE_X(@"loding4"), GET_IMAGE_X(@"loding5"), GET_IMAGE_X(@"loding5"), GET_IMAGE_X(@"loding4"), GET_IMAGE_X(@"loding3"), GET_IMAGE_X(@"loding2")];
//    }
    if (upSel) {
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:upSel];
//        [footer setImages:images
//                 forState:MJRefreshStateRefreshing];
        scrollView.mj_footer = footer;
    }
    if (downSel) {
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:downSel];
//        [header setImages:images forState:MJRefreshStateRefreshing];
//        [header setImages:images forState:MJRefreshStateIdle];
//        [header setImages:images forState:MJRefreshStatePulling];
        header.lastUpdatedTimeLabel.hidden = NO;
        scrollView.mj_header = header;
    }
}

+(NSString *)replacexinghaoWithMobileNumber:(NSString *)mobile
{
    
    return [mobile stringByReplacingOccurrencesOfString:[mobile substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    //substringWithRange:NSMakeRange(3,4)    从第三位开始截取四个字符
}

#pragma mark 判断邮箱

+ (BOOL)checkEmail:(NSString *)email{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
    
}
//+(void)goToLoginWith:(UIViewController *)vc{
//    [PPNetworkCache removeAllHttpCache];
//    
//    if (TOKEN) {
//        [MobClick profileSignOff];
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
//        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//            DLog(@"resCode  是 %ld 别名：%@ 序列号：%ld",iResCode,iAlias,seq);
//        } seq:101];
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录信息已过期，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            JCLoginViewController * loginVC = [[JCLoginViewController alloc] init];
//            loginVC.type = 100;
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//            [vc.navigationController presentViewController:nav animated:YES completion:nil];
//        }];
//        [alert addAction:okAction];
//        [vc presentViewController:alert animated:YES completion:nil];
//    }
//    else{
//        JCLoginViewController * loginVC = [[JCLoginViewController alloc] init];
//        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [vc.navigationController presentViewController:nav animated:YES completion:nil];
//        
//        
//    }
//}
+ (BOOL) checkCardNo:(NSString*) cardNo{
    
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
+(void)goToLoginWith:(UIViewController *)vc{
    [PPNetworkCache removeAllHttpCache];
    
    if (TOKEN) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            DLog(@"resCode  是 %ld 别名：%@ 序列号：%ld",iResCode,iAlias,seq);
        } seq:101];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录信息已过期，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CXLoginViewController * loginVC = [[CXLoginViewController alloc] init];
            
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [vc.navigationController presentViewController:nav animated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [vc presentViewController:alert animated:YES completion:nil];
    }
    else{
        CXLoginViewController * loginVC = [[CXLoginViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [vc.navigationController presentViewController:nav animated:YES completion:nil];
        
        
    }
}


+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
@end
