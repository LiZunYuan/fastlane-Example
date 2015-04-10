//
//  MIBBMarqueeView.h
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBBMarqueeView : UIScrollView<UIScrollViewDelegate>{
    
    UILabel *_lable;
    NSTimer *timer_;
    
}

@property(nonatomic, strong) UILabel *lable;

-(void)startTimer;
-(void)stopTimer;
- (void)setLabelText:(NSString *)text;

@end
