//
//  MIMallSuggestsView.m
//  MISpring
//
//  Created by Yujian Xu on 13-4-11.
//  Copyright (c) 2013年 Husor Inc. All rights reserved.
//

#import "MIMallSuggestsView.h"
#import "MIMallAllViewController.h"

/**
 *	@brief	商城信息视图
 */
@interface MIMallItemView : UIButton

@property (nonatomic, assign) MIMallModel *mall;
@property (nonatomic, strong) UIImageView *itemImage;           //商城Logo
@property (nonatomic, strong) UILabel *commissions;             //最高返利比例

- (void)actionClicked:(id)sender;

@end

@implementation MIMallItemView
@synthesize mall;
@synthesize itemImage;
@synthesize commissions;

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.exclusiveTouch = YES;
        [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];

        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
        [self addSubview:itemImage];

        commissions = [[UILabel alloc] initWithFrame:CGRectMake(0, itemImage.bottom + 5, self.viewWidth, 20)];
        commissions.font = [UIFont systemFontOfSize:12];
        commissions.textColor = [MIUtility colorWithHex:0x666666];
        commissions.textAlignment = UITextAlignmentCenter;
        [self addSubview:commissions];
    }

    return self;
}

- (void)actionClicked:(id)sender{
    if (mall != nil) {
        if ([[MIMainUser getInstance] checkLoginInfo]) {
            [self goMallShoppingWithMall:mall];
        } else {
            __weak typeof(self) weakSelf = self;
            UIAlertView *alertView = [[UIAlertView alloc] initWithLoginCancelAction:^{
                [weakSelf goMallShoppingWithMall:mall];
            }];
            [alertView show];
        }
    } else {
        MILog(@"touched: total malls");
        MIMallAllViewController * vc = [[MIMallAllViewController alloc] init];
        [[MINavigator navigator] openPushViewController: vc animated:YES];
    }
}

- (void)goMallShoppingWithMall:(MIMallModel *)model
{
    NSString *url = [NSString stringWithFormat: @"%@rebate/mobile/%@?uid=%d", [MIConfig globalConfig].goURL, model.mallId, 1];
    model.mobileCommission = model.commission;    ///api返回的数据做了整合
    MIMallWebViewController *vc = [[MIMallWebViewController alloc] initWithURL:[NSURL URLWithString:url] mall:model];
    [[MINavigator navigator] openPushViewController: vc animated:YES];
}

@end

@interface MIMallsTableViewCell: UITableViewCell

@property(nonatomic, strong) NSMutableArray * views;

@end

@implementation MIMallsTableViewCell
@synthesize views;

- (id) initWithreuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        views = [[NSMutableArray alloc] initWithCapacity:3];

        MIMallItemView *item1 = [[MIMallItemView alloc] initWithFrame:CGRectMake(15, 5, 80, 70)];
        [self addSubview: item1];

        MIMallItemView *item2 = [[MIMallItemView alloc] initWithFrame:CGRectMake(item1.right + 15, 5, 80, 70)];
        [self addSubview: item2];

        MIMallItemView *item3 = [[MIMallItemView alloc] initWithFrame:CGRectMake(item2.right + 15, 5, 80, 70)];
        [self addSubview: item3];
        
        [views addObject:item1];
        [views addObject:item2];
        [views addObject:item3];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));

    //下分割线
    CGContextSetStrokeColorWithColor(context, [MIUtility colorWithHex:0xEFEFEF].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 0.8));
}

@end

@implementation MIMallSuggestsView
@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];

        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview: _tableView];
    }
    
    return self;
}

- (void)loadData:(NSArray *) malls
{
    self.hotMalls = malls;
    [self.tableView reloadData];
}

- (NSString *)getCommissionDesc:(MIMallModel *)mall
{
    NSString *desc;
    float commission = [mall.commission floatValue] / 100;
    if (mall.mode.intValue == 1) {
        //返利类型为米币
        desc = [NSString stringWithFormat:@"最高返 %.1f%%", commission];
    } else {
        if (mall.commissionType.intValue == 2) {
            //最高返利为按元计算
            desc = [NSString stringWithFormat:@"最高返 %.1f元", commission];
        } else {
            //最高返利为按比例计算
            desc = [NSString stringWithFormat:@"最高返 %.1f%%", commission];
        }
    }

    return desc;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MIMALL_SUGGEST_TABLECELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hotMalls) {
        NSInteger count = [self.hotMalls count] + 1;
        NSInteger number;
        if (count % 3 == 0) {
            number =  count / 3 ;
        } else {
            number = count / 3 + 1 ;
        }
        
        return number;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MIMallsTableViewCell * _cell = (MIMallsTableViewCell *) cell;
    
    for (int i = indexPath.row * 3, j = 0; i < (indexPath.row + 1) * 3; i++, j++) {
        @try {
            MIMallItemView *item = [_cell.views objectAtIndex:j];
            item.hidden = NO;
            
            if (i == self.hotMalls.count) {
                item.mall = nil;
                item.commissions.text = @"显示全部";
                item.itemImage.image = [UIImage imageNamed:@"ic_fanli_more"];
                [item.itemImage setContentMode:UIViewContentModeCenter];
            } else {
                MIMallModel *mall = [self.hotMalls objectAtIndex:i];
                item.mall = mall;
                item.commissions.text = [self getCommissionDesc:mall];
                [item.itemImage setContentMode:UIViewContentModeScaleAspectFit];
                [item.itemImage sd_setImageWithURL:[NSURL URLWithString:mall.logo] placeholderImage:[UIImage imageNamed:@"mizhewang_logo"]];
            }
        }
        @catch (NSException *exception) {
            ((MIMallItemView *)[_cell.views objectAtIndex:j]).hidden = YES;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mallCellIdentifier = @"mallCell";

    MIMallsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: mallCellIdentifier];
    if (cell == nil) {
        cell = [[MIMallsTableViewCell alloc] initWithreuseIdentifier:mallCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

@end
