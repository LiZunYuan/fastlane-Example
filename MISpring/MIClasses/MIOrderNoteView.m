//
//  MIOrderNoteView.m
//  MISpring
//
//  Created by Yujian Xu on 13-3-19.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIOrderNoteView.h"

@implementation MIOrderNoteView
@synthesize noteImage = _noteImage;
@synthesize noteTile = _noteTile;
@synthesize noteButton = _noteButton;
@synthesize actionTip = _actionTip;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildNoteImage];
        [self buildNoteTile];
        [self buildNoteButton];
        [self buildNoteActionTip];
    }
    return self;
}

- (void) buildNoteImage
{
    UIImage *image = [UIImage imageNamed:@"order_not_found"];
    _noteImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - image.size.width) / 2, 100, image.size.width, image.size.height)];
    _noteImage.image = image;
    [self addSubview:_noteImage];
}

- (void) buildNoteTile
{
    _noteTile = [[RTLabel alloc] initWithFrame:CGRectMake(10, _noteImage.bottom + 10, SCREEN_WIDTH - 20, 50)];
    _noteTile.backgroundColor = [UIColor clearColor];
    _noteTile.textAlignment = RTTextAlignmentCenter;
    _noteTile.font = [UIFont systemFontOfSize: 16.0];
    _noteTile.textColor = [UIColor lightGrayColor];
    _noteTile.lineBreakMode = kCTLineBreakByWordWrapping;
//    _noteTile.shadowColor = [UIColor whiteColor];
//    _noteTile.shadowOffset = CGSizeMake(0, -0.8);
    [self addSubview:_noteTile];
}

- (void) buildNoteButton
{
    _noteButton = [[MICommonButton alloc] initWithFrame:CGRectMake(20, _noteTile.bottom + 10, 280, 36)];
    _noteButton.centerX = SCREEN_WIDTH / 2;
    [self addSubview:_noteButton];
}

- (void) buildNoteActionTip
{
    UIImage *image = [UIImage imageNamed:@"not_found_tip"];
    _actionTip = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - image.size.width) / 2 + 35, 0, image.size.width, image.size.height)];
    _actionTip.image = image;
    [self addSubview:_actionTip];
    _actionTip.hidden = YES;
}

@end
