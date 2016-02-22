//
//  SettingsTableViewController.m
//  Floyd
//
//  Created by admin on 16/1/4.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "XMDeveloperHelper.h"
#import "AboutViewController.h"
#import "FDCacheHelper.h"

@interface SettingsTableViewController ()
@property(nonatomic, strong) NITableViewActions *actions;
@property(nonatomic, strong) NSString *cacheSize;
@property(nonatomic, strong) FDCacheHelper *cacheHelper;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cacheHelper = [[FDCacheHelper alloc] init];

  [self refreshUI];
  [self reloadCacheSize];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)refreshUI {
  _actions = [[NITableViewActions alloc] initWithTarget:self];
  NSMutableArray *contents = [@[] mutableCopy];
  [contents addObject:@"通用"];
  [contents
      addObject:[self.actions
                    attachToObject:[NITitleCellObject objectWithTitle:@"关于"]
                       tapSelector:@selector(aboutApp:)]];
  [contents addObject:@"缓存"];
  NSString *cacheLabel = @"清空缓存 大小: 计算中...";
  if (self.cacheSize) {
    cacheLabel =
        [NSString stringWithFormat:@"清空缓存 大小: %@", self.cacheSize];
  }

  [contents
      addObject:[self.actions attachToObject:[NITitleCellObject
                                                 objectWithTitle:cacheLabel]
                                 tapSelector:@selector(cleanCache:)]];
  [contents addObject:@"调试"];
  [contents
      addObject:[NISwitchFormElement
                    switchElementWithID:0
                              labelText:@"Switch with target/selector"
                                  value:[[XMDeveloperHelper
                                                sharedInstance] isFlexOpen]
                        didChangeTarget:self
                      didChangeSelector:@selector(openFlex:)]];

  self.tableView.delegate = [self.actions forwardingTo:self];
  [self setTableData:contents];
}

- (void)reloadCacheSize {
  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat size = [self.cacheHelper getCacheSize];
        self.cacheSize = [NSString stringWithFormat:@"%.2f MB", size];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self refreshUI];
        });
      });
}

- (void)openFlex:(id)sender {
  if ([[XMDeveloperHelper sharedInstance] isFlexOpen]) {
    [[XMDeveloperHelper sharedInstance] closeFlex];
  } else {
    [[XMDeveloperHelper sharedInstance] openFlex];
  }
}

- (void)aboutApp:(id)sender {
  AboutViewController *aboutVC =
      [[AboutViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)cleanCache:(id)sender {
  [self showHUD];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [self.cacheHelper clearCache];
                   [self reloadCacheSize];
                   dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideAllHUDs];
                   });
                 });
}

@end
