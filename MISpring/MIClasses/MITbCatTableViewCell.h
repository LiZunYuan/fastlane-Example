//
//  MITbCatTableViewCell.h
//  MISpring
//
//  Created by lsave on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

@interface MITbCatTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView * contView;

-(void) setCatName: (NSString *) catName;
-(void) setTags: (NSDictionary *) tags;

@end
