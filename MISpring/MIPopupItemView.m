//
//  MIPopupItemView.m
//  MISpring
//
//  Created by husor on 15-2-10.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MIPopupItemView.h"
#import "MICustomView.h"


@implementation PopupMenuItem

+(PopupMenuItem *)itemWithIcon:(NSString *)icon desc:(NSString *)desc block:(PopupMenuSelected) block
{
    PopupMenuItem *item = [[PopupMenuItem alloc] init];
    item.icon = icon;
    item.desc = desc;
    item.block = block;
    return item;
}
@end

@implementation MIPopupItemView

@synthesize triangleImgView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [super initWithFrame:frame];
        //尖角
        triangleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 8, 5)];
        triangleImgView.backgroundColor = [UIColor clearColor];
        triangleImgView.image = [UIImage imageNamed:@"img_triangle"];
        [self addSubview:triangleImgView];
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,triangleImgView.bottom, self.viewWidth, self.viewHeight - triangleImgView.bottom)];
        _backgroundView.layer.backgroundColor = [MIUtility colorWithHex:0x444444].CGColor;
        _backgroundView.layer.cornerRadius = 3;
        [self addSubview:_backgroundView];
        _viewArray = [[NSMutableArray alloc]initWithCapacity:0];
        _viewHeigh = frame.size.height;
        _top = frame.origin.y;
        
    }
    return self;
}

-(void)setImgAndDescWithArray:(NSMutableArray *)array
{
    _popupMenuItems = array;
    if (_popupMenuItems.count > 0) {
        for (NSInteger i = 0; i< _popupMenuItems.count; i ++) {
            MICustomView *bgView = [[MICustomView alloc]initWithFrame:CGRectMake(0, i * 43, self.viewWidth, 42)];
            bgView.backgroundColor = [UIColor clearColor];
            bgView.userInteractionEnabled= YES;
            bgView.layer.cornerRadius = 3;
            PopupMenuItem *popupItem = [_popupMenuItems objectAtIndex:i];
            bgView.iconImg.image = [UIImage imageNamed:popupItem.icon];
            bgView.label.text = popupItem.desc;
            [_backgroundView  addSubview:bgView];
            [_viewArray addObject:bgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [bgView addGestureRecognizer:tap];
            // 分割线
            if (i < array.count - 1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, bgView.bottom, self.viewWidth - 16, 0.5)];
                line.backgroundColor = [MIUtility colorWithHex:0x666666];
                [_backgroundView addSubview:line];
            }
        }
    }
    
}

-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    MICustomView *tapView = (MICustomView *)tap.view;
    NSInteger index = [_viewArray indexOfObject:tapView];
    PopupMenuItem *item = [_popupMenuItems objectAtIndex:index];
    [self showSelf];
    item.block();
}

-(void)showSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = _top + _viewHeigh;
        self.alpha = 1;
    }];
    _isShowSelf = YES;
}

-(void)hideSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = _top - _viewHeigh;
        self.alpha = 0;
    }];
    _isShowSelf = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
