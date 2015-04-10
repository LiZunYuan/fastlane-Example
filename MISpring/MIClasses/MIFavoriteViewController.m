//
//  MIFavoriteViewController.m
//  MISpring
//
//  Created by 曲俊囡 on 14-5-14.
//  Copyright (c) 2014年 Husor Inc. All rights reserved.
//

#import "MIFavoriteViewController.h"
#import "MGScrollView.h"
#import "MIFavView.h"
#import "MIAddFavViewController.h"
#import "MIMallUpdateModel.h"
#import "MIFavsModel.h"

@implementation MIFavoriteViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MITipView showContentOperateTipInView:self.view tipKey:@"MIFavoriteViewController" imgKey:@"img_tips_deletefavs" type:MI_TIP_TAP_DISMISS];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( [[userDefaults objectForKey:@"updateFavs"] integerValue] == 1 ) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:0 forKey:@"updateFavs"];
        [self getFavsView:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.updateMallRequest.operation.isExecuting) {
        [self.updateMallRequest cancelRequest];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTitle:@"关注商城"  textSize:20.0];
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (self.navigationBarHeight - PHONE_NAVIGATION_BAR_ITEM_HEIGHT), 60, PHONE_NAVIGATION_BAR_ITEM_HEIGHT)];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editMyFavAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.editBtn];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"updateFavs"];
    
    _favsArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self buildScroller];
    [self.view bringSubviewToFront:self.navigationBar];

    
    __weak typeof(MGBox) *wGrid = self.favsGrid;
    __weak typeof(self) wSelf = self;
    
    self.scroller.onTap = ^{
        MILog(@"scroller tap");
        if (wSelf.scroller.deleting) {
            wSelf.isEditing = NO;
            [wSelf.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            
            wSelf.scroller.deleting = NO;
            
            NSMutableOrderedSet *boxs = wGrid.boxes;
            for (MGBox *box in boxs) {
                [box disableDeleting];
                
                UIView *delView = [box viewWithTag:MIAPP_FAVS_DELETE_IMAGEVIEW_TAG];
                if (box.deletable && delView) {
                    delView.hidden = YES;
                }
            }
        }
    };
    
    self.scroller.onLongPress = ^{
        MILog(@"scroller long press");
        wSelf.isEditing = YES;
        [wSelf.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        wSelf.scroller.deleting = YES;
        NSMutableOrderedSet *boxs = wGrid.boxes;
        
        for (MGBox *box in boxs) {
            [box enableDeleting];
            
            UIView *delView = [box viewWithTag:MIAPP_FAVS_DELETE_IMAGEVIEW_TAG];
            if (box.deletable && delView) {
                delView.hidden = NO;
            }
        }
    };
    
    NSString * favDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"];
    NSMutableArray *favs = [[NSMutableArray alloc] initWithCapacity:10];
    [favs addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favDataPath]];
    
    int count = favs.count;
    NSString *whereSection = @"";
    for (int i = 0; i < count; i++) {
        MIFavsModel *model = [favs objectAtIndex:i];
        if (model.type.integerValue == 1) {
            if (whereSection.length == 0) {
                whereSection = [whereSection stringByAppendingString:model.iid];
            } else {
                whereSection = [whereSection stringByAppendingString:[@"," stringByAppendingString:model.iid]];
            }
        }
    }
    
    self.updateMallRequest = [[MIMallUpdateRequest alloc] init];
    self.updateMallRequest.onCompletion = ^(MIMallUpdateModel *model) {
        [wSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];

        NSMutableArray *favs = [[NSMutableArray alloc] initWithCapacity:10];
        [favs addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favDataPath]];
        for (MIMallModel *mall in model.malls) {
            for (MIFavsModel *fav in favs) {
                if ( [fav.iid isEqualToString: mall.mallId] ) {
                    if (mall.type.boolValue && mall.mobileCommission.floatValue != 0) {
                        fav.commission = mall.mobileCommission;
                    } else {
                        fav.commission = mall.commission;
                    }
                    fav.mallType = mall.type;
                    fav.commissionType = mall.commissionType;
                    fav.commissionMode = mall.mode.stringValue;
                    break;
                }
            }
        }
        
        [NSKeyedArchiver archiveRootObject:favs toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"]];
        [wSelf getFavsView:NO];
    };
    
    self.updateMallRequest.onError = ^(MKNetworkOperation* completedOperation, MIError* error) {
        MILog(@"error_msg=%@",error.description);
        [wSelf setOverlayStatus:EOverlayStatusRemove labelText:nil];
        [wSelf getFavsView:NO];
    };
    [self.updateMallRequest setIds:whereSection];
    [self.updateMallRequest sendQuery];
    [self setOverlayStatus:EOverlayStatusLoading labelText:nil];
}
- (void)buildScroller
{
    self.scroller = [[MGScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, PHONE_SCREEN_SIZE.width, self.view.viewHeight - self.navigationBarHeight)];
    self.scroller.contentLayoutMode = MGLayoutGridStyle;
    [self.view addSubview:self.scroller];
    
    self.favsGrid = [MGBox boxWithSize:CGSizeMake(self.scroller.size.width, self.scroller.size.height - 25)];
    self.favsGrid.contentLayoutMode = MGLayoutGridStyle;
    self.favsGrid.topMargin = 10;
    self.favsGrid.leftMargin = 10;
    self.favsGrid.bottomMargin = 10;
    [self.scroller.boxes addObject:self.favsGrid];
}
- (void)editMyFavAction:(id)sender
{
    if (!_isEditing)
    {
        _isEditing = YES;
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.scroller.deleting = YES;
        NSMutableOrderedSet *boxs = self.favsGrid.boxes;
        
        for (MGBox *box in boxs) {
            [box enableDeleting];
            
            UIView *delView = [box viewWithTag:MIAPP_FAVS_DELETE_IMAGEVIEW_TAG];
            if (box.deletable && delView) {
                delView.hidden = NO;
            }
        }
    }
    else
    {
        _isEditing = NO;
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.scroller.deleting = NO;
        NSMutableOrderedSet *boxs = self.favsGrid.boxes;
        for (MGBox *box in boxs) {
            [box disableDeleting];
            
            UIView *delView = [box viewWithTag:MIAPP_FAVS_DELETE_IMAGEVIEW_TAG];
            if (box.deletable && delView) {
                delView.hidden = YES;
            }
        }
    }
}
- (MIFavView *)addBox {
    
    // make the box
    MIFavView *box = [MIFavView addFavBox];
    
    // deal with taps
    box.onTap = ^{
        [MobClick event:kAddFavs];
        
        MIAddFavViewController * addFavVc = [[MIAddFavViewController alloc] init];
        [[MINavigator navigator] openPushViewController:addFavVc animated:YES];
    };
    
    return box;
}

- (void) getFavsView:(BOOL) reload {
    
    [_favsArray removeAllObjects];
    
    NSMutableOrderedSet *boxs = self.favsGrid.boxes;
    [boxs removeAllObjects];
    
    NSString * favDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"];
    NSMutableArray *hasFavs = [[NSMutableArray alloc] initWithCapacity:10];
    [hasFavs addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favDataPath]];
    
    int i = 0;
    for (MIFavsModel * hf in hasFavs) {
        
        if ( [hf.type isEqualToString:@"2"]) {
            [_favsArray addObject: hf];
            [self.favsGrid.boxes addObject:[self favBoxWithTag:i]];
            
            i++;
        }
    }
    
    for (MIFavsModel * hf in hasFavs) {
        
        if ( [hf.type isEqualToString:@"1"]) {
            [_favsArray addObject: hf];
            [self.favsGrid.boxes addObject:[self favBoxWithTag:i]];
            
            i++;
        }
        
    }
    
    for (MIFavsModel * hf in hasFavs) {
        
        if ( [hf.type isEqualToString:@"0"]) {
            [_favsArray addObject: hf];
            [self.favsGrid.boxes addObject:[self favBoxWithTag:i]];
            
            i++;
        }
        
    }
    
    // add a blank "add favs" box
    MIFavView *addBox = self.addBox;
    [self.favsGrid.boxes addObject:addBox];
    [self.scroller layoutWithSpeed:0.2 completion:nil];
    
    if (reload) {
        [self.scroller scrollToView:addBox withMargin:10];
    }
}

- (MGBox *)favBoxWithTag:(NSInteger)tag {
    
    // make the fav box
    MIFavsModel *model = [_favsArray objectAtIndex:tag];
    MIFavView *box = [MIFavView boxWithWithTag:tag data:model];
    
    // remove the box when tapped
    __weak typeof(MIFavView) *wbox = box;
    box.onTap = ^{
        MILog(@"fav box");
        [self actionFavsClicked:wbox];
    };
    
    if ([model.deletable boolValue]) {
        box.onDelete = ^{
            [CATransaction begin];
            
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.fromValue=[NSNumber numberWithFloat:0.85];
            animation.toValue=[NSNumber numberWithFloat:0.0];
            animation.duration=0.2;
            animation.repeatCount=0;
            animation.autoreverses=NO;
            animation.removedOnCompletion=NO;
            animation.fillMode=kCAFillModeForwards;
            
            [CATransaction setCompletionBlock:^{
                [self delFavs: [_favsArray objectAtIndex:wbox.tag]];
                
                MGBox *section = (id)wbox.parentBox;
                
                [section.boxes removeObject:wbox];
                
                [section layoutWithSpeed:0.3 completion:^{
                    [(MGBox *)section.parentBox layoutWithSpeed:0.3 completion:nil];
                }];
            }];
            [[wbox layer] addAnimation:animation forKey:@"transtionScaleZeroKey"];
            [CATransaction commit];
        };
    }
    
    return box;
}

- (void) delFavs: (MIFavsModel *)model
{
    NSString * favDataPath = [[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"];
    NSMutableArray *hasFavs = [[NSMutableArray alloc] initWithCapacity:10];
    [hasFavs addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favDataPath]];
    
    for (MIFavsModel * hf in hasFavs) {
        
        if ( [hf.iid isEqualToString: model.iid] ) {
            [hasFavs removeObject: hf];
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:hasFavs toFile:[[MIMainUser documentPath] stringByAppendingPathComponent:@"home.fav.data"]];
}

- (void)actionFavsClicked:(id)sender{
    UIView *box = (UIView *)sender;
    
    MIFavsModel *model = [_favsArray objectAtIndex:box.tag];
    [MobClick event:kHomeFavs label:model.name];
    
    NSInteger type = [model.type integerValue];
    if (type == 1) {
        //去商城购物
        MIMallModel *mall = [[MIMallModel alloc] init];
        mall.mallId = model.iid;
        mall.logo = model.logo;
        mall.name = model.name;
        mall.type = model.mallType;
        mall.commission = model.commission;
        mall.mobileCommission = model.commission;
        mall.commissionType = model.commissionType;
        mall.mode = [NSNumber numberWithInt:model.commissionMode.intValue];
        NSString *mallUrl = [NSString stringWithFormat: @"%@rebate/mobile/%@", [MIConfig globalConfig].goURL, model.iid];
        
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            [self goMallWithMall:mall url:mallUrl];
        } else {
            __weak typeof(self) weakSelf = self;
            UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
                [weakSelf goMallWithMall:mall url:mallUrl];
            }];
            [alertView show];
        }
        
        return;
    }
    
    NSString *target;
    NSString *desc;
    if (type == 2) {
        //去淘宝购物
        desc = @"淘宝网";
        target = @"http://m.taobao.com/";
    } else {
        //去品牌名店购物
        desc = model.name;
        target = [NSString stringWithFormat:@"http://shop%@.m.taobao.com", model.iid];
    }
    
    if ([[MIMainUser getInstance] checkLoginInfo]) {
        [self goShopingWithTarget:target desc:desc type:0];
    } else {
        __weak typeof(self) weakSelf = self;
        UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
            [weakSelf goShopingWithTarget:target desc:desc type:0];
        }];
        [alertView show];
    }
}

- (void)goMallWithMall:(MIMallModel *)mall url:(NSString *)mallUrl
{
    MIMallWebViewController *vc = [[MIMallWebViewController alloc] initWithURL:[NSURL URLWithString:mallUrl] mall:mall];
    [[MINavigator navigator] openPushViewController:vc animated:YES];
}

- (void)goShopingWithTarget:(NSString *)target desc:(NSString *)desc type:(NSString *)type
{
    NSString *path = target;
    if (type && type.integerValue == 1) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow : 0];
        NSTimeInterval a = [date timeIntervalSince1970];
        NSString * ts = [NSString stringWithFormat:@"%.0f", a];
        
        NSString *url;
        if ([target rangeOfString: @"?"].length == 0) {
            url = [NSString stringWithFormat:@"%@?%@", target, ts];
        } else {
            url = [NSString stringWithFormat:@"%@&%@", target, ts];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [MIMainUser getInstance].sessionKey, @"session",
                                       ts, @"ts",
                                       url, @"t",
                                       [MIOpenUDID value], @"udid", nil];
        NSString *sign = [NSString stringWithFormat:@"%@%@%@%@%@", ts, [MIMainUser getInstance].sessionKey, [MIOpenUDID value], url, ts];
        [params setObject:[[sign md5] lowercaseString] forKey:@"sign"];
        path = [MIUtility serializeURL:[MIConfig globalConfig].trustLoginURL
                                params:params httpMethod:@"GET"];
    }
    
    [MINavigator openTbWebViewControllerWithURL:[NSURL URLWithString:path] desc:desc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
