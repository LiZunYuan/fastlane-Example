//
//  MISquareAdsView.m
//  MISpring
//
//  Created by yujian on 14-12-15.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MISquareAdsView.h"

@interface MISquareAdsView()
{
    NSArray *_modelArray;
}

@end

@implementation MISquareAdsView

- (UIImage *)imageWithUrl:(NSString *)imgUrl
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imgUrl lastPathComponent] ofType:nil];
    NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
    if (imagedata) {
        return [UIImage imageWithData:imagedata];
    } else {
        return [UIImage imageNamed:@"img_loading_activity1"];
    }
}

- (void)loadData:(NSArray *)dataArray
{
    _modelArray = dataArray;
    if (dataArray.count >= 3)
    {
        NSDictionary *leftDic = [dataArray objectAtIndex:0];
        NSString *imgUrl = [leftDic objectForKey:@"img"];
        [self.squareLeftImageView sd_setImageWithURL:[leftDic objectForKey:@"img"] placeholderImage:[self imageWithUrl:imgUrl]];
        self.squareLeftImageView.tag = 0;
        self.squareLeftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.squareLeftImageView addGestureRecognizer:loginRecoginzer1];
        
        NSDictionary *dic2 = [dataArray objectAtIndex:1];
        imgUrl = [dic2 objectForKey:@"img"];
        self.squareRightTopImageView.contentMode = UIViewContentModeCenter;
        [self.squareRightTopImageView sd_setImageWithURL:[dic2 objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"img_loading_activity2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image)
            {
                self.squareRightTopImageView.contentMode = UIViewContentModeScaleToFill;
            }
        }];
        self.squareRightTopImageView.tag = 1;
        self.squareRightTopImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.squareRightTopImageView  addGestureRecognizer:loginRecoginzer2];
        
        NSDictionary *dic3 = [dataArray objectAtIndex:2];
        imgUrl = [dic3 objectForKey:@"img"];
        [self.squareRightBottomImageView sd_setImageWithURL:[dic3 objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"img_loading_activity2"]];
        self.squareRightBottomImageView.tag = 2;
        self.squareRightBottomImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *loginRecoginzer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAdsView:)];
        [self.squareRightBottomImageView addGestureRecognizer:loginRecoginzer3];
        
    }
}

- (void)goAdsView:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    if (_modelArray.count > imageView.tag) {
        NSDictionary *dict = [_modelArray objectAtIndex:imageView.tag];
        
        [MobClick event:kHomeThreeAds label:[dict objectForKey:@"title"]];
        
        [MINavigator openShortCutWithDictInfo:dict];
    }
}

@end
