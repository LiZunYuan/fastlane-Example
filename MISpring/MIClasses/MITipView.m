//
//  MITipView.m
//  MiZheHD
//
//  Created by 遇见 on 8/16/13.
//  Copyright 2013 Husor Inc. All rights reserved.
//

#import "MITipView.h"
#import "MIAppDelegate.h"

@implementation MITipView

@synthesize tipImageView = _tipImageView;
@synthesize type = _type;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)dealloc{
    self.tipImageView = nil;
}

+ (MITipView *)showTipWithType:(MITipType)type 
              useImage:(UIImage *)tipImage 
                atRect:(CGRect)rect 
                inView:(UIView *)view{

    MITipView *tipView = [[MITipView alloc] initWithFrame:view.bounds];
    tipView.type = type;
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithImage:tipImage];
    tipImageView.frame = rect;
    tipView.tipImageView = tipImageView;
    [tipView addSubview:tipView.tipImageView];
    
    [view addSubview:tipView];
    [view bringSubviewToFront:tipView];
    
    tipView.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    tipView.alpha = 1;
    [UIView commitAnimations];
    
    if (type == MI_TIP_AUTO_DISMISS) {
        [tipView performSelector:@selector(dimiss) withObject:nil afterDelay:3];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:tipView action:@selector(dimiss)];
    [tipView addGestureRecognizer:tapRecognizer];
    
    
    return tipView;
}


+ (MITipView *)showFullScreenTipWithImage:(UIImage *)tipImage{
    MIAppDelegate* delegate = (MIAppDelegate*)[[UIApplication sharedApplication] delegate];
    CGRect frameInView = CGRectMake(0, 0, tipImage.size.width, tipImage.size.height);
    
    return [MITipView showTipWithType:MI_TIP_AUTO_DISMISS
                         useImage:tipImage
                           atRect:frameInView 
                           inView:delegate.window];
}

- (void)dimiss{
    
    self.userInteractionEnabled = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(remove)];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void)remove{
    [self removeFromSuperview];
}

@end
