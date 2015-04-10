//
//  MITbSearchViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-4-10.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIChooseAlertView.h"

@interface MITbSearchViewController : MIBaseViewController <UISearchBarDelegate,UISearchDisplayDelegate,MIChooseAlertViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
@property (nonatomic, strong) MIChooseAlertView *alertView;
@property (nonatomic, strong) NSString *taobaoKeyWord;
@property (nonatomic, strong) UIImageView *rebate;
@property (nonatomic, strong) UIView *bgView;
@end
