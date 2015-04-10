//
//  MIWomenCatoryView.m
//  MISpring
//
//  Created by 曲俊囡 on 15/3/30.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIWomenCatoryView.h"
#define NummberPerRow  4
#define ShortViewButtonWidth ((PHONE_SCREEN_SIZE.width - 5 * 8) / NummberPerRow)


@implementation MIWomenCatoryView
- (id)initWithArray:(NSArray *)cats
{
    self = [super init];
    if (self) {
        // Initialization code
        _titles = [[NSMutableArray alloc] initWithCapacity:4];
        _images = [[NSMutableArray alloc] initWithCapacity:4];
        _buttons = [[NSMutableArray alloc] initWithCapacity:4];
        _dataArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.backgroundColor = [MIUtility colorWithHex:0xf2f2f2];
        
        self.clipsToBounds = YES;

        [self reloadContenWithCats:cats];
    }
    return self;
}

- (void)reloadContenWithCats:(NSArray *)cats
{
    self.data = cats;
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:cats];
    if (_images.count != _dataArray.count) {
        [self removeAllSubviews];
        
        [_images removeAllObjects];
        [_titles removeAllObjects];
        [_buttons removeAllObjects];
        int y = 0;
        
        for (int i = 0; i < cats.count; i ++)
        {
            int x = 8 + i % NummberPerRow * (ShortViewButtonWidth + 8);
            y = 8 + i / NummberPerRow * 83;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, ShortViewButtonWidth, 75)];
            button.tag = 100 + i;
            button.backgroundColor = [UIColor whiteColor];
            button.showsTouchWhenHighlighted = YES;
            button.layer.borderColor = MILineColor.CGColor;
            button.layer.borderWidth = 0.5;
            [button addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.viewWidth - 60)/2, 4, 60, 52)];
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
            [_buttons addObject:button];
        }
        self.viewHeight = y + 75 + 12;
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 0.5)];
        topLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 0.5, PHONE_SCREEN_SIZE.width, 0.5)];
        bottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:bottomLine];
        
    }
    MILog(@"shortcut=%@", data);
    
    NSInteger i = 0;
    for (NSDictionary *dict in cats) {
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
            if ([dict objectForKey:@"desc"])
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
- (void) showSelectedCategory
{
    for (UILabel *titleLabel in _titles)
    {
        if ([titleLabel.text isEqualToString:self.catName])
        {
            NSInteger index = [_titles indexOfObject:titleLabel];
            UIButton *button = (UIButton *)[_buttons objectAtIndex:index];
            button.layer.borderColor = MIColorNavigationBarBackground.CGColor;
        }
    }
    
}
- (void) entryClicked :(UIButton *) sender
{
    if ([_catName isEqualToString:[_titles objectAtIndex:sender.tag - 100]])
    {
        return;
    }
    for (UIButton *button in _buttons)
    {
        button.layer.borderColor = MILineColor.CGColor;
    }
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)sender;
        button.layer.borderColor = MIColorNavigationBarBackground.CGColor;
    }
    
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(selectedIndex:)]) {
            [_delegate selectedIndex:(sender.tag - 100)];
        }
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
