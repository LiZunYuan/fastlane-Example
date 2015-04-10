//
//  MIBBProductItemView.m
//  MISpring
//
//  Created by husor on 14-10-16.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBBProductItemView.h"

@implementation MIBBProductItemView
@synthesize itemImage,selloutImg;
@synthesize price,priceOriLabel,rmbLabel;
@synthesize discountLabel;
@synthesize description;
@synthesize indicatorView;
@synthesize anewImageView;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        
        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 148, 148)];
        itemImage.clipsToBounds = YES;
        [itemImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImage];
        
        selloutImg = [[UIImageView alloc] initWithFrame:CGRectMake(110, 10, 60, 60)];
        selloutImg.center = itemImage.center;
        selloutImg.image = [UIImage imageNamed:@"ic_sellout"];
        [self addSubview:selloutImg];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.tag = 999;
        indicatorView.center = CGPointMake(itemImage.viewWidth / 2, itemImage.viewHeight / 2);
        [indicatorView startAnimating];
        [itemImage addSubview:indicatorView];
        
        description = [[UILabel alloc] initWithFrame:CGRectMake(5, itemImage.bottom + 8, self.viewWidth - 10, 12)];
        description.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByClipping;
        description.font = [UIFont systemFontOfSize:12];
        description.textColor = [MIUtility colorWithHex:0x505050];
        description.textAlignment = NSTextAlignmentLeft;
        [self addSubview:description];
        
        self.anewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 158, 21, 10)];
        self.anewImageView.image = [UIImage imageNamed:@"ic_new_pic"];
        [self addSubview:self.anewImageView];
        self.anewImageView.hidden = YES;
        
        rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 176, 10, 20)];
        rmbLabel.backgroundColor = [UIColor clearColor];
        rmbLabel.textColor = [MIUtility colorWithHex:0xff0000];
        rmbLabel.font = [UIFont systemFontOfSize:12];
        rmbLabel.text = @"￥";
        [self addSubview:rmbLabel];
        
        price = [[RTLabel alloc] initWithFrame:CGRectMake(15, 172, 40, 28)];
        price.backgroundColor = [UIColor clearColor];
        price.textAlignment = RTTextAlignmentLeft;
        price.textColor = [MIUtility colorWithHex:0xff0000];
        price.font = [UIFont systemFontOfSize: 18];
        price.userInteractionEnabled = NO;
        [self addSubview:price];
        
        discountLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(50, 179, 100, 15), 5, 0)];
        discountLabel.font = [UIFont systemFontOfSize:11];
        discountLabel.textColor = [MIUtility colorWithHex:0x858585];
        discountLabel.textAlignment = NSTextAlignmentRight;
        discountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:discountLabel];
        
        priceOriLabel = [[MIDeleteUILabel alloc] initWithFrame: CGRectMake(price.right, 179, 80, 15)];
        priceOriLabel.backgroundColor = [UIColor clearColor];
        priceOriLabel.textAlignment = NSTextAlignmentLeft;
        priceOriLabel.textColor = [MIUtility colorWithHex:0xaaaaaa];
        priceOriLabel.font = [UIFont systemFontOfSize: 11];
        priceOriLabel.strikeThroughEnabled = YES;
        [self addSubview:priceOriLabel];
        
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)actionClicked:(id)sender{
    [MobClick event:@"kMartshowItem"];
    if (_selectedBlock){
        _selectedBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
