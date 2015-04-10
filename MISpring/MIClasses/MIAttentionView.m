//
//  MIAttentionView.m
//  MISpring
//
//  Created by 贺晨超 on 13-10-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIAttentionView.h"
#import "MIFavView.h"
#import "MIAddFavViewController.h"

#define ATTENTION_VIEW_SIZE CGSizeMake(300, 0)

@implementation MIAttentionView

@synthesize favsArray = _favsArray;

- (void)setup {
    
    // positioning
    self.topMargin = 10;
    self.bottomMargin = 10;
    self.leftMargin = 10;
    self.rightMargin = 10;
    
    // background
    self.backgroundColor = [UIColor whiteColor];
}

- (id)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, ATTENTION_VIEW_SIZE.width, ATTENTION_VIEW_SIZE.height)];
    
    if (self) {
        
        _favsArray = [[NSMutableArray alloc] initWithCapacity:20];
        
        //        [self addSubview: [self addBox]];
        
//        self.grid = [MGBox boxWithSize:self.size];
//        self.grid.contentLayoutMode = MGLayoutGridStyle;
//        [self.boxes addObject:self.grid];
        
        
//        [self.grid.boxes addObject:[self addBox]];
        
    }
    
    return self;
}





- (MGBox *)favBoxWithTag:(NSInteger)tag {

    // make the fav box
    MIFavsModel *model = [_favsArray objectAtIndex:tag];
    MIFavView *box = [MIFavView boxWithWithTag:tag data:model];

    // remove the box when tapped
    __weak typeof(MIFavView) *wbox = box;
    box.onTap = ^{
        MILog(@"fav box");
        [self actionFavsClicked:wbox];
    };

    if ([model.deletable boolValue]) {
        box.onDelete = ^{
            [CATransaction begin];

            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.fromValue=[NSNumber numberWithFloat:1.0];
            animation.toValue=[NSNumber numberWithFloat:0.0];
            animation.duration=0.2;
            animation.repeatCount=0;
            animation.autoreverses=NO;
            animation.removedOnCompletion=NO;
            animation.fillMode=kCAFillModeForwards;

            [CATransaction setCompletionBlock:^{
//                DBHelper *helper = [DBHelper getInstance];
//                [helper delFavs:[_favsArray objectAtIndex:wbox.tag]];
//
                MGBox *section = (id)wbox.parentBox;
//
//                // remove
                [section.boxes removeObject:wbox];
//
//                // animate
                [section layoutWithSpeed:0.3 completion:nil];
//                [self.scroller layoutWithSpeed:0.3 completion:nil];
            }];
            [[wbox layer] addAnimation:animation forKey:@"transtionScaleZeroKey"];
            [CATransaction commit];
        };
    }

    return box;
}




@end
