//
//  FDWebViewController.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface FDWebViewController () <UIWebViewDelegate,
                                   NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *goBackButton;
@property (nonatomic, strong) UIBarButtonItem *goForwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@end

@implementation FDWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    //_stopButton = nil;
    //
    //
    //
<<<<<<< HEAD
    /**
     *  sfsdfsdf
     */
    //add other GID_MAX
    _stopButton.isEnabled = YES;
=======
>>>>>>> dd938d35592a55dff9d8072ae8fda4be7a3c51c6
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                             target:self
                             action:@selector(onShare:)];
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.webView];
    [self.view addSubview:_progressView];
    self.view.backgroundColor = [UIColor whiteColor];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(2);
    }];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_progressView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];

    self.goBackButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"Browser_Icon_Backward"]
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(goBackPressed:)];
    self.goForwardButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"Browser_Icon_Forward"]
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(goForwardPressed:)];
    self.refreshButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"Browser_Icon_Refresh"]
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(refreshPressed:)];
    self.stopButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"Browser_close"]
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(stopPressed:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:nil
                             action:nil];
    [self
        setToolbarItems:[NSArray arrayWithObjects:flexItem, self.goBackButton,
                                                  flexItem, self.goForwardButton,
                                                  flexItem, self.refreshButton,
                                                  flexItem, self.stopButton,
                                                  flexItem, nil]
               animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest *request =
        [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.navigationController.toolbarHidden = NO;
                     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.toolbarHidden = YES;
    [_progressView removeFromSuperview];
}

- (void)goBackPressed:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)goForwardPressed:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)refreshPressed:(id)sender
{
    [self.webView reload];
}

- (void)stopPressed:(id)sender
{
    [self.webView stopLoading];
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (void)onShare:(id)sender
{
}

#pragma UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    self.stopButton.enabled = self.webView.isLoading;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];

    self.goBackButton.enabled = [self.webView canGoBack];
    self.goForwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.webView.isLoading;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.goBackButton.enabled = [self.webView canGoBack];
    self.goForwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.webView.isLoading;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress
         updateProgress:(float)progress
{
    if (progress >= NJKFinalProgressValue) {
        _progressView.hidden = YES;
    }
    else {
        [_progressView setProgress:progress animated:NO];
    }
}

@end
