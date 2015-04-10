//
//  MITbQucikEnterTableViewCell.m
//  MISpring
//
//  Created by lsave on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbQucikEnterTableViewCell.h"


@implementation MITbQucikEnterTableViewCell

@synthesize urlDict = _urlDict;

- (void) goShoppingWithUrl:(NSString *)url title:(NSString *)title
{
    NSMutableString * strUrl = [url mutableCopy];
    NSString * outerCode = [[MIMainUser getInstance].userId stringValue];
    if (outerCode != nil && outerCode.length != 0) {
        NSRange range = NSMakeRange(0, [strUrl length]);
        [strUrl replaceOccurrencesOfString:@"unid=1" withString:[NSString stringWithFormat:@"unid=%@", outerCode] options:NSCaseInsensitiveSearch range:range];
    }
    
    NSURL *URL = [NSURL URLWithString: strUrl];
    [MINavigator openTbWebViewControllerWithURL:URL desc:[NSString stringWithFormat:@"淘宝-%@", title]];
}

- (void) entryClicked :(UIButton *) btn
{
    NSString *url = [_urlDict objectForKey: [NSString stringWithFormat: @"%d", btn.tag]];
    NSString *title;
    UILabel * label = (UILabel *) [btn viewWithTag: 99];
    if (label) {
        title = label.text;
    } 

    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self goShoppingWithUrl:url title:title];
    } else {
        __weak typeof(self) weakSelf = self;
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
            [weakSelf goShoppingWithUrl:url title:title];
        }];
        [alertView show];
    }
    
    [MobClick event:kTaobaoShortCutClicks label:label.text];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray * tags = [NSArray arrayWithObjects:@"11", @"12", @"13", @"14", nil];
        
        NSArray * titles = [[NSArray alloc] initWithObjects:@"淘宝网", @"天猫", @"聚划算", @"淘金币", nil];
        NSArray * images = [[NSArray alloc] initWithObjects:@"tbquick_taobao", @"tbquick_tmall", @"tbquick_ju", @"tbquick_mobile", nil];
                
        _urlDict = [[NSMutableDictionary alloc] initWithCapacity:8];
        [_urlDict setObject: @"http://m.taobao.com/" forKey: @"11"];

        NSString *tmallUrl = @"http://redirect.simba.taobao.com/rd?c=un&w=nonjs&f=http%3A%2F%2Fs.click.taobao.com%2Ft%3Fe%3Ds%253D3NE1c%252Bf47zBw4vFB6t2Z2iperVdZeJviK7Vc7tFgwiFRAdhuF14FMe2BClHR%252F3KZKaFSJePRPq4GZ%252FstJHrpqO6uHX6yeJUMsGG0B%252BS3taM%253D%2526m%253D2%26pid%3Dmm_35109883_0_0%26unid=1&k=7ca9e08409870ccd&p=mm_35109883_0_0";
        [_urlDict setObject: tmallUrl forKey: @"12"];
        
        NSString *juUrl = @"http://redirect.simba.taobao.com/rd?c=un&w=nonjs&f=http%3A%2F%2Fs.click.taobao.com%2Ft%3Fe%3Ds%253Dm5wf28PV%252BBBw4vFB6t2Z2iperVdZeJvioEMjVa6CPbsYX8TY%252BNEwdzCcUT%252FB1x6T8GQ1rgpBk3fDX0%252BHH2IEVT22mptMayFOtY4Qt2cZ1lWEoZg3CCauayG6hRgnAnWDgA2Dvh6cCJ4WAgXVKAaaPkHgXzhsEr2j%2526m%253D2%26pid%3Dmm_35109883_0_0%26unid=1&k=7ca9e08409870ccd&p=mm_35109883_0_0";
        [_urlDict setObject: juUrl forKey: @"13"];
        
        NSString *mobilePhoneFeeUrl = @"http://h5.m.taobao.com/vip/index.htm";
        [_urlDict setObject: mobilePhoneFeeUrl forKey: @"14"];
        
        for (int i = 0; i < [tags count]; i++) {
            
            int x = 20 + 70 * fmod(i, 4);
            int y = 10 + 90 * (i > 3 ? 1 : 0);
            
            UIButton * entry = [[UIButton alloc] initWithFrame: CGRectMake(x, y, 60, 60)];
            entry.tag = [tags[i] integerValue];
            entry.exclusiveTouch = YES;
            [entry setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"tb_index_placeholder.png"]]];
            [entry addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:entry];
            
            UIImageView * entryImage = [[UIImageView alloc] initWithFrame: CGRectMake(7, 7, 50, 50)];
            [entryImage setImage: [UIImage imageNamed: images[i]]];
            [entry addSubview: entryImage];
            
            UILabel * entryLabel = [self createEntryLabel: CGRectMake(0, 60, 60, 20)];
            entryLabel.text = titles[i];
            entryLabel.tag = 99;
            [entry addSubview:entryLabel];
        }        
    }
    return self;
}

- (UILabel *) createEntryLabel: (CGRect) frame
{
    UILabel * entryLabel = [[UILabel alloc] initWithFrame: frame];
    entryLabel.backgroundColor = [UIColor clearColor];
    entryLabel.font = [UIFont boldSystemFontOfSize: 13];
    entryLabel.textAlignment = NSTextAlignmentCenter;
    entryLabel.textColor = [UIColor grayColor];
    entryLabel.shadowColor = [UIColor whiteColor];
    entryLabel.shadowOffset = CGSizeMake(0, -1.0);
    return entryLabel;
}

@end
