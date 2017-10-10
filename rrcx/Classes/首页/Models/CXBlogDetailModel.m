//
//  CXBlogDetailModel.m
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXBlogDetailModel.h"

@implementation CXBlogDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"authorInfo":[CXAuthInfo class]};
}
@end
