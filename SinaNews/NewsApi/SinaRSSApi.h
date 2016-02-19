//
//  SinaNewsApi.h
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSRoot.h"
#import "RSSChannelDetail.h"
#import "RSSSubChannel.h"

@interface SinaRSSApi : NSObject
- (void)queryChannelsWithsuccess:(void (^)(RSSRoot *ret))successBlock
                              failed:(void (^)(NSError *error))failedBlock;

- (void)loadItemsWithSubChannel:(RSSSubChannel *)channel
                success:(void (^)(RSSChannelDetail *ret))successBlock
                 failed:(void (^)(NSError *error))failedBlock;
@end
