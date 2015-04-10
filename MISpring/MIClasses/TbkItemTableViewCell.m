//
//  TbkItemTableViewCell.m
//  MISpring
//
//  Created by lsave on 13-3-18.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "TbkItemTableViewCell.h"

@implementation TbkItemTableViewCell

@synthesize imageView;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize delPriceLabel;
@synthesize saveLabel;
@synthesize volumeLabel;
@synthesize nickLabel;
@synthesize creditImg;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 110, 110)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(120, 5, 198, 40)];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize: 14];
        
        priceLabel = [[RTLabel alloc] initWithFrame: CGRectMake(120, 48, 90, 20)];
        priceLabel.font = [UIFont systemFontOfSize: 14];
        priceLabel.textColor = [UIColor redColor];
        
        delPriceLabel = [[MIDeleteUILabel alloc] initWithFrame: CGRectMake(225, 48, 80, 20)];
        delPriceLabel.textColor = [UIColor lightGrayColor];
        delPriceLabel.font = [UIFont systemFontOfSize: 12];
        
        saveLabel = [[RTLabel alloc] initWithFrame: CGRectMake(120, 72, 180, 20)];
        saveLabel.font = [UIFont systemFontOfSize: 12];
        saveLabel.textColor = [UIColor lightGrayColor];
        
        volumeLabel = [[UILabel alloc] initWithFrame: CGRectMake(120, 94, 125, 20)];
        volumeLabel.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeClip;
        volumeLabel.font = [UIFont systemFontOfSize: 12];
        volumeLabel.textColor = [UIColor lightGrayColor];
        
        creditImg = [[UIImageView alloc] init];
        [creditImg setContentMode:UIViewContentModeScaleAspectFit];
                
        [self addSubview: imageView];
        [self addSubview: titleLabel];
        [self addSubview: priceLabel];
        [self addSubview: delPriceLabel];
        [self addSubview: saveLabel];
        [self addSubview: volumeLabel];
        [self addSubview: creditImg];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));

    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.3 alpha:0.2].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 0.8));
}

@end
