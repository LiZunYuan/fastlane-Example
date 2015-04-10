//
//  MITipView.h
//  MiZheHD
//
//  Created by 遇见 on 8/16/13.
//  Copyright 2013 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _RPTipType{
    MI_TIP_AUTO_DISMISS,
    MI_TIP_TAP_DISMISS,
    MI_TIP_ALERT_DISMISS,
} MITipType;

/*
 *  提示,被加到windows上,分为两种,一种1.5秒消失,一种用户点击消失
 */

@interface MITipView : UIView {
    UIImageView *_tipImageView;
    MITipType _type;
}

+ (MITipView *)showTipWithType:(MITipType)type 
              useImage:(UIImage *)tipImage 
                atRect:(CGRect)rect 
                inView:(UIView *)view;

+ (MITipView *)showFullScreenTipWithImage:(UIImage *)tipImage;

- (void)dimiss;
- (void)remove;

@property (nonatomic, retain) UIImageView *tipImageView;
@property (nonatomic, assign) MITipType type;

@end
