//
//  MIMainScrollView.m
//  MISpring
//
//  Created by husor on 14-11-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIMainScrollView.h"


typedef enum :NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection;

@interface MIMainScrollView()
{
    CameraMoveDirection direction;
}

@end

@implementation MIMainScrollView

- (void)commitTranslation:(CGPoint)translation
{
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 1)
        return;
    
    if (absX > absY ) {
        if (translation.x<0) {
            direction = kCameraMoveDirectionLeft;
            //向左滑动
        }else{
            direction = kCameraMoveDirectionRight;
            //向右滑动
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            direction = kCameraMoveDirectionUp;
            //向上滑动
        }else{
            direction = kCameraMoveDirectionDown;
            //向下滑动
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)gestureRecognizer;
        NSInteger xOffset = 0;
        CGPoint translation = [gesture translationInView:self];
        [self commitTranslation:translation];
        xOffset = self.contentOffset.x;
        if (direction == kCameraMoveDirectionRight && xOffset == 0)
        {
            return NO;
        }
    }
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
