//
//  MIMyOrderViewController.m
//  MISpring
//
//  Created by 徐 裕健 on 14/10/21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMyOrderViewController.h"

@implementation MIMyOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.rightButton.hidden = YES;
    self.navigationBar.closeButton.left = self.view.viewWidth - 50;
    
    self.segmentView = [[MISegmentView alloc] init];
    self.segmentView.delegate = self;
    self.segmentView.centerX = self.navigationBar.centerX;
    self.segmentView.centerY = self.navigationBar.centerY + IOS7_STATUS_BAR_HEGHT / 2;
    [self.segmentView.leftButton setTitle:@"淘宝订单" forState:UIControlStateNormal];
    [self.segmentView.rightButton setTitle:@"贝贝订单" forState:UIControlStateNormal];
    [self.navigationBar addSubview:self.segmentView];
}

- (void)miPopToPreviousViewController
{
    [[MINavigator navigator] closePopViewControllerAnimated:YES];
}

- (void)segmentView:(MISegmentView *)segmentView didSelectIndex:(NSInteger)index
{
    NSURL *orderURL;
    if (index != 0) {
        orderURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@i/i.html", [MIConfig globalConfig].beibeiURL]];
    } else {
        orderURL = [NSURL URLWithString:[MIConfig globalConfig].myTaobao];
    }
    [self openURL:orderURL];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self setOverlayStatus:EOverlayStatusRemove labelText:nil];
    if (![webView.request.URL.host hasSuffix:@"beibei.com"]){
        [self.segmentView switchTabIndex:0];
    } else {
        [self.segmentView switchTabIndex:1];
    }
}

@end
