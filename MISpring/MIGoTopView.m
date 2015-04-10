//
//  MIGoTopView.m
//  MISpring
//
//  Created by yujian on 14-12-29.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIGoTopView.h"

@implementation MIGoTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.viewWidth/2;
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 17)];
        topImageView.center = CGPointMake(self.viewWidth/2, self.viewHeight/2);
        topImageView.image = [UIImage imageNamed:@"ic_switch_top"];
        [self addSubview:topImageView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTopOfView)];
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (void)goToTopOfView
{
    if (_delegate && [_delegate respondsToSelector:@selector(goTopViewClicked)])
    {
        [_delegate goTopViewClicked];
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
