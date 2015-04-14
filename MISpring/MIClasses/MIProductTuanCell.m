//
//  MIProductTuanCell.m
//  MISpring
//
//  Created by 曲俊囡 on 13-12-6.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIProductTuanCell.h"
#import "MIBrandTuanDetailViewController.h"

#define ProductCellItemWidth  ((SCREEN_WIDTH - 24) / 2)

@implementation MIBrandItemView
@synthesize item;
@synthesize itemImage,selloutImg;
@synthesize price,priceOri,rmbLabel;
@synthesize discountLabel;
@synthesize description;
@synthesize indicatorView;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
        itemImage.clipsToBounds = YES;
        [itemImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImage];
        
        selloutImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 10, 60, 60)];
        selloutImg.center = itemImage.center;
        selloutImg.image = [UIImage imageNamed:@"ic_sellout"];
        [self addSubview:selloutImg];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.tag = 999;
        indicatorView.center = CGPointMake(itemImage.viewWidth / 2, itemImage.viewHeight / 2);
        [indicatorView startAnimating];
        [itemImage addSubview:indicatorView];
        
        description = [[UILabel alloc] initWithFrame:CGRectMake(5, itemImage.bottom + 8, self.viewWidth-10, 11)];
//        description.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeClip;
        description.font = [UIFont systemFontOfSize:11];
        description.textColor = [UIColor darkGrayColor];
        description.textAlignment = UITextAlignmentLeft;
        [self addSubview:description];
        
        rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, description.bottom + 8, 10, 12)];
        rmbLabel.backgroundColor = [UIColor clearColor];
        rmbLabel.textColor = [MIUtility colorWithHex:0xf73710];
        rmbLabel.font = [UIFont systemFontOfSize:12];
        rmbLabel.text = @"￥";
        [self addSubview:rmbLabel];
        
        price = [[UILabel alloc] initWithFrame:CGRectMake(15, description.bottom + 3, 80, 20)];
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [MIUtility colorWithHex:0xf73710];
        price.font = [UIFont systemFontOfSize: 16];
        [self addSubview:price];
        
        priceOri = [[MIDeleteUILabel alloc] initWithFrame: CGRectMake(price.right, description.bottom + 8, 80, 12)];
        priceOri.backgroundColor = [UIColor clearColor];
        priceOri.textColor = [UIColor lightGrayColor];
        priceOri.font = [UIFont systemFontOfSize: 12];
        priceOri.strikeThroughEnabled = YES;
        [self addSubview:priceOri];
        
        discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ProductCellItemWidth - 45, description.bottom + 5, 40, 15)];
        discountLabel.backgroundColor = [UIColor clearColor];
        discountLabel.font = [UIFont systemFontOfSize:12];
        discountLabel.textColor = [UIColor lightGrayColor];
        discountLabel.layer.cornerRadius = 1.0;
        discountLabel.clipsToBounds = YES;
        discountLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:discountLabel];
    }
    
    return self;
}

- (void)actionClicked:(id)sender{
    [MobClick event:kBrandItemClicks];
    
    //商品已经开始销售下才可以购买
    MIBrandTuanDetailViewController *vc = [[MIBrandTuanDetailViewController alloc] initWithItem:item placeholderImage:itemImage.image];
    vc.cat = self.cat;
    [vc.request setType:3];
    [vc.request setTid:item.brandId.intValue];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}


@end

@implementation MIProductTuanCell
@synthesize itemView1;
@synthesize itemView2;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        itemView1 = [[MIBrandItemView alloc] initWithFrame:CGRectMake(8, 8, ProductCellItemWidth, ProductCellItemWidth + 45)];
        [self addSubview: itemView1];
        
        itemView2 = [[MIBrandItemView alloc] initWithFrame:CGRectMake(itemView1.right + 8, itemView1.top, itemView1.viewWidth, itemView1.viewHeight)];
        [self addSubview: itemView2];
    }
    
    return self;
}

- (void)updateCellView:(MIBrandItemView *)itemView tuanModel:(MIItemModel *)model
{
    itemView.item = model;
    itemView.cat = self.cat;
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    if (nowInterval < model.startTime.integerValue) {
        itemView.selloutImg.hidden = YES;
    }else{
        if (model.status.integerValue == 1) {
            itemView.selloutImg.hidden = YES;
            itemView.rmbLabel.textColor = [MIUtility colorWithHex:0xf73710];
            itemView.price.textColor = [MIUtility colorWithHex:0xf73710];
        }
        else {
            itemView.selloutImg.hidden = NO;
            itemView.rmbLabel.textColor = [UIColor grayColor];
            itemView.price.textColor = [UIColor grayColor];
        }
    }
    NSMutableString *imgUrl = [NSMutableString stringWithString:model.img];
    [imgUrl appendString:@"_310x310.jpg"];
    [itemView.itemImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:@"img_loading_daily1"]];
    NSString *desc = [model.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    desc = [desc stringByReplacingOccurrencesOfString:@"，" withString:@","];
    itemView.description.text = [desc stringByReplacingOccurrencesOfString:@"】" withString:@"]"];

    itemView.price.text = model.price.priceValue;
    CGSize expectedSize = [itemView.price.text sizeWithFont:[UIFont systemFontOfSize:16.0]];
    itemView.price.viewWidth = expectedSize.width + 10;
    itemView.priceOri.left = itemView.price.right;
    itemView.priceOri.text = model.priceOri.priceValue;
    itemView.discountLabel.text = model.discount.discountValue;
}

@end
