//
//  RSSItemManager.m
//  SinaNews
//
//  Created by George She on 16/2/19.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "RSSItemManager.h"
#import "RSSItemDatabase.h"
#import "SinaRSSApi.h"

@interface RSSItemManager ()
@property(nonatomic, strong) RSSItemDatabase *database;
@property(nonatomic, strong) SinaRSSApi *rssApi;
@end

@implementation RSSItemManager

+ (instancetype)sharedInstance {
  static RSSItemManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[RSSItemManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _database = [[RSSItemDatabase alloc] init];
    _rssApi = [[SinaRSSApi alloc] init];
  }
  return self;
}

- (void)queryChannelsWithsuccess:(void (^)(RSSRoot *))successBlock
                          failed:(void (^)(NSError *))failedBlock {
  [_rssApi queryChannelsWithsuccess:^(RSSRoot *ret) {
    successBlock(ret);
  } failed:^(NSError *error) {
    failedBlock(error);
  }];
}

- (void)getRssItem:(RSSSubChannel *)channel
              page:(NSInteger)pageIndex
         pageCount:(NSInteger)pageCount
           success:(void (^)(NSArray<RSSItemModel> *ret,
                             RSSChannelDetail *detail))successBlock
            failed:(void (^)(NSError *error))failedBlock {
  if (pageIndex == 1) {
    [_rssApi loadItemsWithSubChannel:channel
        success:^(RSSChannelDetail *ret) {
          [_database storeRssItemWithChannel:channel items:ret];
          NSArray<RSSItemModel> *items =
              [_database getRssItemWithChannel:channel
                                          page:pageIndex
                                     pageCount:pageCount];
          successBlock(items, ret);
        }
        failed:^(NSError *error) {
          NSArray<RSSItemModel> *items =
              [_database getRssItemWithChannel:channel
                                          page:pageIndex
                                     pageCount:pageCount];
          successBlock(items, nil);
        }];
  } else {
    NSArray<RSSItemModel> *items = [_database getRssItemWithChannel:channel
                                                               page:pageIndex
                                                          pageCount:pageCount];
    successBlock(items, nil);
  }
}

@end
