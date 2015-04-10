

#import <UIKit/UIKit.h>
#import "MITextButton.h"

@protocol MIChooseAlertViewDelegate <NSObject>

@optional
- (void)closeShippingAlertView;
- (void)goAhead;
- (void)goBackToCart;

@end

@interface MIChooseAlertView : UIView<MIChooseAlertViewDelegate>

@property (assign ,nonatomic) id<MIChooseAlertViewDelegate> delegate;
@property (assign ,nonatomic) BOOL ischoosed;

@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet MITextButton *goBackToCartButton;
@property (weak, nonatomic) IBOutlet MITextButton *goAheadButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *noShippingLabel;


@end
