//
//  MITbkItemPicsCell.m
//  MISpring
//
//  Created by 徐 裕健 on 13-9-27.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MITbkItemPicsCell.h"

#define kImageView 99

@implementation MITbkItemPicsCell
@synthesize itemImgs;
@synthesize itemTitle;
@synthesize picScrollView;
@synthesize popupImageView = _popupImageView;
@synthesize popupImageViewContainer = _popupImageViewContainer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        picScrollView = [[UIScrollView alloc] init];
        picScrollView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, 180);
        picScrollView.delegate = self;
        picScrollView.showsHorizontalScrollIndicator = NO;
        picScrollView.showsVerticalScrollIndicator = NO;
        picScrollView.bounces = NO;
        picScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:picScrollView];
        
        itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 20)];
        itemTitle.backgroundColor = [UIColor clearColor];
        itemTitle.font = [UIFont systemFontOfSize:14.0];
        itemTitle.textColor = [UIColor whiteColor];
        itemTitle.textAlignment = UITextAlignmentCenter;
        itemTitle.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [itemTitle setShadowColor: [UIColor blackColor]];
        [itemTitle setShadowOffset: CGSizeMake(0, -1.0)];
        [self addSubview:itemTitle];
    }
    return self;
}

#pragma mark - 预览大图

-(void) cellImageClick :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    UIImageView * imageView = (UIImageView *) gesture.view;
    
//    NSString *picUrl = [(NSDictionary *)[self.itemImgs objectAtIndex:imageView.tag] objectForKey:@"url"];
//    NSURL * url = [NSURL URLWithString: [NSString stringWithFormat:@"%@_460x460.jpg", picUrl]];
    
    [self setViewImageWithURL: nil view:imageView];
}


- (void) dismissImageView {
    
    [UIView transitionWithView:self.window
                      duration:.35
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [_popupImageViewContainer setAlpha:0];
                        [_popupImageView setAlpha:0];
                    }
                    completion:^(BOOL finished){
                        [_popupImageView removeFromSuperview];
                        _popupImageView = nil;
                        [_popupImageViewContainer removeFromSuperview];
                        _popupImageViewContainer = nil;
                        
                    }];    
}

- (void) setViewImageWithURL: (NSURL *) largeImage view:(UIImageView *)origin {
    
    _popupImageViewContainer = [[UIView alloc] initWithFrame:self.window.bounds];
    [_popupImageViewContainer setBackgroundColor:[UIColor colorWithWhite:0.01 alpha:0.90]];
    [_popupImageViewContainer setAlpha:0];
    [self.window addSubview:_popupImageViewContainer];
    
    CGRect bounds = [origin convertRect:origin.bounds toView:_popupImageViewContainer];
    
    //Place image in UIImageView with frame transformed from tableview
    _popupImageView = [[UIImageView alloc] initWithImage:origin.image];
    _popupImageView.contentMode = UIViewContentModeScaleAspectFit;
    _popupImageView.clipsToBounds = YES;
    _popupImageView.tag = kImageView;
    [_popupImageView setFrame:bounds];
    [_popupImageView setAlpha:0];
    [_popupImageViewContainer addSubview:_popupImageView];
    
    [UIView transitionWithView:self.window
                      duration:.5
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        
                        [_popupImageView setAlpha:1];
                        [_popupImageViewContainer setAlpha:1];
                    }
                    completion:^(BOOL finished){
                        [UIView transitionWithView:self.window
                                          duration:.2
                                           options:UIViewAnimationOptionCurveEaseOut
                                        animations:^{
                                            _popupImageView.contentMode = UIViewContentModeScaleAspectFit;
                                            [_popupImageView setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
                                            [_popupImageView setImageWithURL: largeImage placeholderImage: [_popupImageView image]];
                                            
                                        }
                         //Once animation is complete, we remove the image and place it in a scrollview so users can zoom
                                        completion:^(BOOL finished){
                                            UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:_popupImageViewContainer.bounds];
                                            scroll.userInteractionEnabled = YES;
                                            scroll.maximumZoomScale = 2.0;
                                            scroll.minimumZoomScale = 0.99999;
                                            scroll.bouncesZoom = YES;
                                            scroll.delegate = self;
                                            [_popupImageView removeFromSuperview];
                                            [scroll addSubview:_popupImageView];
                                            [_popupImageView setUserInteractionEnabled:YES];
                                            //Users can dismiss the popup through the tapping gesture
                                            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageView)];
                                            [scroll addGestureRecognizer:tapGesture];
                                            [_popupImageViewContainer addSubview:scroll];
                                        }];
                    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *imageView = [scrollView viewWithTag:kImageView];
    if (imageView) {
        return imageView;
    }
    return nil;
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    //Close the imageview if the user tries to zoom out, this is optional
    UIView *view99 = [scrollView viewWithTag:kImageView];
    if (view99 && view == view99) {
        if (scale < 1) {
            //[self dismissImageView];
            [scrollView setZoomScale:1 animated:YES];
        }
    }
}

@end
