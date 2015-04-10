//
//  MITomorrowBrandCell.h
//  MISpring
//
//  Created by husor on 14-12-18.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITomorrowBrandItemView.h"

@interface MITomorrowBrandCell : UITableViewCell

@property (nonatomic,strong)MITomorrowBrandItemView *itemView1;
@property (nonatomic,strong)MITomorrowBrandItemView *itemView2;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
