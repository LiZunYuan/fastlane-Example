//
//  MIShortCutLView.h
//  MISpring
//
//  Created by 徐 裕健 on 13-10-25.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MGBox.h"

@interface MIShortCutLView : MGBox

@property (nonatomic, strong) NSDictionary * shortcutDict;

- (id)initWithSequence:(NSInteger)sequence;

@end
