//
//  BBTopAdView.m
//  BeiBeiAPP
//
//  Created by yujian on 14-10-21.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITopAdView.h"

#define TOP_AD_HEIGHT   50 * SCREEN_WIDTH / 320

@interface MITopAdView()
{
}

@end

@implementation MITopAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)goAdsView:(UIGestureRecognizer*)gestureRecognizer
{
    NSInteger index = gestureRecognizer.view.tag - 10000;
    
    if (self.adsArray && self.adsArray.count > index) {
        if (self.clickEventLabel) {
            [MobClick event:_clickEventLabel];
        }
        NSDictionary *adsDict = [self.adsArray objectAtIndex:index];
        [MINavigator openShortCutWithDictInfo:adsDict];
    }
}

- (void)loadAds
{
    [self removeAllSubviews];
    if (!self.adsArray || self.adsArray.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.origin.y, self.viewWidth, 0);
        return;
    }
    
    CGFloat adHeight = TOP_AD_HEIGHT;
    NSDictionary *adsDict = [self.adsArray objectAtIndex:0];
    if ([adsDict objectForKey:@"height"] && [[adsDict objectForKey:@"height"] floatValue] > 0) {
        adHeight = ([[adsDict objectForKey:@"height"] floatValue] / [[adsDict objectForKey:@"width"] floatValue]) * SCREEN_WIDTH;
    }
    for (int i = 0; i < _adsArray.count; ++i) {
        NSDictionary *adsDict = [self.adsArray objectAtIndex:i];
        UIImageView *adsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * adHeight, self.viewWidth, adHeight)];
        adsImageView.tag = 10000 + i;
        adsImageView.contentMode = UIViewContentModeCenter;
        adsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [adsImageView sd_setImageWithURL:[NSURL URLWithString:[adsDict objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"img_loading_topbanner"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image)
            {
                adsImageView.contentMode = UIViewContentModeScaleToFill;
            }
        }];
        [adsImageView addGestureRecognizer:rec];
        [self addSubview:adsImageView];
    }
    
    self.viewHeight = _adsArray.count * adHeight;
}
@end
