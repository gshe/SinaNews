//
//  RSSItemDatabase.h
//  SinaNews
//
//  Created by George She on 16/2/19.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSSubChannel.h"
#import "RSSItemModel.h"
#import "RSSChannelDetail.h"

@interface RSSItemDatabase : NSObject
- (void)storeRssItemWithChannel:(RSSSubChannel *)channel
											  items:(RSSChannelDetail *)items;

- (NSArray<RSSItemModel>  *)getRssItemWithChannel:(RSSSubChannel *)channel
                         page:(NSInteger)pageIndex
                    pageCount:(NSInteger)pageCount;

- (void)rssItemIsRead:(RSSItemModel *)item;
@end
