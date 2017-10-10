//
//  CXArticleDetail.m
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXArticleDetailModel.h"

@implementation CXArticleDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"authorInfo":[CXAuthInfo class]};
}
@end
