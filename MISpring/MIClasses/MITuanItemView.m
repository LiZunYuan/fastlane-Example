//
//  MITuanItemView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanItemView.h"
#import "MITuanDetailViewController.h"
#import "MIBrandViewController.h"
#import "XGPush.h"
#import "MIBBBrandViewController.h"
#import "MIBBTuanViewController.h"

@implementation MITuanItemView

@synthesize item;
@synthesize itemImage;
@synthesize statusImage;
@synthesize labelImageView;
@synthesize temaiImageView;
@synthesize icNewImgView;
@synthesize price;
@synthesize viewsInfo;
@synthesize description;
@synthesize indicatorView;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
        itemImage.clipsToBounds = YES;
        [itemImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImage];
        
        icNewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, itemImage.bottom + 8, 20, 10)];
        icNewImgView.image = [UIImage imageNamed:@"ic_pinpai_new"];
        icNewImgView.hidden = NO;
        [self addSubview:icNewImgView];
        
        description = [[UILabel alloc] initWithFrame:CGRectMake(icNewImgView.right + 4, itemImage.bottom + 8, self.viewWidth - icNewImgView.right - 4 - 8, 10)];
        description.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByClipping;
        description.font = [UIFont systemFontOfSize:11];
        description.textColor = [MIUtility colorWithHex:0x666666];
        description.textAlignment = UITextAlignmentLeft;
        [self addSubview:description];
        description.centerY = icNewImgView.centerY;
        
        statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 10, 60, 60)];
        statusImage.center = itemImage.center;
        statusImage.hidden = YES;
        [self addSubview:statusImage];
        
        labelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 73, 65)];
        labelImageView.hidden = YES;
        labelImageView.clipsToBounds = YES;
        [labelImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:labelImageView];
        
        temaiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemImage.right - 28, 0, 28, 16)];
        temaiImageView.hidden = YES;
        temaiImageView.clipsToBounds = YES;
        temaiImageView.image = [UIImage imageNamed:@"ic_frompinpai"];
        [temaiImageView setContentMode:UIViewContentModeScaleAspectFill];
        [itemImage addSubview:temaiImageView];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.tag = 999;
        indicatorView.center = CGPointMake(itemImage.viewWidth / 2, itemImage.viewHeight / 2);
        [indicatorView startAnimating];
        [itemImage addSubview:indicatorView];
        
        price = [[RTLabel alloc] initWithFrame:CGRectMake(6, description.bottom + 8, self.viewWidth - 6, 18)];
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [MIUtility colorWithHex:0xff3d00];
        price.textAlignment = RTTextAlignmentLeft;
        price.userInteractionEnabled = NO;
        [self addSubview:price];
        
        viewsInfo = [[UILabel alloc] initWithFrame:CGRectMake(70, description.bottom + 8, 80, 11)];
        viewsInfo.centerY = price.centerY;
        viewsInfo.backgroundColor = [UIColor clearColor];
        viewsInfo.textAlignment = NSTextAlignmentRight;
        viewsInfo.textColor = [MIUtility colorWithHex:0x999999];
        viewsInfo.font = [UIFont systemFontOfSize:11];
        [self addSubview:viewsInfo];
        viewsInfo.right = self.viewWidth - 8;
        
        _adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _adView.backgroundColor = [UIColor whiteColor];
        _adView.clipsToBounds = YES;
        _adView.hidden = YES;
        [self addSubview:_adView];
        
    }
    return self;
}

- (void)actionClicked:(id)sender{
    
    if (self.type == MITuanNormal) {
        if (item.type.integerValue == MIBrand && item.aid)
        {
            MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:item.aid.intValue];
            vc.cat = self.cat;
            vc.numIid = item.numIid;
            vc.origin = item.origin.integerValue;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }
        else if(item.type.integerValue == BBMartshow){
                // 跳转贝贝品牌专场
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
//                    if (item.iid) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@&iid=%@",item.eventId,item.iid]]];
//                    }else{
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@",item.eventId]]];
//                    }
//                }else{
                    MIBBBrandViewController *vc = [[MIBBBrandViewController alloc]initWithEventId:item.eventId.integerValue];
                    vc.shopNameString = item.brand;
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
//                }
            }
        else if(item.type.integerValue == BBTuan){
                // 跳转到web详情页
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
//                    if (item.sid) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=detail&iid=%@sid=%@",item.numIid,item.sid]]];
//                    }else{
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=detail&iid=%@",item.numIid]]];
//                    }
//                }else{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.beibei.com/detail.html?iid=%@",item.numIid]];
                    MIBBTuanViewController *vc = [[MIBBTuanViewController alloc]initWithURL:url];
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
//                }
            }
        else if (item.tuanId){
            if (item.type.integerValue == MIYouPin) {
                [MobClick event:kYouPinItemClicks];
            } else {
                [MobClick event:kTuanItemClicks];
            }
            MITuanDetailViewController *vc = [[MITuanDetailViewController alloc] initWithItem:item  placeholderImage:itemImage.image];
            vc.cat = self.cat;
            [vc.detailGetRequest setType:item.type.intValue];
            [vc.detailGetRequest setTid:item.tuanId.intValue];
            [[MINavigator navigator] openPushViewController:vc animated:YES];
        }
    
    }
    else{
        if (_dic){
            [MobClick event:kMainAdsTopClicks];
            [MINavigator openShortCutWithDictInfo:_dic];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
