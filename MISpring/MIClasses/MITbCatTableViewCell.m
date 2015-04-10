//
//  MITbCatTableViewCell.m
//  MISpring
//
//  Created by lsave on 13-4-1.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbCatTableViewCell.h"
#import "MITaobaoSearchViewController.h"

@implementation MITbCatTableViewCell

@synthesize contView = _contView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 190);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor clearColor];

        _contView = [[UIView alloc] initWithFrame: CGRectMake(15, 15, 290, 175)];
        _contView.backgroundColor = [UIColor whiteColor];
        _contView.layer.cornerRadius = 5;
        _contView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _contView.layer.borderWidth = 0.5;
                
        UILabel * titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, 100, 20)];
        titleLabel.text = @"衣服";
        titleLabel.font = [UIFont systemFontOfSize: 14];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.tag = 11;
        [_contView addSubview: titleLabel];
        
        for (int i = 0; i < 8; i++) {
            int x = 7 + 70 * fmod(i, 4);
            int y = 30 + 70 * (i > 3 ? 1 : 0);
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectMake(x, y, 65, 65)];
            imageView.tag = 81 + i;
            imageView.userInteractionEnabled = YES;
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.clipsToBounds = YES;
            
            [_contView addSubview: imageView];

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagImageClick:)];
            [imageView addGestureRecognizer:tapGesture];
            
            UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(x, y + imageView.size.height - 20, 65, 20)];
            label.font = [UIFont systemFontOfSize: 14];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
            [label setShadowColor: [UIColor blackColor]];
            [label setShadowOffset: CGSizeMake(0, -1.0)];
            label.text = @"";
            label.tag = 91 + i;
            
            
            [_contView addSubview: label];
        }
        
        [self addSubview: _contView];
    }
    return self;
}

-(void) tagImageClick: (id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    UIImageView * imageView = (UIImageView *) gesture.view;
    UILabel * tag = (UILabel *) [_contView viewWithTag: imageView.tag + 10];
    
    MITaobaoSearchViewController * vc = [[MITaobaoSearchViewController alloc] init];
    vc.keywords = tag.text;
    [[MINavigator navigator] openPushViewController: vc animated:YES];
    [MobClick event:kTaobaoTagsClicks label:tag.text];
}

-(void) setCatName: (NSString *) catName {
    UILabel * titleLabel = (UILabel *) [_contView viewWithTag: 11];
    titleLabel.text = catName;
}

-(void) setTags: (NSDictionary *) tags {
    NSArray *keys;
    int i, count;
    id key, value;
    
    keys = [tags allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [tags objectForKey: key];
        
        UILabel * tag = (UILabel *) [_contView viewWithTag: 91 + i];
        tag.text = key;
        
        UIImageView * imageView = (UIImageView *) [_contView viewWithTag: 81 + i];
        [imageView setImageWithURL:[NSURL URLWithString: [[NSString alloc] initWithFormat:@"%@_130x130.jpg", value]] placeholderImage: [UIImage imageNamed:@"tbcat_placeholder"]];
    }
}

@end
