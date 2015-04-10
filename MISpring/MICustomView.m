//
//  MICustomView.m
//  MISpring
//
//  Created by husor on 15-2-10.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MICustomView.h"

@implementation MICustomView
-(id)initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = [UIColor clearColor];
        _iconImg.frame = CGRectMake(16, 13, 18, 16);
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        _iconImg.userInteractionEnabled = NO;
        [self addSubview:_iconImg];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right + 12, _iconImg.top, self.viewWidth - 12 - _iconImg.right, 16)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.userInteractionEnabled = NO;
        [self addSubview:_label];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
