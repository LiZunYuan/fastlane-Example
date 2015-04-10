//
//  MIShareViewController.h
//  MISpring
//
//  Created by Yujian Xu on 13-6-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIBaseViewController.h"

#define kShareToQZone            @"kShareToQZone"
#define kShareToSinaWeibo        @"sharetosinaweibo"
#define kShareToTengXunWeibo     @"sharetotengxunweibo"

@interface MIShareViewController : MIBaseViewController<UITextViewDelegate>
{    
    NSInteger maxStatusLen;
}

@property (nonatomic, strong) UIView *shareBackgroundView;
@property (nonatomic, strong) UITextView *statusText;
@property (nonatomic, strong) UILabel *captionLimitLabel;
@property (nonatomic, strong) UIView *itemViewBackground;
@property (nonatomic, strong) UIImageView *itemImageView;

@property (nonatomic, strong) NSString *itemImageUrl;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemUrl;
@property (nonatomic, strong) NSString *itemDesc;
@property (nonatomic, strong) NSString *defaultStatus;

-(void)updateCaptionLimitTips;

@end
