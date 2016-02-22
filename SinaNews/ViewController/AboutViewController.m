//
//  AboutViewController.m
//  SinaNews
//
//  Created by George She on 16/2/17.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createUI];
}

- (void)createUI {
  UIImageView *appIcon = [[UIImageView alloc] init];
  appIcon.layer.cornerRadius = 4;
  appIcon.layer.borderColor = [UIColor whiteColor].CGColor;
  appIcon.layer.borderWidth = 2;
  appIcon.clipsToBounds = YES;
  appIcon.image = [UIImage imageNamed:@"icon"];
  [self.view addSubview:appIcon];

  UILabel *appNameLabel = [UILabel new];
  [self.view addSubview:appNameLabel];
  appNameLabel.font = Font_15_B;
  appNameLabel.text = @"Sina RSS News";
  UILabel *copyRightLabel = [UILabel new];
  copyRightLabel.font = Font_10;
  copyRightLabel.text = @"Copyright (C) George She 2016";
  [self.view addSubview:copyRightLabel];
  [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.width.mas_equalTo(40);
    make.height.mas_equalTo(40);
  }];
  [copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view.mas_bottom).offset(-15);

  }];

  [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(copyRightLabel.mas_top).offset(-15);
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
