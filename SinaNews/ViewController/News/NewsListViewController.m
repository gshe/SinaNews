//
//  NewsListViewController.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "NewsListViewController.h"
#import "RSSItemManager.h"
#import "NewsItemCell.h"
#import "FDWebViewController.h"
#import "MJRefresh.h"

@interface NewsListViewController ()
@property(nonatomic, strong) RSSChannelDetail *channelDetail;
@property(nonatomic, strong) NSMutableArray<RSSItemModel> *rssItems;
@property(nonatomic, strong) NITableViewActions *action;
@property(nonatomic, assign) NSInteger curPage;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.curPage = 1;
  self.rssItems = [@[] mutableCopy];
  [self udpateNews];
  self.tableView.mj_header =
      [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                       refreshingAction:@selector(loadNewData)];
  [self.tableView.mj_header beginRefreshing];
  self.tableView.mj_footer = [MJRefreshAutoNormalFooter
      footerWithRefreshingTarget:self
                refreshingAction:@selector(loadMoreData)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)loadNewData {
  self.curPage = 1;
  [[RSSItemManager sharedInstance] getRssItem:self.subChannel
      page:self.curPage
      pageCount:20
      success:^(NSArray<RSSItemModel> *ret, RSSChannelDetail *detail) {
        self.channelDetail = detail;
        [self.rssItems removeAllObjects];
        [self.rssItems addObjectsFromArray:ret];
        [self udpateNews];
        if (ret.count < 20) {
          [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
      }
      failed:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showError:error];
      }];
}

- (void)loadMoreData {
  self.curPage++;
  [[RSSItemManager sharedInstance] getRssItem:self.subChannel
      page:self.curPage
      pageCount:20
      success:^(NSArray<RSSItemModel> *ret, RSSChannelDetail *detail) {
        [self.rssItems addObjectsFromArray:ret];
        [self udpateNews];
        if (ret.count < 20) {
          [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
          [self.tableView.mj_footer endRefreshing];
        }
      }
      failed:^(NSError *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self showError:error];
      }];
}

- (void)udpateNews {
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.rssItems) {
    for (RSSItemModel *item in self.rssItems) {
      NewsItemCellUserData *userData = [[NewsItemCellUserData alloc] init];
      userData.newsItem = item;
      [contents
          addObject:[self.action attachToObject:
                                     [[NICellObject alloc]
                                         initWithCellClass:[NewsItemCell class]
                                                  userInfo:userData]
                                    tapSelector:@selector(itemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)itemClicked:(NICellObject *)sender {
  NewsItemCellUserData *userData = sender.userInfo;
  RSSItemModel *item = userData.newsItem;
  FDWebViewController *webVC =
      [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
  webVC.urlString = item.link;
  webVC.title = item.title;
  [self.navigationController pushViewController:webVC animated:YES];
  [[RSSItemManager sharedInstance] rssItemIsRead:item];
  item.isRead = YES;
  NSIndexPath *indexPath = [self.model indexPathForObject:sender];
  [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                        withRowAnimation:UITableViewRowAnimationFade];
}
@end
