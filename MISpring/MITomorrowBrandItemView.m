//
//  MITomorrowBrandItemView.m
//  MISpring
//
//  Created by husor on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITomorrowBrandItemView.h"
#import "MIBrandViewController.h"

@implementation MITomorrowBrandItemView
@synthesize brandLogo,brandTitle,discountLabel,itemImgView,brandModel,tipLabel;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , self.viewWidth, 160 * SCREEN_WIDTH / 320.0)];
        itemImgView.backgroundColor = [UIColor clearColor];
        itemImgView.clipsToBounds = YES;
        [itemImgView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImgView];
        
        brandLogo = [[UIImageView alloc]initWithFrame:CGRectMake(8 , itemImgView.bottom + 8, 54, 27)];
        brandLogo.backgroundColor = [UIColor clearColor];
        brandLogo.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:brandLogo];
        
        brandTitle = [[UILabel alloc]initWithFrame:CGRectMake(brandLogo.right + 6, brandLogo.top, self.viewWidth - brandLogo.right - 6, 12)];
        brandTitle.backgroundColor = [UIColor clearColor];
        brandTitle.font = [UIFont systemFontOfSize:12];
        brandTitle.textAlignment = NSTextAlignmentLeft;
        brandTitle.textColor = [MIUtility colorWithHex:0x333333];
        [self addSubview:brandTitle];
        
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(brandTitle.left, brandTitle.bottom + 6, 20, 9)];
        newImageView.image = [UIImage imageNamed:@"ic_pinpai_new"];
        [self addSubview:newImageView];
        
        discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(newImageView.right + 4, brandTitle.bottom + 5, 40,12)];
        discountLabel.font = [UIFont systemFontOfSize:10];
        discountLabel.backgroundColor = [UIColor clearColor];
        discountLabel.textColor = [MIUtility colorWithHex:0x8dbb1a];
        discountLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:discountLabel];
        
        tipLabel = [[UILabel alloc]init];
        tipLabel.frame = CGRectMake(0, itemImgView.bottom - 22, itemImgView.viewWidth, 22);
        tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        tipLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        tipLabel.textColor = [MIUtility colorWithHex:0xffffff];
        tipLabel.text = @"明日10点开抢";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];


    }
    return self;
}
- (void)actionClicked:(id)sender
{
    MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:brandModel.aid.intValue];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
