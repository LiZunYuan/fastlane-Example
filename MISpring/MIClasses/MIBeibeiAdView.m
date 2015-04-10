//
//  MIBeibeiAdView.m
//  MISpring
//
//  Created by yujian on 14-7-26.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBeibeiAdView.h"

@implementation MIBeibeiAdView
@synthesize sloganLabel,beibeiLabel,activateTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        UIImageView *beibeiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        beibeiIcon.image = [UIImage imageNamed:@"icon_beibei"];
        [self addSubview:beibeiIcon];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 5, 265, 40)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 265, 40)];
        sloganLabel.backgroundColor = [UIColor clearColor];
        sloganLabel.textColor = [UIColor whiteColor];
        sloganLabel.textAlignment = UITextAlignmentLeft;
        sloganLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        sloganLabel.font = [UIFont systemFontOfSize:14];
        sloganLabel.numberOfLines = 2;
        sloganLabel.text = [MIConfig globalConfig].beibeiAppSlogan;
        [bgView addSubview:sloganLabel];
        
        beibeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 265, 40)];
        beibeiLabel.backgroundColor = [UIColor clearColor];
        beibeiLabel.textColor = [UIColor whiteColor];
        beibeiLabel.textAlignment = UITextAlignmentLeft;
        beibeiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        beibeiLabel.font = [UIFont systemFontOfSize:14];
        beibeiLabel.numberOfLines = 2;
        beibeiLabel.text = @"贝贝特卖-亲子购物商城\n母婴品牌特卖1折起 全场包邮";
        [bgView addSubview:beibeiLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAppStore)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)goToAppStore
{
    [MobClick event:@"kAppAdClicks"];
    
    NSString *itunes = @"https://itunes.apple.com/cn/app/id%@?mt=8&uo=4";
    NSString *beibei = [NSString stringWithFormat:itunes, [MIConfig globalConfig].beibeiAppID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:beibei]];
}

- (void)animationStart
{
    activateTimer = [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                     target: self
                                                   selector: @selector(displayAwardInfo)
                                                   userInfo: nil
                                                    repeats: YES];
}

- (void)animationStop
{
    [activateTimer invalidate];
    activateTimer = nil;
}

- (void) displayAwardInfo
{
	if (sloganLabel.top != 40 && sloganLabel.top != 0) {
		sloganLabel.top = 0;
		beibeiLabel.top = 40;
	}
	
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         sloganLabel.top = (sloganLabel.top == 0 ? -40 : 0);
                         beibeiLabel.top = (beibeiLabel.top == 0 ? -40 : 0);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             sloganLabel.top = (sloganLabel.top == -40 ? 40 : 0);
                             beibeiLabel.top = (beibeiLabel.top == -40 ? 40 : 0);
                         }
                     }];
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
