//
//  RSSItemManager.h
//  SinaNews
//
//  Created by George She on 16/2/19.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSSubChannel.h"
#import "RSSChannelDetail.h"
#import "RSSRoot.h"

@interface RSSItemManager : NSObject

+ (instancetype)sharedInstance;
- (void)queryChannelsWithsuccess:(void (^)(RSSRoot *ret))successBlock
						  failed:(void (^)(NSError *error))failedBlock;

- (void)getRssItem:(RSSSubChannel *)channel
              page:(NSInteger)pageIndex
         pageCount:(NSInteger)pageCount
           success:(void (^)(NSArray<RSSItemModel>  *ret, RSSChannelDetail *detail))successBlock
            failed:(void (^)(NSError *error))failedBlock;

@end
