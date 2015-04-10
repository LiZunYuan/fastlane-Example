//
//  MITuanHeaderView.m
//  MISpring
//
//  Created by husor on 15-3-18.
//  Copyright (c) 2015年 Husor Inc. All rights reserved.
//

#import "MITuanHeaderView.h"
#import "MITuanHotItemModel.h"
#import "MIHotRecommendView.h"
#import "MITuanDetailViewController.h"
#import "MIListTableViewController.h"
#define SCROLL_VIEW_HEIGHT  124
#define NOMAL_SPACE                 8
#define IMAGEVIEW_WIDTH           280
#define SCROLL_VIEW_WIDTH          (NOMAL_SPACE + IMAGEVIEW_WIDTH)
#define RECOMMEND_VIEW_WIDTH    (SCREEN_WIDTH / 3.0)
#define RECOMMEND_IMG_HEIGHT    (SCREEN_WIDTH * 87 / 320.0)


@interface MITuanHeaderView()

@property (nonatomic, strong) UIImageView *moreRecommendImg;
@property (nonatomic, strong) UILabel *moreLabel;

@end

@implementation MITuanHeaderView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _currentHeight = 0;
        _topAdView  = [[MITopAdView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
        [self addSubview:_topAdView];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _topAdView.bottom, self.viewWidth, 198)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        _recommendBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 44)];
        _recommendBgView.backgroundColor = [UIColor clearColor];
        _recommendBgView.userInteractionEnabled = YES;
        _recommendBgView.clipsToBounds = YES;
        [_bgView addSubview:_recommendBgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToRecommendVC)];
        [_recommendBgView addGestureRecognizer:tap];
        
        UIImageView *tuanHotImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_10yuan_hot"]];
        tuanHotImg.backgroundColor = [UIColor clearColor];
        tuanHotImg.frame = CGRectMake(12, 12, 20, 20);
        tuanHotImg.userInteractionEnabled = NO;
        [_recommendBgView addSubview:tuanHotImg];
        
        UILabel *baokuanLabel =[[UILabel alloc]initWithFrame:CGRectMake(tuanHotImg.right + 4, 12, 100, 20)];
        baokuanLabel.backgroundColor = [UIColor clearColor];
        baokuanLabel.textColor = [MIUtility colorWithHex:0x333333];
        baokuanLabel.font = [UIFont systemFontOfSize:14];
        [_recommendBgView addSubview:baokuanLabel];
        _baokuanLabel = baokuanLabel;
        
        UIImageView *moreRecommendImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_hot_more"]];
        moreRecommendImg.backgroundColor = [UIColor clearColor];
        moreRecommendImg.bounds = CGRectMake(0, 0, 11, 11);
        moreRecommendImg.left = _recommendBgView.viewWidth - 11 - 12;
        moreRecommendImg.centerY = _recommendBgView.centerY;
        [_recommendBgView addSubview:moreRecommendImg];
        _moreRecommendImg = moreRecommendImg;
        
        UILabel *moreLabel = [[UILabel alloc]init];
        moreLabel.backgroundColor = [UIColor clearColor];
        moreLabel.bounds = CGRectMake(0, 0, 50, 11);
        moreLabel.text = @"更多";
        moreLabel.font = [UIFont systemFontOfSize:11];
        moreLabel.textAlignment = NSTextAlignmentRight;
        moreLabel.textColor = [MIUtility colorWithHex:0x666666];
        moreLabel.centerY = moreRecommendImg.centerY;
        moreLabel.right = moreRecommendImg.left - 4;
        [_recommendBgView addSubview:moreLabel];
        _moreLabel = moreLabel;
        
        _tuanHeaderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(NOMAL_SPACE, _recommendBgView.bottom, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT)];
        _tuanHeaderScroll.clipsToBounds = NO;
        _tuanHeaderScroll.scrollsToTop = NO;
        _tuanHeaderScroll.backgroundColor = [UIColor whiteColor];
        _tuanHeaderScroll.delegate = self;
        _tuanHeaderScroll.showsHorizontalScrollIndicator = NO;
        _tuanHeaderScroll.showsVerticalScrollIndicator = NO;
        _tuanHeaderScroll.pagingEnabled = YES;
        _tuanHeaderScroll.bounces = NO;
        [_bgView addSubview:_tuanHeaderScroll];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _tuanHeaderScroll.bottom + 12, 100, 6)];
        _pageControl.enabled = NO;
        _pageControl.currentPage = 0;
        _pageControl.centerX = self.centerX;
        _pageControl.pageIndicatorTintColor = [MIUtility colorWithHex:0xe4e4e4];
        _pageControl.currentPageIndicatorTintColor = [MIUtility colorWithHex:0xFF8C24];
        [_bgView addSubview:_pageControl];
        
        _imageBgView = [[UIView alloc]initWithFrame:CGRectZero];
        _imageBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageBgView];
        
    }
    return self;
}

- (void)refreshViews {
    CGFloat currentHeight = 0;
    BOOL hasTop = NO;
    
    // 更多选项
    if (self.tuanHotTag == nil || [self.tuanHotTag isEqualToString:@""]) {
        _moreLabel.hidden = YES;
        _moreRecommendImg.hidden = YES;
    } else {
        _moreLabel.hidden = NO;
        _moreRecommendImg.hidden = NO;
    }
    
    // 添加广告
    if (self.adsArray && self.adsArray.count > 0) {
        _topAdView.hidden = NO;
        _topAdView.adsArray = self.adsArray;
        _topAdView.frame = CGRectMake(0, 0, self.viewWidth, 50 * _adsArray.count);
        [_topAdView loadAds];
        
        currentHeight = 50 * _adsArray.count;
        hasTop = YES;
    } else {
        _topAdView.hidden = YES;
    }
    
    // 添加爆款推荐
    if (self.hotItems && self.hotItems.count > 0) {
        if (hasTop) {
            currentHeight += 8;
        }
        
        _bgView.top = currentHeight;
        _bgView.hidden = NO;
        
        [_tuanHeaderScroll removeAllSubviews];
        _tuanHeaderScroll.hidden = NO;
        _tuanHeaderScroll.contentSize = CGSizeMake(NOMAL_SPACE + SCROLL_VIEW_WIDTH * (_hotItems.count + 2), 0);
        _pageControl.numberOfPages = _hotItems.count;
        MITuanHotItemModel *model = nil;
        for (int i = 0; i < _hotItems.count + 2; i ++) {
            if (i == 0) {
                model = [_hotItems lastObject];
            }else if (i == _hotItems.count + 1) {
                model = [_hotItems firstObject];
            }else{
                model = [_hotItems objectAtIndex:i - 1];
            }
            
            MIHotRecommendView *view = [[[NSBundle mainBundle] loadNibNamed:@"MIHotRecommendView" owner:self options:nil] objectAtIndex:0];
            view.userInteractionEnabled = YES;
            view.clipsToBounds = YES;
            view.frame = CGRectMake(SCROLL_VIEW_WIDTH *i, 0, 280, 123);
            [_tuanHeaderScroll addSubview:view];
            view.layer.cornerRadius = 3;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [MIUtility colorWithHex:0xeeeeee].CGColor;
            view.model = model;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToTuanHotDetail:)];
            [view addGestureRecognizer:tap];
        }
        _tuanHeaderScroll.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH, 0);
        _pageControl.currentPage = 0;
        currentHeight += _bgView.viewHeight;
        hasTop = YES;
    } else {
        _bgView.hidden = YES;
    }
    
    // 添加快捷入口
    if (self.shortcuts && self.shortcuts.count > 0) {
        if (hasTop) {
            currentHeight += 8;
        }
        
        [_imageBgView removeAllSubviews];
        _imageBgView.top = currentHeight;
        _imageBgView.hidden = NO;

        _imageBgView.frame = CGRectMake(0, currentHeight, SCREEN_WIDTH, RECOMMEND_IMG_HEIGHT *((_shortcuts.count - 1) / 3  + 1));
        for (int i = 0; i < _shortcuts.count; i++) {
            NSDictionary *adsDict = [_shortcuts objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(RECOMMEND_VIEW_WIDTH * (i % 3), RECOMMEND_IMG_HEIGHT * (i / 3), RECOMMEND_VIEW_WIDTH, RECOMMEND_IMG_HEIGHT)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.tag = 4444 + i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goShortCut:)];
            [imageView addGestureRecognizer:tap];
            
            imageView.contentMode = UIViewContentModeCenter;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[adsDict objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"default_avatar_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error && image)
                {
                    imageView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            [_imageBgView addSubview:imageView];
            
            if (i < _shortcuts.count - 1) {
                // 添加分割线
                UIView *delimeter = [[UIView alloc] initWithFrame:CGRectMake(imageView.viewWidth - 0.5, 0, 0.5, imageView.viewHeight)];
                delimeter.backgroundColor = MILineColor;
                [imageView addSubview:delimeter];
            }
        }
        
        currentHeight = _imageBgView.bottom;
    } else {
        _imageBgView.hidden = YES;
    }
    
    _currentHeight = currentHeight;
    self.viewHeight = _currentHeight;
}

-(void)goToTuanHotDetail:(UIGestureRecognizer *)gesture
{
    //scrollView上的点击跳转
    MIHotRecommendView *view = (MIHotRecommendView *)gesture.view;
    MITuanDetailViewController *vc = [[MITuanDetailViewController alloc]initWithItem:view.model placeholderImage:nil];
    [vc.detailGetRequest setType:view.model.type.intValue];
    [vc.detailGetRequest setTid:view.model.tuanId.intValue];
    if (_tenFlag) {
        [MobClick event:kTuanHotItems];
    } else {
       [MobClick event:kYoupinHotItems];
    }
    
    [[MINavigator navigator]openPushViewController:vc animated:YES];
}

-(void)goShortCut:(UIGestureRecognizer*)gestureRecognizer
{
    NSInteger index = gestureRecognizer.view.tag - 4444;
    if (_shortcuts.count > 0) {
        NSDictionary *dic = [_shortcuts objectAtIndex:index];
        if (_tenFlag) {
            [MobClick event:kTuanShortcut label:[dic objectForKey:@"desc"]];
        } else {
            [MobClick event:kYoupinShortcut label:[dic objectForKey:@"desc"]];
        }
        
        [MINavigator openShortCutWithDictInfo:dic];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _tuanHeaderScroll.contentOffset.x / SCROLL_VIEW_WIDTH;
    NSInteger transferPage = page - 1;
    if (page == 0) {
        transferPage = _hotItems.count - 1;
        if (transferPage != _pageControl.currentPage || (_tuanHeaderScroll.contentOffset.x != SCROLL_VIEW_WIDTH * _hotItems.count)) {
            _pageControl.currentPage = transferPage;
            _tuanHeaderScroll.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH * _hotItems.count, 0);
        }
    } else if (page == _hotItems.count + 1) {
        transferPage = 0;
        if (transferPage != _pageControl.currentPage || (_tuanHeaderScroll.contentOffset.x != SCROLL_VIEW_WIDTH)) {
            _pageControl.currentPage = transferPage;
            _tuanHeaderScroll.contentOffset = CGPointMake(SCROLL_VIEW_WIDTH, 0);
        }
    }
    
    if (transferPage != _pageControl.currentPage) {
        _pageControl.currentPage = transferPage;
    }
}

-(void)goToRecommendVC
{
    //跳转到更多爆款推荐页面
    if (self.tuanHotTag && ![self.tuanHotTag isEqualToString:@""]) {
        MIListTableViewController *vc = [[MIListTableViewController alloc]init];
        vc.target = @"tuan_hot";
        vc.data = self.tuanHotTag;
        if ([self.tuanHotTag isEqualToString:@"10yuan-hot"]) {
            vc.catName = @"10元购爆款";
        } else if ([self.tuanHotTag isEqualToString:@"youpin-hot"]) {
            vc.catName = @"优品惠爆款";
        } else {
            vc.catName = @"爆款推荐";
        }
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
