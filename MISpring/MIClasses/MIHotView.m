//
//  MIHotView.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIHotView.h"
#import "MIDeleteUILabel.h"

#define HOT_VIEW_SIZE CGSizeMake(300, 170)

@implementation MIHotView

@synthesize hotView = _hotView;
@synthesize hotItemNum = _hotItemNum;

- (void)setup {
    
    // positioning
    self.topMargin = 10;
    self.bottomMargin = 10;
    self.leftMargin = 10;
    self.rightMargin = 10;
    
    // background
    self.backgroundColor = [UIColor whiteColor];
}

- (id)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, HOT_VIEW_SIZE.width, HOT_VIEW_SIZE.height)];
    
    if (self) {
        
        _hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 170)];
        _hotView.backgroundColor = [UIColor whiteColor];
        
        RTLabel * titleLabel = [[RTLabel alloc] init];
        titleLabel.frame = CGRectMake(5, 5, 290, 20);
        titleLabel.text = [[NSString alloc] initWithFormat:@"<font size=14.0 color='#000000'>10元热卖</font> <font size=12.0 color='#999999'>每天10:00开抢 售完恢复原价</font>"];
        
        [_hotView addSubview:titleLabel];
        
        [self addSubview:_hotView];
        _hotItemNum = 0;
        
        [self buildHotItem: @"商品名" image: @"hot_malls_split" price: @"9.9" oldprice: @"59.0"];
        [self buildHotItem: @"商品名" image: @"hot_malls_split" price: @"9.9" oldprice: @"59.0"];
        [self buildHotItem: @"商品名" image: @"hot_malls_split" price: @"9.9" oldprice: @"59.0"];
    }
    
    return self;
}

- (void) buildHotItem: (NSString *) name image:(NSString *)imgscr price:(NSString *) price oldprice:(NSString *) oldprice
{
    UIView * hotItemView = [[UIView alloc] init];
    hotItemView.frame = CGRectMake(9 * (_hotItemNum + 1) + 88 * _hotItemNum, 30, 88, 88);
    
    UILabel * hotItemTitle = [[UILabel alloc] init];
    hotItemTitle.frame = CGRectMake(0, 95, 88, 18);
    hotItemTitle.text = name;
    hotItemTitle.font = [UIFont systemFontOfSize:12.0];
    
    UILabel * hotItemPrice = [[UILabel alloc] init];
    hotItemPrice.frame = CGRectMake(0, 113, 88, 18);
    hotItemPrice.text = [NSString  stringWithFormat:@"%@元" , price];
    hotItemPrice.font = [UIFont systemFontOfSize:12.0];
    hotItemPrice.textColor = [MIUtility colorWithHex:0x333333];
    
    MIDeleteUILabel * hotItemOldPrice = [[MIDeleteUILabel alloc] init];
    hotItemOldPrice.frame = CGRectMake(0, 113, 88, 18);
    hotItemOldPrice.text = [NSString stringWithFormat:@"%@元" , oldprice];
    hotItemOldPrice.font = [UIFont systemFontOfSize:12.0];
    hotItemOldPrice.textColor = [MIUtility colorWithHex:0x999999];
    hotItemOldPrice.textAlignment = UITextAlignmentRight;
    hotItemOldPrice.backgroundColor = [UIColor clearColor];
    [hotItemOldPrice setStrikeThroughEnabled: TRUE];
    
    UIImageView * hotItemImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgscr]];
    hotItemImg.frame = CGRectMake(0, 0, 88, 88);
    
    [hotItemView addSubview:hotItemPrice];
    [hotItemView addSubview:hotItemOldPrice];
    [hotItemView addSubview:hotItemTitle];
    [hotItemView addSubview:hotItemImg];
    
    _hotItemNum++;
    [_hotView addSubview:hotItemView];
}

@end
