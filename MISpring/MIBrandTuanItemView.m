//
//  MIBrandItemView.m
//  MISpring
//
//  Created by husor on 14-12-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIBrandTuanItemView.h"
#import "MIBrandViewController.h"
#import "MIBBBrandViewController.h"

@implementation MIBrandTuanItemView
@synthesize brandLogo,brandTitle,discountLabel,itemImgView,brandModel,temaiImgView;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.15].CGColor;
        self.layer.borderWidth = .6;
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , self.viewWidth, 160)];
        itemImgView.backgroundColor = [UIColor clearColor];
        itemImgView.clipsToBounds = YES;
        [itemImgView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:itemImgView];
        
        temaiImgView = [[UIImageView alloc] initWithFrame:CGRectMake(itemImgView.right - 28, 0, 28, 16)];
        temaiImgView.hidden = YES;
        temaiImgView.clipsToBounds = YES;
        temaiImgView.image = [UIImage imageNamed:@"img_mark_beibei"];
        [temaiImgView setContentMode:UIViewContentModeScaleAspectFill];
        [itemImgView addSubview:temaiImgView];

        
        brandLogo = [[UIImageView alloc]initWithFrame:CGRectMake(5 , 0, 50, 25)];
        brandLogo.top = itemImgView.bottom + (self.viewHeight - itemImgView.bottom - 25) / 2;
        brandLogo.backgroundColor = [UIColor clearColor];
        brandLogo.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:brandLogo];
        
        brandTitle = [[UILabel alloc]initWithFrame:CGRectMake(brandLogo.right + 5, brandLogo.top, self.viewWidth - brandLogo.right - 5, 12)];
        brandTitle.backgroundColor = [UIColor clearColor];
        brandTitle.font = [UIFont systemFontOfSize:12];
        brandTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:brandTitle];
        
        discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(brandLogo.right + 5, brandTitle.bottom + 3, 40,12)];
        discountLabel.font = [UIFont systemFontOfSize:10];
        discountLabel.backgroundColor = [UIColor clearColor];
        discountLabel.textColor = [MIUtility colorWithHex:0x999999];
        discountLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:discountLabel];
        

    }
    return self;
}

//- (void)setIsEditing:(BOOL)isEditing
//{
//    _isEditing = isEditing;
//    if (_isEditing)
//    {
//        _deleteView.hidden = NO;
//    }
//    else
//    {
//        _deleteView.hidden = YES;
//    }
//}

- (void)actionClicked:(id)sender
{
    if (brandModel.type.integerValue == BBMartshowItem) {
        // 跳转贝贝品牌专场
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"beibeiapp://"]]) {
//            if (brandModel.iid) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@iid=%@",brandModel.eventId,brandModel.iid]]];
//            }else{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"beibeiapp://action?target=martshow&mid=%@",brandModel.eventId]]];
//            }
//        }else{
            MIBBBrandViewController *vc = [[MIBBBrandViewController alloc]initWithEventId:brandModel.eventId.integerValue];
            vc.shopNameString = brandModel.sellerNick;
            [[MINavigator navigator] openPushViewController:vc animated:YES];
//        }
    }else{
        MIBrandViewController *vc = [[MIBrandViewController alloc] initWithAid:brandModel.aid.intValue];
        [[MINavigator navigator] openPushViewController:vc animated:YES];
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
