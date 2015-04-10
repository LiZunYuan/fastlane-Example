//
//  MIBrandTuanItemCell.h
//  MISpring
//
//  Created by husor on 14-12-12.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBrandTuanItemView.h"
#import "MIBrandItemModel.h"

@interface MIBrandTuanItemCell : UITableViewCell
@property(nonatomic,strong)MIBrandTuanItemView *itemView1;
@property(nonatomic,strong)MIBrandTuanItemView *itemView2;
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
