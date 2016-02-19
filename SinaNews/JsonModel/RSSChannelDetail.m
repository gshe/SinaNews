//
//  NewsChannel.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "RSSChannelDetail.h"

@implementation RSSChannelDetail
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"channel.item" : @"item",
    @"channel.copyright" : @"copyright",
    @"channel.description" : @"channelDesc",
    @"channel.generator" : @"generator",
    @"channel.image.url" : @"imageUrl",
    @"channel.pubDate" : @"pubDate",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
