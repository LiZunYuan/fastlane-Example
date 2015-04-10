//
//  MIShortcutView.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIShortcutView.h"

#define SHORT_VIEW_SIZE CGSizeMake(300, 70)

@implementation MIShortcutView

- (void)setup {
    
    // positioning
    self.topMargin = 6;
    self.bottomMargin = 6;
    self.leftMargin = 10;
    self.rightMargin = 10;
    
    // background
    self.backgroundColor = [UIColor whiteColor];
}

- (id)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, SHORT_VIEW_SIZE.width, SHORT_VIEW_SIZE.height)];
    if (self) {
        [self addSplitLine:1];
        [self addSplitLine:2];
        [self addSplitLine:3];
        
        NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"ads.local.data"];
        NSData *data = [NSData dataWithContentsOfFile:adsDataPath];
        if (data.length > 0) {
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.shortcutArrayDict = [dict objectForKey:@"shortcut"];
            [self addBigImageViews:self.shortcutArrayDict];
        }
    }
    return self;
}

- (void)addSplitLine: (int)num{
    UILabel * yLine = [[UILabel alloc] initWithFrame:CGRectMake(74*num, 0, 1, SHORT_VIEW_SIZE.height)];
    yLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self addSubview:yLine];
}

- (void)addBigImageViews:(NSArray *) shortcutArrayDict{
    
    for (int btni = 0; btni < shortcutArrayDict.count; btni++) {
        NSDictionary *dict = [shortcutArrayDict objectAtIndex:btni];
        [self buildShortcutSubView:[dict objectForKey:@"desc"] image:[dict objectForKey:@"img"] tag:btni];
    }
}

- (void)buildShortcutSubView:(NSString *)name image:(NSString *)imgscr tag:(int)tag {
    
    static int i = 0;
    UIView * shortcutView = [[UIView alloc] init];
    shortcutView.frame = CGRectMake( ( i % 4 ) * 75, 0, 75, 60);
    shortcutView.tag = tag + 500;
    i++;
    
    UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClicked:)];
    [shortcutView addGestureRecognizer:loginRecoginzer];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(20, 8, 40, 40);
    imageView.centerX = shortcutView.viewWidth / 2;
    [imageView setImageWithURL:[NSURL URLWithString:imgscr] placeholderImage:[UIImage imageNamed:[imgscr lastPathComponent]]];
    [shortcutView addSubview:imageView];
    
    UILabel * title = [[UILabel alloc] init];
    title.backgroundColor = [UIColor clearColor];
    title.frame = CGRectMake(0, 48, 75, 20);
    title.textAlignment = UITextAlignmentCenter;
    title.text = name;
    title.font = [UIFont systemFontOfSize:12.0];
    title.textColor = [MIUtility colorWithHex:0x666666];
    [shortcutView addSubview:title];
    
    [self addSubview:shortcutView];
}

- (void)actionClicked:(UITapGestureRecognizer *)tapRecognizer{
    UIView *shortCutView = tapRecognizer.view;
    
    NSDictionary *dict = [_shortcutArrayDict objectAtIndex:(shortCutView.tag - 500)];
    NSString *title = [dict objectForKey:@"desc"];
    [MINavigator openShortCutWithDictInfo:dict];
    [MobClick event:kHomeShortcut label:title];
}

@end
