//
//  MIBeiBeiItemView.m
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBeiBeiItemView.h"
#import "MIBBBrandViewController.h"

@implementation MIBeiBeiItemView
@synthesize item;
@synthesize itemImage;
@synthesize statusImage;
@synthesize timeLabel;
@synthesize temaiImageView;
@synthesize icNewImgView1;
@synthesize price,priceOri;
@synthesize viewsInfo;
@synthesize description;
@synthesize indicatorView,bottomBg1,brandTitle;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 148)];
        itemImage.clipsToBounds = YES;
        [itemImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImage];
        
        statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 10, 49, 49)];
        statusImage.center = itemImage.center;
        statusImage.hidden = YES;
        [self addSubview:statusImage];
        
        temaiImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_frompinpai"]];
        temaiImageView.bounds = CGRectMake(0, 0, 28, 16);
        temaiImageView.top = itemImage.top;
        temaiImageView.right = itemImage.right;
        [self addSubview:temaiImageView];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.tag = 999;
        indicatorView.center = CGPointMake(itemImage.viewWidth / 2, itemImage.viewHeight / 2);
        [indicatorView startAnimating];
        [itemImage addSubview:indicatorView];
        
        bottomBg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, self.viewWidth, 50)];
        bottomBg1.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomBg1];
        
        icNewImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 11)];
        icNewImgView1.image = [UIImage imageNamed:@"ic_new"];
        icNewImgView1.hidden = NO;
        icNewImgView1.left = bottomBg1.left +3;
        [bottomBg1 addSubview:icNewImgView1];

        description = [[UILabel alloc] initWithFrame:CGRectMake(25, 3, 150-30, 16)];
        description.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByClipping;
        description.font = [UIFont systemFontOfSize:12];
        description.textColor = [UIColor darkTextColor];
        description.textAlignment = UITextAlignmentLeft;
        [bottomBg1 addSubview:description];
        
        price = [[RTLabel alloc] initWithFrame:CGRectMake(5, 20,100, 30)];
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [MIUtility colorWithHex:0xff0000];
        price.textAlignment = RTTextAlignmentCenter;
        price.userInteractionEnabled = NO;
        [bottomBg1 addSubview:price];
        
        viewsInfo = [[RTLabel alloc] init];
        viewsInfo.frame = CGRectMake(150-70, 32,60, 15);
        viewsInfo.backgroundColor = [UIColor clearColor];
        viewsInfo.textAlignment = RTTextAlignmentRight;
        viewsInfo.textColor = [UIColor grayColor];
        viewsInfo.font = [UIFont systemFontOfSize:11];
        [bottomBg1 addSubview:viewsInfo];
        
    }
    return self;
}

- (void)actionClicked:(id)sender{
    if ([item.eventType isEqualToString:@"show"])
    {
        MIBBBrandViewController *vc = [[MIBBBrandViewController alloc] initWithEventId:item.eventId.integerValue];
        vc.shopImageString = item.logo;
        vc.shopNameString = item.brand;
        vc.shopTitleString = item.title;
        vc.gmtBegin = item.gmtBegin.doubleValue;
        vc.gmtEnd = item.gmtEnd.doubleValue;
        [[MINavigator navigator] openPushViewController:vc animated:YES];
    }
    else if ([item.eventType isEqualToString:@"tuan"])
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@detail.html?iid=%@", [MIConfig globalConfig].beibeiURL, item.iid];
        MIWebViewController *vc = [[MIWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
        vc.webTitle = @"贝贝特卖";
        [[MINavigator navigator] openPushViewController:vc animated:YES];
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
