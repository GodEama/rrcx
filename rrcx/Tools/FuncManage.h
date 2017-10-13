//
//  FuncManage.h
//  nq
//
//  Created by 一仓科技 on 15/12/21.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuncManage : NSObject

/**
 *  创建模型
 *
 *  @param dictionary 模型数据
 *  @param className   模型类
 *
 *  @return 创建好的模型
 */
+ (id)modelWithDictionary:(NSDictionary *)dictionary className:(NSString *)className;

/**
 *  创建模型数组
 *
 *  @param array     模型数据
 *  @param className 模型类
 *
 *  @return 创建好的模型数组
 */
+ (NSArray *)modelsWithArray:(NSArray *)array className:(NSString *)className;

/**
 *  模型里去某个数据
 *
 *  @param path 数据名称
 *  @param mod  模型
 *
 *  @return 该模型的对应数据值，nil为空或没有这个数据以及该数据不是对象类型
 */
+ (id)valueWithPath:(NSString *)path mod:(id)mod;

/**
 *  更新模型数据
 *
 *  @param model      模型
 *  @param dictionary 新模型数据
 */
+ (void)updateModelWithModel:(id)model
                  dictionary:(NSDictionary *)dictionary;

/**
 *  设置评分显示图片
 *
 *  @param images      显示图片view数组
 *  @param image       普通状态图片
 *  @param selectImage 选中状态图片
 *  @param stra        评分
 */
+ (void)setStraImageWithImages:(NSArray *)images
                         image:(UIImage *)image
                   selectImage:(UIImage *)selectImage
                          star:(NSInteger)stra;

/**
 *  时间格式转换
 *
 *  @param timeString 初始时间
 *
 *  @return 转换后的时间
 */
+ (NSString *)timeWithTimeString:(NSString *)timeString;

/**
 *  时间格式转换
 *
 *  @param date 时间
 *
 *  @return 转换系统上传需要的时间
 */
+ (NSString *)timeWithDate:(NSDate *)date;

+ (NSString *)timeFormDate:(NSDate *)date andForMatterString:(NSString *)formatter;
/**
 *  时间格式转换
 *
 *  @param time 系统返回时间字符串
 *
 *  @return date类型
 */
+ (NSDate *)dateWithTime:(NSString *)time;


/**
 *  根据数字类型的字符串转为年月日格式
 *
 *  @param numString 数字类型字符串
 *
 *  @return 年月日
 */
+ (NSString *)timeWithNumberString:(NSString *)numString;

/**
 *  时间格式转换
 *
 *  @param time 系统返回时间字符串(年月日)
 *
 *  @return date类型
 */
+ (NSDate *)dateWithAgeTime:(NSString *)time;

/**
 *  通过出生日期计算年龄
 *
 *  @param date 出生日期
 *
 *  @return 年龄
 */
+ (NSInteger)ageWithDate:(NSDate *)date;

/**
 *  密码加密
 *
 *  @param password 未加密的密码
 *
 *  @return 加密后的密码
 */
+ (NSString *)passwordWithString:(NSString *)password;

/**
 *  用户名正则判断
 *
 *  @param string 用户名字符串
 *
 *  @return 是否为合法用户名
 */
+ (BOOL)theStringIsUserName:(NSString *)string;

/**
 *  电话号码正则判断
 *
 *  @param string 电话号码
 *
 *  @return 是否为合法电话号码
 */
+ (BOOL)theStringIsPhone:(NSString *)string;

/**
 *  密码正则判断
 *
 *  @param string 密码
 *
 *  @return 是否为合法密码
 */
+ (BOOL)theStringIsPassword:(NSString *)string;

/**
 *  字符串为空判断
 *
 *  @param string 空字符串
 *
 *  @return 是否为空的字符串
 */
+ (BOOL)theStringIsEmpty:(NSString *)string;

/**
 *  字符串判断是否为中文
 *
 *  @param string 中文
 *
 *  @return 是否是中文
 */
+ (BOOL)theStringIsChinese:(NSString *)string;

/**
 *  字符串判断是否为身份证号
 *
 *  @param string 身份证号
 *
 *  @return 是否是身份证号
 */
+ (BOOL)theStringIsIdCard:(NSString *)string;

/**
 *  支付宝状态
 *
 *  @param success 返回码
 *
 *  @return 是否支付成功
 */
+ (BOOL)alipayPayEndSuccess:(NSString *)success;

/**
 *  添加上拉下拉事件
 *
 *  @param target     目标
 *  @param scrollView 添加刷新事件的试图
 *  @param upSel      上拉方法 为空则不添加
 *  @param downSel    下拉方法 为空则不添加
 */
+ (void)addRefurbishWithTarget:(id)target
                    scrollView:(UIScrollView *)scrollView
                         upSel:(SEL)upSel
                       downSel:(SEL)downSel;
+(NSString *)replacexinghaoWithMobileNumber:(NSString *)mobile;

/*
 *MD5加密
 */
+ (NSString *)md5EncryptWithString:(NSString *)string;
/**
 *  MD5加密, 32位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)str;

/**
 *  MD5加密, 32位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

/**
 *  MD5加密, 16位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower16Bate:(NSString *)str;

/**
 *  MD5加密, 16位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper16Bate:(NSString *)str;

+ (BOOL)checkEmail:(NSString *)email;


//+(void)goToLoginWith:(UIViewController *)vc;


+ (BOOL) checkCardNo:(NSString*) cardNo;
+(void)goToLoginWith:(UIViewController *)vc;

+ (UIViewController *)getCurrentVC;
@end
