//
//  MIFavView.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-9.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIFavView.h"

#define MIFAV_VIEW_SIZE CGSizeMake(100, 65)
#define MIFAV_IMAGEVIEW_SIZE CGSizeMake(60, 30)

@implementation MIFavView

@synthesize pageControl = _pageControl;

- (void)setup {
    
    // positioning
    self.topMargin = 0;
    self.bottomMargin = 0;
    self.leftMargin = 0;
    self.rightMargin = 0;
    
    // background
    self.backgroundColor = [UIColor whiteColor];

    // border
    self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
    self.layer.borderWidth = 0.6;
}

+ (MIFavView *)addFavBox {
    
    // basic box
    MIFavView *box = [MIFavView boxWithSize:MIFAV_VIEW_SIZE];
    box.tag = -1;
    box.backgroundColor = [UIColor whiteColor];
    
    // add the add image
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, MIFAV_IMAGEVIEW_SIZE.width, MIFAV_IMAGEVIEW_SIZE.height)];
    addView.contentMode = UIViewContentModeCenter;
    addView.alpha = 0.95;
    addView.clipsToBounds = YES;
    addView.centerX = box.width / 2;
    addView.image = [UIImage imageNamed:@"ic_favs_add"];
    [box addSubview:addView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, MIFAV_VIEW_SIZE.height - 23, MIFAV_VIEW_SIZE.width, 20)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:12.0];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = UITextAlignmentCenter;
    title.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeClip;
    title.text = @"添加关注";
    [box addSubview:title];
    
    return box;
}

+ (MIFavView *)boxWithWithTag:(NSInteger)tag data:(MIFavsModel *)model
{
    // box with photo number tag
    MIFavView *box = [MIFavView boxWithSize:MIFAV_VIEW_SIZE];
    box.tag = tag;
    box.backgroundColor = [UIColor whiteColor];
    
    // do the photo loading async, because internets
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, MIFAV_IMAGEVIEW_SIZE.width, MIFAV_IMAGEVIEW_SIZE.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.centerX = box.width / 2;
    [box addSubview:imageView];
    
    // add a loading spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.tag = MIAPP_ACTIVITY_INDICATOR_VIEW_TAG;
    spinner.center = CGPointMake(imageView.width / 2, imageView.height / 2);
    [imageView addSubview:spinner];
    [spinner startAnimating];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, MIFAV_VIEW_SIZE.height - 23, MIFAV_VIEW_SIZE.width - 10, 20)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:12.0];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.textAlignment = UITextAlignmentCenter;
    descLabel.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeClip;
    [box addSubview:descLabel];
    
    if (model.type.integerValue == 0) {
        //type:0表示店铺，1表示商城，2表示淘宝
        UIImage* taobaoShopImg = [UIImage imageNamed:@"ic_shop"];
        UIImageView *taobaoShopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MIFAV_VIEW_SIZE.width - taobaoShopImg.size.width - 3, 3, taobaoShopImg.size.width, taobaoShopImg.size.height)];
        taobaoShopImageView.image = taobaoShopImg;
        [box addSubview:taobaoShopImageView];
        descLabel.text = model.name;
    } else {
        NSString *commissionDesc;
        double commission = [model.commission doubleValue] / 100;
        if ([model.commissionType isEqualToString:@"2"]) {
            //最高返利为按元计算
            commissionDesc = [NSString stringWithFormat:@"最高返%.1f元", commission];
        } else {
            //最高返利为按比例计算
            commissionDesc = [NSString stringWithFormat:@"最高返%.1f%%", commission];
        }
        descLabel.text = commissionDesc;
    }
    
    // delete imageview
    UIImage *delImage = [UIImage imageNamed:@"ic_favs_delete"];
    UIImageView *delImageView = [[UIImageView alloc] initWithImage:delImage];
    delImageView.frame = CGRectMake(-10, -10, 36, 36);
    delImageView.hidden = YES;
    delImageView.tag = MIAPP_FAVS_DELETE_IMAGEVIEW_TAG;
    delImageView.userInteractionEnabled = YES;
    delImageView.contentMode = UIViewContentModeCenter;
    [delImageView addGestureRecognizer:box.deleter];
    [box addSubview:delImageView];
    
    return box;
}

@end
