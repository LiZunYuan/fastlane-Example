//
//  MIBrandCell.m
//  MISpring
//
//  Created by 曲俊囡 on 14-6-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandCell.h"


@implementation MIBrandCellItemView

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = MILineColor.CGColor;
        self.layer.borderWidth = 0.5;
        
        _imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 150, 142.5)];
        [self addSubview:self.imageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 20, self.viewWidth, 20)];
        bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [self addSubview:bgView];
        
        UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 10, bgView.viewHeight)];
        rmbLabel.text = @"￥";
        rmbLabel.textAlignment = NSTextAlignmentLeft;
        rmbLabel.font = [UIFont systemFontOfSize:12];
        rmbLabel.backgroundColor = [UIColor clearColor];
        rmbLabel.textColor = MIColor999999;
        [bgView addSubview:rmbLabel];
        
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, bgView.viewWidth - 24, bgView.viewHeight)];
        self.priceLabel.font = [UIFont systemFontOfSize:12];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.textColor = MIColor999999;
        [bgView addSubview:self.priceLabel];

    }
    return self;
}

@end


@implementation MIBrandCell

@synthesize shopImageView,lastImageView,shopNameLabel,discountLabel,leftView,rightView,retainTimeLabel,shopTimer;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, PHONE_SCREEN_SIZE.width, 189)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        leftView = [[MIBrandCellItemView alloc] initWithFrame: CGRectMake(8, 8, 150, 142.5)];
        [bgView addSubview:leftView];
        
        rightView = [[MIBrandCellItemView alloc] initWithFrame:CGRectMake(leftView.right + 4, leftView.top, leftView.viewWidth, leftView.viewHeight)];
        [bgView addSubview:rightView];

        UIView *discountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        discountView.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
        discountView.alpha = 0.9;
        discountView.centerX = PHONE_SCREEN_SIZE.width / 2;
        discountView.centerY = leftView.centerY;
        discountView.layer.cornerRadius = 20;
        [bgView addSubview:discountView];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_brand_more"]];
        moreImage.frame = CGRectMake(85, 15, 9, 14);
        [discountView addSubview:moreImage];
        
        discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 60, 14)];
        discountLabel.backgroundColor = [UIColor clearColor];
        discountLabel.font = [UIFont systemFontOfSize:14];
        discountLabel.textAlignment = NSTextAlignmentCenter;
        discountLabel.textColor = [MIUtility colorWithHex:0xff3d00];
        [discountView addSubview:discountLabel];
        
        _retainNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, discountLabel.bottom + 6, 60, 12)];
        _retainNumLabel.backgroundColor = [UIColor clearColor];
        _retainNumLabel.font = [UIFont systemFontOfSize:11];
        _retainNumLabel.textAlignment = NSTextAlignmentCenter;
        _retainNumLabel.textColor = MIColor999999;
        [discountView addSubview:_retainNumLabel];
        
        
//        clockImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, shopNameLabel.bottom + 2, 10, 10)];
//        clockImageView.contentMode = UIViewContentModeScaleAspectFill;
//        clockImageView.userInteractionEnabled = NO;
//        [bgView addSubview:clockImageView];
        
        shopImageView = [[UIImageView alloc] initWithFrame: CGRectMake(8, leftView.bottom + 8, 45, 22.5)];
        shopImageView.contentMode = UIViewContentModeScaleAspectFill;
        shopImageView.clipsToBounds = YES;
        shopImageView.userInteractionEnabled = NO;
        [bgView addSubview:shopImageView];
        
        shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(shopImageView.right + 8, shopImageView.top, 169, shopImageView.viewHeight)];
        shopNameLabel.backgroundColor = [UIColor clearColor];
        shopNameLabel.font = [UIFont systemFontOfSize:14];
        shopNameLabel.textColor = [MIUtility colorWithHex:0x333333];
        shopNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        shopNameLabel.userInteractionEnabled = YES;
        [bgView addSubview:shopNameLabel];
        
        lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(shopNameLabel.right + 4, 0, 22, 11)];
        lastImageView.centerY = shopNameLabel.centerY;
        lastImageView.hidden = YES;
        lastImageView.image = [UIImage imageNamed:@"ic_brand_new"];
        [bgView addSubview:lastImageView];
        
        retainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(232, shopNameLabel.top, 80, 22.5)];
        retainTimeLabel.backgroundColor = [UIColor clearColor];
        retainTimeLabel.font = [UIFont systemFontOfSize:12];
        retainTimeLabel.textAlignment = NSTextAlignmentRight;
        retainTimeLabel.textColor = [MIUtility colorWithHex:0x999999];
        [bgView addSubview:retainTimeLabel];

        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.5)];
        topLine.backgroundColor = MILineColor;
        [bgView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.viewHeight - 0.5, PHONE_SCREEN_SIZE.width, 0.5)];
        bottomLine.backgroundColor = MILineColor;
        [bgView addSubview:bottomLine];

    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [shopNameLabel.text sizeWithFont:shopNameLabel.font constrainedToSize:CGSizeMake(218, 20)];
    shopNameLabel.viewWidth = size.width;
//    lastImageView.frame = CGRectMake(shopNameLabel.right + 5 + 5, shopNameLabel.top + 11, lastImageView.viewWidth, lastImageView.viewHeight);
}

- (void)startTimer
{
    [self stopTimer];
    self.shopTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [self.shopTimer fire];
}

- (void)stopTimer
{
    if (self.shopTimer) {
        [self.shopTimer invalidate];
        self.shopTimer = nil;
    }
}
- (void)handleTimer: (NSTimer *) timer
{
    double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:self.itemModel.startTime.doubleValue];
    if (self.itemModel.endTime.doubleValue <= nowInterval) {
        retainTimeLabel.text = @"已结束";
        retainTimeLabel.textColor = [UIColor lightGrayColor];
//        self.clockImageView.image = [UIImage imageNamed:@"img_lefttime"];
        [self stopTimer];
    } else {
        if (self.itemModel.startTime.doubleValue > nowInterval)
        {
            self.retainTimeLabel.text = [beginDate stringForTimeTips2];
            self.retainTimeLabel.textColor = [MIUtility colorWithHex:0x8dbb1a];
//            self.clockImageView.image = [UIImage imageNamed:@"img_lefttime_green"];
        }
        else
        {
            double nowInterval = [[NSDate date] timeIntervalSince1970] + [MIConfig globalConfig].timeOffset;
            NSInteger intervalEndTime = self.itemModel.endTime.doubleValue - nowInterval;
//            NSInteger interval = [MIUtility calcIntervalWithEndTime:intervalEndTime andNowTime:nowInterval];
            NSInteger day = intervalEndTime / 60 / 60 / 24;
            NSInteger hour = intervalEndTime%(60 * 60 * 24)/60/60;
            NSInteger minute = intervalEndTime%(60*60)/60;
            if (day > 0) {
                retainTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld天", (long)day];
            }else if(hour > 0){
                retainTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld小时", (long)hour];
            } else{
                retainTimeLabel.text = [[NSString alloc] initWithFormat:@"剩%ld分钟", (long)minute];
            }
            self.retainTimeLabel.textColor = [UIColor lightGrayColor];
//            self.clockImageView.image = [UIImage imageNamed:@"img_lefttime"];
        }
    }
    
    CGSize expectedSize = [retainTimeLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0]];
    retainTimeLabel.viewWidth = expectedSize.width + 8;
    retainTimeLabel.left = PHONE_SCREEN_SIZE.width - expectedSize.width - 22;
//    clockImageView.left = retainTimeLabel.left - 12;
    if ([beginDate compareWithToday2] && self.itemModel.startTime.doubleValue <= nowInterval) {
//        self.clockImageView.hidden = YES;
        self.retainTimeLabel.hidden = YES;
    } else {
//        self.clockImageView.hidden = NO;
        self.retainTimeLabel.hidden = NO;
    }
}

@end
