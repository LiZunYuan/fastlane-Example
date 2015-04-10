//
//  MIShareView.m
//  MISpring
//
//  Created by 曲俊囡 on 14-9-11.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIShareView.h"

#define LINE_COUNT  4
#define SHARE_BTN_HEIGHT    90

@interface MIShareButton : UIButton

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation MIShareButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsTouchWhenHighlighted = YES;
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 50)/2, 10, 50, 50)];
        [_iconImage setContentMode:UIViewContentModeScaleAspectFit];
        _iconImage.userInteractionEnabled = NO;
        [self addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconImage.bottom + 5, self.viewWidth, 15)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [MIUtility colorWithHex:0xaaaaaa];
        _nameLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return self;
}


@end

@implementation MIShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        if (IOS_VERSION < 7.0)
        {
            self.viewHeight = SCREEN_HEIGHT - 20;
        }
        else
        {
            self.viewHeight = SCREEN_HEIGHT;
        }
        
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.viewHeight)];
        self.alphaView.backgroundColor = [UIColor blackColor];
        self.alphaView.alpha = 0;
        [self addSubview:self.alphaView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [_alphaView addGestureRecognizer:tap];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight, PHONE_SCREEN_SIZE.width, 215)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        _eventArray = [[NSMutableArray alloc] initWithCapacity:4];
        _handleArray = [[NSMutableArray alloc] initWithCapacity:4];

    }
    return self;
}
- (void)cancelAction
{
    if (_cancelBlock)
    {
        _cancelBlock();
    }
}
- (void)loadData
{
    NSInteger btnWildth = self.viewWidth/LINE_COUNT;
    int addRow = 0;
    if (self.eventArray.count % LINE_COUNT != 0)
    {
        addRow = 1;
    }
    self.bgView.viewHeight = (self.eventArray.count/LINE_COUNT + addRow) * SHARE_BTN_HEIGHT;
    for (int i = 0; i < self.eventArray.count; i++)
    {
        NSInteger line = i/LINE_COUNT;
        NSInteger index = i%LINE_COUNT;
        
        NSDictionary *dic = [self.eventArray objectAtIndex:i];
        UIImage *iconImage = [UIImage imageNamed:[dic objectForKey:@"image"]];
        MIShareButton *button = [[MIShareButton alloc] initWithFrame:CGRectMake(btnWildth * index, SHARE_BTN_HEIGHT * line, btnWildth, SHARE_BTN_HEIGHT)];
        button.tag = i;
        button.iconImage.image = iconImage;
        button.nameLabel.text = [dic objectForKey:@"title"];
        [button addTarget:self action:@selector(entryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
    }
}

- (void)entryClicked:(id)sender
{
    if ([sender isKindOfClass:[MIShareButton class]])
    {
        MIShareButton *button = (MIShareButton *)sender;
        if (self.handleArray.count > button.tag) {
            MIShareBlock block = [self.handleArray objectAtIndex:button.tag];
            if (block) {
                block(button.tag);
            }
            [self cancelAction];
        }
    }
    
}

- (NSInteger)addButtonWithDictionary:(NSDictionary *)dic withBlock:(MIShareBlock)block
{
    [self.eventArray addObject:dic];
    [self.handleArray addObject:block];
    NSInteger index = [self.eventArray indexOfObject:dic];
    return index;
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
