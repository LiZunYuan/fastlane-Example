//
//  MIAdsAlertView.m
//  MISpring
//
//  Created by yujian on 14-12-24.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIAdsAlertView.h"

@interface MIAdsAlertView()

@property (nonatomic, strong) UIImageView *adsImageView;
@property (nonatomic, strong) UIButton *adsCloseBtn;

@end

@implementation MIAdsAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.adsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.adsImageView.center = CGPointMake(self.viewWidth/2, self.viewHeight/2);
        self.adsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAds)];
        [self.adsImageView addGestureRecognizer:rec];
        [self addSubview:self.adsImageView];
        
        _adsCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _adsCloseBtn.frame = CGRectMake(0, 0, 40, 40);
        [_adsCloseBtn setImage:[UIImage imageNamed:@"ic_qr_close"] forState:UIControlStateNormal];
        [_adsCloseBtn addTarget:self action:@selector(closeAdsAlertView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_adsCloseBtn];
        
    }
    return self;
}

- (void)setAdsImageViewUrl:(NSURL *)url
{
    __weak typeof(self) weakSelf = self;
    [self.adsImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if (error == nil && image)
        {
            self.hidden = NO;
            weakSelf.adsImageView.viewWidth = image.size.width/2;
            weakSelf.adsImageView.viewHeight = image.size.height/2;
            weakSelf.adsImageView.center = CGPointMake(weakSelf.viewWidth/2, weakSelf.viewHeight/2);
            weakSelf.adsCloseBtn.top = weakSelf.adsImageView.top;
            weakSelf.adsCloseBtn.right = weakSelf.adsImageView.right;
        }
    }];
}

- (void)closeAdsAlertView
{
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(closeAdsAlertView)])
    {
        [_delegate closeAdsAlertView];
    }
    
}

- (void)clickAds
{
    [MobClick event:kHomePopAds];
    if (_delegate && [_delegate respondsToSelector:@selector(clickAdsView)])
    {
        [_delegate clickAdsView];
    }
    [self closeAdsAlertView];
}

@end
