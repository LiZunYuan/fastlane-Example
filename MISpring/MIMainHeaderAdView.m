//
//  MIMainHeaderAdView.m
//  MISpring
//
//  Created by husor on 15-3-24.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIMainHeaderAdView.h"
#import "MIAdService.h"

#define NOMARL_SPACE    8
#define IMAGE_HEIGHT    115 * SCREEN_WIDTH / 320


@implementation MIMainHeaderAdView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadData:(NSArray *)dataArray
{
    self.adsArray = dataArray;
    if (self.adsArray == nil || self.adsArray.count == 0) {
        return;
    }
    
    [self removeAllSubviews];
    
    NSDictionary *fAdsDict = [_adsArray objectAtIndex:0];
    if (!([[fAdsDict objectForKey:@"height"] floatValue] > 0 && [[fAdsDict objectForKey:@"width"] floatValue]>0)) {
        _imageHeight = IMAGE_HEIGHT;
    } else {
        _imageHeight = ([[fAdsDict objectForKey:@"height"] floatValue] / [[fAdsDict objectForKey:@"width"] floatValue]) * (self.viewWidth - 2 * NOMARL_SPACE);
    }
    [self refreshView:dataArray];
}

-(void)refreshView:(NSArray *)dataArray
{
    for (NSInteger i = 0; i < dataArray.count; ++i) {
        UIView *adsBacView = [[UIView alloc] initWithFrame:CGRectMake(0, NOMARL_SPACE * (i + 1) + i * _imageHeight + NOMARL_SPACE * 2 * i, self.viewWidth, _imageHeight + NOMARL_SPACE * 2)];
        adsBacView.backgroundColor = [UIColor whiteColor];
        adsBacView.tag = 9999 + i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adsClick:)];
        [adsBacView addGestureRecognizer:tapGesture];
        
        NSDictionary *adsDict = [dataArray objectAtIndex:i];
        
        UIImageView *adsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(NOMARL_SPACE, NOMARL_SPACE, self.viewWidth - 2 * NOMARL_SPACE, _imageHeight)];
        adsImageView.contentMode = UIViewContentModeCenter;
        [adsImageView sd_setImageWithURL:[NSURL URLWithString:[adsDict objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"img_loading_lunbo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image)
            {
                adsImageView.contentMode = UIViewContentModeScaleToFill;
            }
        }];
        
        [adsBacView addSubview:adsImageView];
        
        [self addSubview:adsBacView];
        
        if (i == dataArray.count - 1) {
            self.viewHeight = adsBacView.bottom;
        }
    }

}

- (void) adsClick:(UITapGestureRecognizer *)rec
{
    NSInteger index = rec.view.tag - 9999;
    
    if (self.adsArray && self.adsArray.count > index) {
        NSDictionary *adsDict = [self.adsArray objectAtIndex:index];
        [MINavigator openShortCutWithDictInfo:adsDict];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
