//
//  NewsTableViewController.m
//  Floyd
//
//  Created by admin on 16/1/4.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "NewsViewController.h"
#import "RSSItemManager.h"
#import "NewsListViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "SettingsTableViewController.h"

@interface NewsViewController () <ViewPagerDelegate, ViewPagerDataSource>
@property(nonatomic, strong) RSSRoot *rssRoot;
@property(nonatomic, strong) RSSChannel *curChannel;
@end

@implementation NewsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"资讯";

  self.dataSource = self;
  self.delegate = self;

  [[RSSItemManager sharedInstance] queryChannelsWithsuccess:^(RSSRoot *ret) {
    self.rssRoot = ret;
    self.curChannel = ret.channel[0];
    self.title = self.curChannel.title;
    [self reloadData];
  } failed:^(NSError *error){

  }];

  self.navigationItem.rightBarButtonItem = [[MMDrawerBarButtonItem alloc]
      initWithTarget:self
              action:@selector(channelSelectedPressed:)];

  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(settingButtonOnPressed)];
}
- (void)settingButtonOnPressed {
  SettingsTableViewController *settingsVC =
      [[SettingsTableViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
  if (self.curChannel.subChannel) {
    return self.curChannel.subChannel.count;
  }

  return 0;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager
    viewForTabAtIndex:(NSUInteger)index {
  UILabel *label = [UILabel new];
  RSSSubChannel *category = self.curChannel.subChannel[index];

  label.text = category.title.length > 4 ? [category.title substringToIndex:4]
                                         : category.title;
  label.backgroundColor = [UIColor clearColor];
  [label sizeToFit];

  return label;
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager
      valueForOption:(ViewPagerOption)option
         withDefault:(CGFloat)value {
  switch (option) {
  case ViewPagerOptionTabWidth:
    value = 86;
    break;

  default:
    break;
  }
  return value;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager
    contentViewControllerForTabAtIndex:(NSUInteger)index {
  RSSSubChannel *subChannel = self.curChannel.subChannel[index];
  NewsListViewController *vc =
      [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
  vc.subChannel = subChannel;
  return vc;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager
     colorForComponent:(ViewPagerComponent)component
           withDefault:(UIColor *)color {
  switch (component) {
  case ViewPagerIndicator:
    color = [UIColor redColor];
    break;
  case ViewPagerTabsView:
    color = [UIColor whiteColor];
    break;
  default:
    break;
  }
  return color;
}

- (void)channelSelectedPressed:(id)sender {
  self.channelSelectVC.channelList = self.rssRoot.channel;
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight
                                    animated:YES
                                  completion:nil];
}

- (void)channelSelected:(RSSChannel *)selectedChannel {
  [self.mm_drawerController
      closeDrawerAnimated:YES
               completion:^(BOOL finished) {
                 self.curChannel = selectedChannel;
                 self.title = self.curChannel.title;
                 [self reloadData];
               }];
}

@end
