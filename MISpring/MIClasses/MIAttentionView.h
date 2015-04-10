//
//  MIAttentionView.h
//  MISpring
//
//  Created by 贺晨超 on 13-10-15.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MGBox.h"
#import "MGScrollView.h"

@interface MIAttentionView : MGBox<UIScrollViewDelegate>


- (void) getFavs:(BOOL) reload :(MGScrollView *)scroller;

@end
