//
//  MIBeiBeiCell.m
//  MISpring
//
//  Created by husor on 14-10-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBeiBeiCell.h"

@implementation MIBeiBeiCell

@synthesize itemView1;
@synthesize itemView2;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        itemView1 = [[MIBeiBeiItemView alloc] initWithFrame:CGRectMake(8, 8, 148, 200)];
        [self addSubview: itemView1];
        
        itemView2 = [[MIBeiBeiItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    
    return self;
}

@end
