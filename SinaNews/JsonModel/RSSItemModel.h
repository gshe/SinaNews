//
//  NewsItemModel.h
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol RSSItemModel
@end

@interface RSSItemModel : JSONModel
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSString *newsDesc;
@property(nonatomic, strong) NSString *guid;
@property(nonatomic, strong) NSString *link;
@property(nonatomic, strong) NSDate *pubDate;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL isRead;
@property(nonatomic, assign) long long dbId;
@property(nonatomic, strong, readonly) NSString *pubDateStr;
@end