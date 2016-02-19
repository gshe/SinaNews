//
//  NewsItemModel.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "RSSItemModel.h"

@implementation RSSItemModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"author" : @"author",
    @"description" : @"newsDesc",
    @"guid" : @"guid",
    @"link" : @"link",
    @"title" : @"title",
    @"pubDate" : @"pubDate",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}

- (NSString *)pubDateStr {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  return [formatter stringFromDate:_pubDate];
}
@end
