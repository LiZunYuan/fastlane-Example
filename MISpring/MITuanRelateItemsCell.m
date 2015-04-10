//
//  MITuanRelateItemsCell.m
//  MISpring
//
//  Created by yujian on 14-12-17.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MITuanRelateItemsCell.h"
#import "MIDeleteUILabel.h"
#import "MITuanItemModel.h"
#import "MITuanDetailViewController.h"
#import "MIBrandViewController.h"
#import "MIDeleteUILabel.h"


@implementation MITuanRelateItemsCell
@synthesize tuanItems, images, prices, priceOris, temaiImages;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, self.viewWidth, 0.5)];
        line1.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:line1];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom, self.viewWidth, 8)];
        lineView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        [self addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 12, SCREEN_WIDTH - 20, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.textColor = [MIUtility colorWithHex:0x333333];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"大家正在抢";
        [self addSubview:self.titleLabel];
        
        images = [NSMutableArray arrayWithCapacity:6];
        prices = [NSMutableArray arrayWithCapacity:6];
        priceOris = [NSMutableArray arrayWithCapacity:6];
        temaiImages = [NSMutableArray arrayWithCapacity:6];
        
        float btnWidth = 91;
        float btnHeight = 105;
        for (NSInteger i = 0; i < 2; ++i)
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                NSInteger x = 12 + j * (btnWidth + 11.5);
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, (btnHeight + 12)*i + 44, btnWidth, btnHeight)];
                button.tag = i * 3  + j;
                button.backgroundColor = [UIColor clearColor];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, btnWidth, btnWidth)];
                imageView.userInteractionEnabled = NO;
                [imageView.layer setBorderWidth:0.6]; //边框宽度
                [imageView.layer setBorderColor:[UIColor colorWithWhite:0.3 alpha:0.10].CGColor];
                [button addSubview:imageView];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, button.viewHeight - 30, 45, 10)];
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.textColor = [MIUtility colorWithHex:0xff3d00];
                priceLabel.font = [UIFont systemFontOfSize:10];
                priceLabel.left = imageView.left;
                priceLabel.top = imageView.bottom + 4;
                [button addSubview:priceLabel];
                
                MIDeleteUILabel *priceOriLabel = [[MIDeleteUILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 9)];
                priceOriLabel.textAlignment = UITextAlignmentCenter;
                priceOriLabel.right = imageView.right;
                priceOriLabel.top = imageView.bottom + 5;
                priceOriLabel.strikeThroughEnabled = YES;
                priceOriLabel.textColor = [MIUtility colorWithHex:0x999999];
                priceOriLabel.font = [UIFont systemFontOfSize:9];
                [button addSubview:priceOriLabel];
                
               UIImageView *temaiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth - 28, 0, 28, 16)];
                temaiImageView.right = imageView.right;
                temaiImageView.top = imageView.top;
                temaiImageView.hidden = YES;
                temaiImageView.clipsToBounds = YES;
                temaiImageView.image = [UIImage imageNamed:@"ic_frompinpai"];
                [temaiImageView setContentMode:UIViewContentModeScaleAspectFill];
                [button addSubview:temaiImageView];
                
                [temaiImages addObject:temaiImageView];
                [images addObject:imageView];
                [prices addObject:priceLabel];
                [priceOris addObject:priceOriLabel];
            }
        }
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake( 0, 277.5, self.viewWidth, 0.5)];
        bottomLine.backgroundColor = [MIUtility colorWithHex:0xe4e4e4];
        [self addSubview:bottomLine];
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomLine.bottom, self.viewWidth, 8)];
        bottomLineView.backgroundColor = [MIUtility colorWithHex:0xeeeeee];
        [self addSubview:bottomLineView];
    }
    
    return self;
}

- (void) actionClicked :(UIButton *) sender
{
    [MobClick event:kTuanRelateItemClicks];
    
    if (self.tuanItems) {
        @try {
            MITuanItemModel *model = [self.tuanItems objectAtIndex: sender.tag];
            if (self.type == TuanItemType)
            {
                if (model.tuanId) {
                    MITuanDetailViewController *vc = [[MITuanDetailViewController alloc] initWithItem:model placeholderImage:[UIImage imageNamed:@"default_avatar_img"]];
                    [vc.detailGetRequest setType:model.type.intValue];
                    [vc.detailGetRequest setTid:model.tuanId.intValue];
                    [[MINavigator navigator] openPushViewController:vc animated:YES];
                }
            }
            else
            {
                MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:model.aid.integerValue];
                vc.origin = model.origin.integerValue;
                [[MINavigator navigator] openPushViewController:vc animated:YES];
            }
        }
        @catch (NSException *exception) {
            MILog(@"tuan relates out of indexs");
        }
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
