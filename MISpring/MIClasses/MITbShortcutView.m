//
//  MITbShortcutView.m
//  MiZheHD
//
//  Created by 徐 裕健 on 13-8-2.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbShortcutView.h"
@implementation MITbShortcutView

@synthesize titles = _titles;
@synthesize images = _images;
@synthesize urlArray = _urlArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code2
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
        
        _titles = [[NSMutableArray alloc] initWithCapacity:4];
        _images = [[NSMutableArray alloc] initWithCapacity:4];
        _urlArray = [[NSMutableArray alloc] initWithCapacity:4];
        [self addSplitLine:1];
        [self addSplitLine:2];
        [self addSplitLine:3];
        UILabel * yLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewHeight / 2, self.viewWidth, 1)];
        yLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self addSubview:yLine];
        
        for (int i = 0; i < 8; i ++) {
            int x = ( i % 4 ) * 75;
            int y = ( i / 4 ) * 70;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 75, 60)];
            button.tag = i;
            button.backgroundColor = [UIColor clearColor];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 40, 40)];
            imageView.centerX = button.viewWidth / 2;
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            imageView.userInteractionEnabled = NO;
            [button addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, 75, 20)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textColor = [MIUtility colorWithHex:0x666666];
            titleLabel.textAlignment = UITextAlignmentCenter;
     
            [button addSubview:titleLabel];
            [button addSubview:imageView];
            
            [_images addObject:imageView];
            [_titles addObject:titleLabel];
        }
    }
    return self;
}
- (void)addSplitLine: (int)num{
    UILabel * yLine = [[UILabel alloc] initWithFrame:CGRectMake(74 *num, 0, 1, self.viewHeight)];
    yLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self addSubview:yLine];
}

- (void)loadData:(NSArray *)data;
{
    NSInteger i = 0;
    for (NSDictionary *dict in data) {
        [_urlArray addObject:[dict objectForKey:@"target"]];
        
        UIImageView *imageView = [_images objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
        
        UILabel *titleLabel = [_titles objectAtIndex:i];
        titleLabel.text = [dict objectForKey:@"desc"];
        i++;
    }
    self.shortcutArrayDict = data;
}

- (void) entryClicked :(UIButton *) sender
{
    if (_titles.count == 0 || _urlArray.count == 0) {
        return;
    }
    
    @try {
        NSDictionary *dict = [_shortcutArrayDict objectAtIndex:sender.tag];
        [MINavigator openShortCutWithDictInfo:dict];
        [MobClick event:kTaobaoShortCutClicks label:[dict objectForKey:@"desc"]];
    }
    @catch (NSException *exception) {
        MILog(@"array outof index");
    }
}

@end
