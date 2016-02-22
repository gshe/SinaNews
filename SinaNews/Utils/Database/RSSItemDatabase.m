//
//  RSSItemDatabase.m
//  SinaNews
//
//  Created by George She on 16/2/19.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "RSSItemDatabase.h"
#import "FMDB.h"
#import "RSSItemModel.h"
#import "RSSSubChannel.h"

#define RSSITEM_DATABASE @"rssitem.db"

@interface RSSItemDatabase ()
@property(nonatomic, strong) FMDatabase *database;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation RSSItemDatabase
- (NSString *)databasePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  NSString *dbPath =
      [documentDirectory stringByAppendingPathComponent:RSSITEM_DATABASE];
  return dbPath;
}

- (void)dealloc {
  if (_database) {
    [_database close];
    _database = nil;
  }
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _database = [FMDatabase databaseWithPath:[self databasePath]];
    if ([_database open]) {
      if (![self isTableExisted]) {
        [self createTable];
      }
    } else {
      _database = nil;
    }
  }
  return self;
}

- (BOOL)isTableExisted {

  NSString *sql = @"SELECT COUNT(*) FROM sqlite_master where type='table' and "
      @"name='RSSChannel'";
  int nCount = 0;
  FMResultSet *rs = [_database executeQuery:sql];
  if ([rs next]) {
    nCount = [rs intForColumnIndex:0];
  }
  return nCount > 0;
}

- (BOOL)createTable {
  NSArray *sqlArr = @[
    @"CREATE TABLE IF NOT EXISTS RSSChannel (id INTEGER PRIMARY KEY \
    AUTOINCREMENT, title TEXT, xmlUrl TEXT, text TEXT, htmlUrl TEXT, type \
    TEXT)",
    @"CREATE TABLE IF NOT EXISTS RSSItem (id INTEGER \
    PRIMARY KEY AUTOINCREMENT, channelId INTEGER, author TEXT, newsDesc \
    TEXT, guid TEXT, link TEXT, pubDate TIMESTAMP, title TEXT, isRead INTEGER)",
    @"CREATE INDEX ON RSSItem(pubDate)",
    @"CREATE INDEX ON RSSItem(link)",
    @"CREATE INDEX ON RSSChannel(xmlUrl)"
  ];

  for (NSString *sql in sqlArr) {
    [_database executeUpdate:sql];
  }
  return YES;
}

- (BOOL)insertRssItem:(RSSItemModel *)item withChannelId:(long long)channelId {
  NSString *sql = @"INSERT INTO RSSItem(channelId, author, newsDesc, "
      @"guid, link, pubDate, title, isRead) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
  ;
  return [_database executeUpdate:sql, @(channelId), item.author, item.newsDesc,
                                  item.guid, item.link, item.pubDate,
                                  item.title, @(0)];
}

- (BOOL)insertRssChannel:(RSSSubChannel *)channel {
  NSString *sql = @"INSERT INTO RSSChannel(title, xmlUrl, text, htmlUrl, "
      @"type) VALUES(?, ?, ?, ?, ?)";

  return [_database executeUpdate:sql, channel.title, channel.xmlUrl,
                                  channel.text, channel.htmlUrl, channel.type];
}

- (long long)getRssChannelId:(RSSSubChannel *)channel {
  NSString *sql =
      [NSString stringWithFormat:@"SELECT id FROM RSSChannel WHERE xmlUrl='%@'",
                                 channel.xmlUrl];
  FMResultSet *rs = [_database executeQuery:sql];
  long long channelId = -1;
  if ([rs next]) {
    channelId = [rs longLongIntForColumnIndex:0];
  }
  return channelId;
}

- (long long)getRssItemId:(RSSItemModel *)item {
  NSString *sql = [NSString
      stringWithFormat:@"SELECT id FROM RSSItem WHERE link='%@'", item.link];
  FMResultSet *rs = [_database executeQuery:sql];
  long long channelId = -1;
  if ([rs next]) {
    channelId = [rs longLongIntForColumnIndex:0];
  }
  return channelId;
}

- (void)storeRssItemWithChannel:(RSSSubChannel *)channel
                          items:(RSSChannelDetail *)items {
  long channelId = [self getRssChannelId:channel];
  if (channelId < 0) {
    [self insertRssChannel:channel];
    channelId = [self getRssChannelId:channel];
  }

  for (RSSItemModel *item in items.item) {
    long long itemId = [self getRssItemId:item];
    if (itemId < 0) {
      [self insertRssItem:item withChannelId:channelId];
    }
  }
}

- (NSArray<RSSItemModel> *)getRssItemWithChannel:(RSSSubChannel *)channel
                                            page:(NSInteger)pageIndex
                                       pageCount:(NSInteger)pageCount {
  NSMutableArray<RSSItemModel> *items = [@[] mutableCopy];
  long channelId = [self getRssChannelId:channel];
  NSString *sql = [NSString
      stringWithFormat:@"SELECT id, author, newsDesc, "
                       @"guid, link, pubDate, title, isRead FROM RSSItem WHERE "
                       @"channelId=%ld ORDER BY pubDate DESC LIMIT %ld OFFSET %ld",
                       channelId, pageCount, (pageIndex - 1) * pageCount];
  FMResultSet *rs = [_database executeQuery:sql];
  while ([rs next]) {
    RSSItemModel *item = [[RSSItemModel alloc] init];
    item.dbId = [rs longLongIntForColumn:@"id"];
    item.isRead = [rs intForColumn:@"isRead"] ? YES : NO;
    item.author = [rs stringForColumn:@"author"];
    item.newsDesc = [rs stringForColumn:@"newsDesc"];
    item.guid = [rs stringForColumn:@"guid"];
    item.link = [rs stringForColumn:@"link"];
    item.title = [rs stringForColumn:@"title"];
    item.pubDate = [rs dateForColumn:@"pubDate"];
    [items addObject:item];
  }
  return items;
}

- (void)rssItemIsRead:(RSSItemModel *)item {
  [_database executeUpdate:@"UPDATE RSSItem SET isRead = ? WHERE id = ?", @(1),
                           @(item.dbId)];
}
@end
