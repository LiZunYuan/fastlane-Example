//
//  MIWomenShortView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIWomenShortView.h"

#define NummberPerRow  4
#define ShortViewButtonWidth ((PHONE_SCREEN_SIZE.width - 16) / NummberPerRow)


@implementation MIWomenShortView


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
        int y = 0;

        for (int i = 0; i < _data.count; i ++)
        {
            int x = 8 + i % NummberPerRow * ShortViewButtonWidth;
            y = i / NummberPerRow * 83;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, ShortViewButtonWidth, 83)];
            button.tag = i;
            button.backgroundColor = [UIColor clearColor];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.viewWidth - 60)/2, 8, 60, 52)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.centerX = button.viewWidth / 2;
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            imageView.userInteractionEnabled = NO;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 4, button.viewWidth, 11)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:11];
            titleLabel.textColor = [MIUtility colorWithHex:0x666666];
            titleLabel.textAlignment = UITextAlignmentCenter;
            
            
            [button addSubview:titleLabel];
            [button addSubview:imageView];
            
            [_images addObject:imageView];
            [_titles addObject:titleLabel];
            if (i < 3){
                UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(button.viewWidth - 0.5, 8, 0.5, 75)];
                rightLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
                [button addSubview:rightLine];
            }
            if (i >= 4 && i < 7) {
                UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(button.viewWidth - 0.5, 0, 0.5, 75)];
                rightLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
                [button addSubview:rightLine];
            }
        }
        self.viewHeight = y + 83;

        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.5)];
        topLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 0.5, PHONE_SCREEN_SIZE.width, 0.5)];
        bottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:bottomLine];
        
        if (_data.count > 4)
        {
            UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(8, y, PHONE_SCREEN_SIZE.width - 16, 0.5)];
            middleLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
            [self addSubview:middleLine];
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
        [MobClick event:kNvzhuangCats label:desc];
    }
    @catch (NSException *exception) {
        MILog(@"this is a bug!!!");
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
