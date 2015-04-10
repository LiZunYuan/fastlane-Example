//
//  MIMainShortView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-7-19.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMainShortView.h"

@implementation MIMainShortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titles = [[NSMutableArray alloc] initWithCapacity:4];
        _images = [[NSMutableArray alloc] initWithCapacity:4];
        _dataArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)loadData:(NSArray *)data
{
    self.data = data;
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    if (_images.count != _dataArray.count) {
        [self removeAllSubviews];
        
        [_images removeAllObjects];
        [_titles removeAllObjects];
        for (int i = 0; i < 4; i ++)
        {
            int x = i * SCREEN_WIDTH / 4;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4)];
            button.tag = i;
            button.backgroundColor = [UIColor clearColor];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.viewWidth - 42)/2, 8, 42, 42)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.centerX = button.viewWidth / 2;
            [imageView setContentMode:UIViewContentModeScaleToFill];
            imageView.userInteractionEnabled = NO;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 4, button.viewWidth, 12)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:11];
            titleLabel.textColor = [MIUtility colorWithHex:0x666666];
            titleLabel.textAlignment = UITextAlignmentCenter;
            
            
            [button addSubview:titleLabel];
            [button addSubview:imageView];
            
            [_images addObject:imageView];
            [_titles addObject:titleLabel];
        }
        
    }
    MILog(@"shortcut=%@", data);
    
    NSInteger i = 0;
    for (NSDictionary *dict in data) {
        if (i < _images.count) {
            UIImage *image;
            NSString *imgUrl = [dict objectForKey:@"img"];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imgUrl lastPathComponent] ofType:nil];
            NSData *imagedata = [NSData dataWithContentsOfFile:imagePath];
            if (imagedata) {
                image = [UIImage imageWithData:imagedata];
            } else {
                image = [UIImage imageNamed:@"default_avatar_img"];
            }
            UIImageView *imageView = [_images objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:image];
            UILabel *titleLabel = [_titles objectAtIndex:i];
            if ([dict objectForKey:@"title"])
            {
                titleLabel.text = [dict objectForKey:@"title"];
            }
            else
            {
                titleLabel.text = [dict objectForKey:@"desc"];
            }
            i++;
        }
        else
        {
            break;
        }
    }
}

- (void) entryClicked :(UIButton *) sender
{
    if (_dataArray.count == 0) {
        return;
    }
    
    @try {
        NSDictionary *dict = [self.dataArray objectAtIndex:sender.tag];
        [MINavigator openShortCutWithDictInfo:dict];
        NSString *desc = [dict objectForKey:@"title"] ? [dict objectForKey:@"title"] : [dict objectForKey:@"desc"];
        [MobClick event:kHomeShortcut label:desc];
    }
    @catch (NSException *exception) {
        MILog(@"this is a bug!!!");
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
