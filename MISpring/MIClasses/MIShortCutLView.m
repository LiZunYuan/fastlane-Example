//
//  MIShortCutLView.m
//  MISpring
//
//  Created by 徐 裕健 on 13-10-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIShortCutLView.h"
#import "MIZhiMainViewController.h"

#define SHORT_VIEW_SIZE CGSizeMake(147, 80)

@implementation MIShortCutLView
@synthesize shortcutDict;

- (void)setup {
    
    // positioning
    self.topMargin = 10;
    self.rightMargin = 6;
    
    // background
    self.backgroundColor = [UIColor whiteColor];
}

- (id)initWithSequence:(NSInteger)sequence{
    
    self = [super initWithFrame:CGRectMake(0, 0, SHORT_VIEW_SIZE.width, SHORT_VIEW_SIZE.height)];
    if (self) {
        NSString *adsDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"ads.local.data"];
        NSData *data = [NSData dataWithContentsOfFile:adsDataPath];
        if (data.length > 0) {
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.shortcutDict = [[dict objectForKey:@"mizhe_shortcut"] objectAtIndex:sequence];
            [self buildShortcutSubView];
        }
        
        UITapGestureRecognizer *loginRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClicked:)];
        [self addGestureRecognizer:loginRecoginzer];
    }
    return self;
}

- (void)buildShortcutSubView {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
    imageView.centerY = SHORT_VIEW_SIZE.height / 2;
    NSString *imgUrl = [self.shortcutDict objectForKey:@"img"];
    [imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:[imgUrl lastPathComponent]]];
    [self addSubview:imageView];
    
    NSString *desc = [self.shortcutDict objectForKey:@"desc"];
    NSArray *descs = [desc componentsSeparatedByString:@","];
    
    @try {
        UILabel * title = [[UILabel alloc] init];
        title.frame = CGRectMake(70, 20, 70, 15);
        title.text = [descs objectAtIndex:0];
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = [UIColor darkGrayColor];
        [self addSubview:title];
        
        UILabel * subTitle1 = [[UILabel alloc] init];
        subTitle1.backgroundColor = [UIColor clearColor];
        subTitle1.frame = CGRectMake(70, 35, 70, 20);
        subTitle1.text = [descs objectAtIndex:1];
        subTitle1.font = [UIFont systemFontOfSize:10.0];
        subTitle1.textColor = [UIColor lightGrayColor];
        [self addSubview:subTitle1];
        
        UILabel * subTitle2 = [[UILabel alloc] init];
        subTitle2.backgroundColor = [UIColor clearColor];
        subTitle2.frame = CGRectMake(70, 48, 70, 20);
        subTitle2.text = [descs objectAtIndex:2];
        subTitle2.font = [UIFont systemFontOfSize:10.0];
        subTitle2.textColor = [UIColor lightGrayColor];
        [self addSubview:subTitle2];
    }
    @catch (NSException *exception) {
        MILog(@"bad paras");
    }

}

- (void)actionClicked:(UITapGestureRecognizer *)tapRecognizer{    
    NSString *desc = [self.shortcutDict objectForKey:@"desc"];
    [MINavigator openShortCutWithDictInfo:self.shortcutDict];
    [MobClick event:kHomeShortcut label:[desc substringToIndex:[desc rangeOfString:@","].location]];
}

@end
