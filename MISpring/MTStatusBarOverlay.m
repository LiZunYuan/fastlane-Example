//
//  MTStatusBarOverlay.m
//
//  Created by Matthias Tretter on 27.09.10.
//  Copyright (c) 2009-2011  Matthias Tretter, @myell0w. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Credits go to:
// -------------------------------
// http://stackoverflow.com/questions/2833724/adding-view-on-statusbar-in-iphone
// http://www.cocoabyss.com/uikit/custom-status-bar-ios/
// @reederapp for inspiration
// -------------------------------

#import "MTStatusBarOverlay.h"
#import <QuartzCore/QuartzCore.h>


////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Functions
////////////////////////////////////////////////////////////////////////

NSData* MTStatusBarBackgroundImageData(BOOL shrinked);
unsigned char* MTStatusBarBackgroundImageArray(BOOL shrinked);
unsigned int MTStatusBarBackgroundImageLength(BOOL shrinked);

void mt_dispatch_sync_on_main_thread(dispatch_block_t block);

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Defines
////////////////////////////////////////////////////////////////////////

// the height of the status bar
#define kStatusBarHeight 20.f
// width of the screen in portrait-orientation
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// height of the screen in portrait-orientation
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// macro for checking if we are on the iPad
#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// macro for checking if we are on the iPad in iPhone-Emulation mode
#define IsIPhoneEmulationMode (!IsIPad && \
MAX([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height) > 480.f)



////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Customization
////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// Light Theme (for UIStatusBarStyleDefault)
///////////////////////////////////////////////////////

#define kLightThemeTextColor						[UIColor whiteColor]
#define kLightThemeErrorMessageTextColor            [UIColor whiteColor] // [UIColor colorWithRed:0.494898f green:0.330281f blue:0.314146f alpha:1.0f]
#define kLightThemeFinishedMessageTextColor         [UIColor whiteColor] // [UIColor colorWithRed:0.389487f green:0.484694f blue:0.38121f alpha:1.0f]
#define kLightThemeShadowColor                      [UIColor whiteColor]
#define kLightThemeErrorMessageShadowColor          [UIColor whiteColor]
#define kLightThemeFinishedMessageShadowColor       [UIColor whiteColor]
#define kLightThemeActivityIndicatorViewStyle		UIActivityIndicatorViewStyleGray
#define kLightThemeDetailViewBackgroundColor		[UIColor whiteColor]
#define kLightThemeDetailViewBorderColor			[UIColor darkGrayColor]
#define kLightThemeHistoryTextColor					[UIColor colorWithRed:0.749f green:0.749f blue:0.749f alpha:1.0f]


///////////////////////////////////////////////////////
// Dark Theme (for UIStatusBarStyleBlackOpaque)
///////////////////////////////////////////////////////

#define kDarkThemeTextColor							[UIColor colorWithRed:0.749f green:0.749f blue:0.749f alpha:1.0f]
#define kDarkThemeErrorMessageTextColor             [UIColor colorWithRed:0.749f green:0.749f blue:0.749f alpha:1.0f] // [UIColor colorWithRed:0.918367f green:0.48385f blue:0.423895f alpha:1.0f]
#define kDarkThemeFinishedMessageTextColor          [UIColor colorWithRed:0.749f green:0.749f blue:0.749f alpha:1.0f] // [UIColor colorWithRed:0.681767f green:0.918367f blue:0.726814f alpha:1.0f]
#define kDarkThemeActivityIndicatorViewStyle		UIActivityIndicatorViewStyleWhite
#define kDarkThemeDetailViewBackgroundColor			[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f]
#define kDarkThemeDetailViewBorderColor				[UIColor whiteColor]
#define kDarkThemeHistoryTextColor					[UIColor whiteColor]

///////////////////////////////////////////////////////
// Progress
///////////////////////////////////////////////////////

#define kProgressViewAlpha                          0.4f
#define kProgressViewBackgroundColor                [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]


///////////////////////////////////////////////////////
// Animations
///////////////////////////////////////////////////////

// minimum time that a message is shown, when messages are queued
#define kMinimumMessageVisibleTime				0.4f

// duration of the animation to show next status message in seconds
#define kNextStatusAnimationDuration			0.6f

// duration the statusBarOverlay takes to appear when it was hidden
#define kAppearAnimationDuration				0.5f

// animation duration of animation mode shrink
#define kAnimationDurationShrink				0.3f

// animation duration of animation mode fallDown
#define kAnimationDurationFallDown				0.4f

// animation duration of change of progressView-size
#define kUpdateProgressViewDuration             0.2f

// delay after that the status bar gets visible again after rotation
#define kRotationAppearDelay					[UIApplication sharedApplication].statusBarOrientationAnimationDuration


///////////////////////////////////////////////////////
// Text
///////////////////////////////////////////////////////

// Text that is displayed in the finished-Label when the finish was successful
#define kFinishedText		@"✓"
#define kFinishedFontSize	22.f

// Text that is displayed when an error occured
#define kErrorText			@"✗"
#define kErrorFontSize		19.f



///////////////////////////////////////////////////////
// Detail View
///////////////////////////////////////////////////////

#define kHistoryTableRowHeight		25.f
#define kMaxHistoryTableRowCount	5

#define kDetailViewAlpha			0.9f
#define kDetailViewWidth			(IsIPad ? 400.f : 280.f)
// default frame of detail view when it is hidden
#define kDefaultDetailViewFrame CGRectMake((kScreenWidth - kDetailViewWidth)/2, -(kHistoryTableRowHeight*kMaxHistoryTableRowCount + kStatusBarHeight),\
kDetailViewWidth, kHistoryTableRowHeight*kMaxHistoryTableRowCount + kStatusBarHeight)


///////////////////////////////////////////////////////
// Size
///////////////////////////////////////////////////////

// Size of the text in the status labels
#define kStatusLabelSize				12.f

// default-width of the small-mode
#define kWidthSmall						120.f



////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension
////////////////////////////////////////////////////////////////////////

@interface MTStatusBarOverlay ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *statusBarBackgroundImageView;
@property (nonatomic, strong) UILabel *statusLabel2;
@property (assign, getter=isActive) BOOL active;
@property (nonatomic, readonly, getter=isReallyHidden) BOOL reallyHidden;
@property (nonatomic, strong) NSMutableArray *messageQueue;
@property (nonatomic, strong) NSMutableArray *messageHistory;
@property (nonatomic, assign) BOOL forcedToHide;
- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated immediate:(BOOL)immediate;
- (void)showNextMessage;
- (void)setStatusBarBackgroundForStyle:(UIStatusBarStyle)style;
- (void)updateUIWithDuration:(NSTimeInterval)duration;
- (void)callDelegateWithNewMessage:(NSString *)newMessage;
- (void)setHidden:(BOOL)hidden useAlpha:(BOOL)useAlpha;
- (void)setHiddenUsingAlpha:(BOOL)hidden;
- (void)addMessageToHistory:(NSString *)message;
- (void)clearHistory;
- (CGRect)backgroundViewFrameForStatusBarInterfaceOrientation;

@end

@implementation MTStatusBarOverlay

@synthesize backgroundView = backgroundView_;
@synthesize statusBarBackgroundImageView = statusBarBackgroundImageView_;
@synthesize statusLabel2 = statusLabel2_;
@synthesize defaultStatusBarImage = defaultStatusBarImage_;
@synthesize fullFrame = fullFrame_;
@synthesize smallFrame = smallFrame_;
//@synthesize oldBackgroundViewFrame = oldBackgroundViewFrame_;
@synthesize animation = animation_;
//@synthesize hideInProgress = hideInProgress_;
@synthesize active = active_;
@synthesize messageQueue = messageQueue_;
@synthesize detailViewMode = detailViewMode_;
@synthesize messageHistory = messageHistory_;
@synthesize delegate = delegate_;
@synthesize forcedToHide = forcedToHide_;
@synthesize lastPostedMessage = lastPostedMessage_;

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        
		// only use height of 20px even is status bar is doubled
		statusBarFrame.size.height = statusBarFrame.size.height == 2*kStatusBarHeight ? kStatusBarHeight : statusBarFrame.size.height;
		// if we are on the iPad but in iPhone-Mode (non-universal-app) correct the width
		if(IsIPhoneEmulationMode) {
			statusBarFrame.size.width = 320.f;
		}
        
		// Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.f;
        self.frame = statusBarFrame;
		self.alpha = 0.f;
		self.hidden = NO;
        
        fullFrame_ = statusBarFrame;
		// Default Small size: just show Activity Indicator
		smallFrame_ = CGRectMake(statusBarFrame.size.width - kWidthSmall, 0.f, kWidthSmall, statusBarFrame.size.height);
        
		// Default-values
		animation_ = MTStatusBarOverlayAnimationNone;
		active_ = NO;
        forcedToHide_ = NO;
		messageHistory_ = [[NSMutableArray alloc] init];
        
        CGRect backgroundFrame = [self backgroundViewFrameForStatusBarInterfaceOrientation];
        backgroundView_ = [[UIView alloc] initWithFrame:backgroundFrame];
		backgroundView_.clipsToBounds = YES;
		backgroundView_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView_];
		statusBarBackgroundImageView_ = [[UIImageView alloc] initWithFrame:backgroundView_.frame];
		statusBarBackgroundImageView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubviewToBackgroundView:statusBarBackgroundImageView_];
        
        statusLabel2_ = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backgroundView_.viewWidth, 20)];
		statusLabel2_.backgroundColor = [UIColor clearColor];
        statusLabel2_.textColor = [UIColor whiteColor];
		statusLabel2_.font = [UIFont boldSystemFontOfSize:12];
		statusLabel2_.textAlignment = UITextAlignmentCenter;
		statusLabel2_.numberOfLines = 1;
		[self addSubviewToBackgroundView:statusLabel2_];
		messageQueue_ = [[NSMutableArray alloc] init];
		// listen for changes of status bar frame
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didChangeStatusBarFrame:)
													 name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
    }
    
	return self;
}


#pragma mark -
#pragma mark Status Bar Appearance
////////////////////////////////////////////////////////////////////////

- (void)addSubviewToBackgroundView:(UIView *)view {
	view.userInteractionEnabled = NO;
	[self.backgroundView addSubview:view];
}

- (void)addSubviewToBackgroundView:(UIView *)view atIndex:(NSInteger)index {
	view.userInteractionEnabled = NO;
	[self.backgroundView insertSubview:view atIndex:index];
}

#pragma mark Message Posting

- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated {
    [self postMessage:message duration:duration animated:animated immediate:NO];
}

- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated immediate:(BOOL)immediate {
    mt_dispatch_sync_on_main_thread(^{
        // don't add to queue when message is empty
        if (message.length == 0) {
            return;
        }
        
        NSDictionary *messageDictionaryRepresentation = [NSDictionary dictionaryWithObjectsAndKeys:message, kMTStatusBarOverlayMessageKey,
                                                         [NSNumber numberWithDouble:duration], kMTStatusBarOverlayDurationKey,
                                                         [NSNumber numberWithBool:animated],  kMTStatusBarOverlayAnimationKey,
                                                         [NSNumber numberWithBool:immediate], kMTStatusBarOverlayImmediateKey, nil];
        
        @synchronized (self.messageQueue) {
            [self.messageQueue insertObject:messageDictionaryRepresentation atIndex:0];
        }
        
        // if the overlay is currently not active, begin with showing of messages
        if (!self.active) {
            [self showNextMessage];
        }
    });
}

- (void)showNextMessage {
    if (self.forcedToHide) {
        return;
    }
    
	// if there is no next message to show overlay is not active anymore
	@synchronized(self.messageQueue) {
		if([self.messageQueue count] < 1) {
			self.active = NO;
			return;
		}
	}
    
	self.active = YES;
    
	NSDictionary *nextMessageDictionary = nil;
    
	// read out next message
	@synchronized(self.messageQueue) {
		nextMessageDictionary = [self.messageQueue lastObject];
	}
	NSString *message = [nextMessageDictionary valueForKey:kMTStatusBarOverlayMessageKey];
	NSTimeInterval duration = (NSTimeInterval)[[nextMessageDictionary valueForKey:kMTStatusBarOverlayDurationKey] doubleValue];
	BOOL animated = [[nextMessageDictionary valueForKey:kMTStatusBarOverlayAnimationKey] boolValue];
    
	// don't show anything if status bar is hidden (queue gets cleared)
	if([UIApplication sharedApplication].statusBarHidden) {
		@synchronized(self.messageQueue) {
			[self.messageQueue removeAllObjects];
		}
        
		self.active = NO;
        
		return;
	}
    
	if (!self.reallyHidden && [self.statusLabel2.text isEqualToString:message]) {
		@synchronized(self.messageQueue) {
            if (self.messageQueue.count > 0)
                [self.messageQueue removeLastObject];
		}
        
		[self showNextMessage];
        
		return;
	}
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearHistory) object:nil];
    
	UIStatusBarStyle statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	[self setStatusBarBackgroundForStyle:statusBarStyle];
	[self updateUIWithDuration:duration];
	if (self.reallyHidden) {
		self.statusLabel2.text = @"";
		[UIView animateWithDuration:self.shrinked ? 0 : kAppearAnimationDuration
						 animations:^{
							 [self setHidden:NO useAlpha:YES];
						 }];
	}
    
    if (animated) {
        self.statusLabel2.text = message;
        [UIView animateWithDuration:kNextStatusAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{

                         }
                         completion:^(BOOL finished) {
                             [self addMessageToHistory:self.statusLabel2.text];
                             @synchronized(self.messageQueue) {
                                 if (self.messageQueue.count > 0)
                                     [self.messageQueue removeLastObject];
                             }
                             [self callDelegateWithNewMessage:message];
                             [self performSelector:@selector(showNextMessage) withObject:nil afterDelay:kMinimumMessageVisibleTime];
                         }];
    }
    
    else {

        [self addMessageToHistory:self.statusLabel2.text];
        self.statusLabel2.text = message;
        @synchronized(self.messageQueue) {
            if (self.messageQueue.count > 0)
                [self.messageQueue removeLastObject];
        }
        [self callDelegateWithNewMessage:message];
        [self performSelector:@selector(showNextMessage) withObject:nil afterDelay:kMinimumMessageVisibleTime];
    }
    self.lastPostedMessage = message;
}

- (void)hide {
	[self.activityIndicator stopAnimating];
	self.statusLabel2.text = @"";
    
//	self.hideInProgress = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    [UIView animateWithDuration:self.shrinked ? 0. : kAppearAnimationDuration
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
		[self setHidden:YES useAlpha:YES];
	} completion:^(BOOL finished) {
	}];
}


- (void)setAnimation:(MTStatusBarOverlayAnimation)animation {
	animation_ = animation;
    
}

#pragma mark Private Methods
////////////////////////////////////////////////////////////////////////

- (void)setStatusBarBackgroundForStyle:(UIStatusBarStyle)style {
		self.statusBarBackgroundImageView.image = nil;
		statusBarBackgroundImageView_.backgroundColor = [UIColor blackColor];

}

- (void)updateUIWithDuration:(NSTimeInterval)duration {

    if (duration > 0.) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:duration];
        [self performSelector:@selector(clearHistory) withObject:nil afterDelay:duration];
    }
}

- (void)callDelegateWithNewMessage:(NSString *)newMessage {
	if ([self.delegate respondsToSelector:@selector(statusBarOverlayDidSwitchFromOldMessage:toNewMessage:)]) {
		NSString *oldMessage = nil;
        
		if (self.messageHistory.count > 0) {
			oldMessage = [self.messageHistory lastObject];
		}
        
		[self.delegate statusBarOverlayDidSwitchFromOldMessage:oldMessage
												  toNewMessage:newMessage];
	}
}

- (CGRect)backgroundViewFrameForStatusBarInterfaceOrientation{
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation) ? 
            CGRectMake(0, 0, kScreenHeight, kStatusBarHeight) :
            CGRectMake(0, 0, kScreenWidth, kStatusBarHeight));
}


- (void)addMessageToHistory:(NSString *)message {
	if (message != nil
		&& [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
		// add message to history-array
		[self.messageHistory addObject:message];
	}
}

- (void)clearHistory {
	[self.messageHistory removeAllObjects];
}

- (void)setHiddenUsingAlpha:(BOOL)hidden {
	[self setHidden:hidden useAlpha:YES];
}

- (void)setHidden:(BOOL)hidden useAlpha:(BOOL)useAlpha {
	if (useAlpha) {
		self.alpha = hidden ? 0.f : 1.f;
	} else {
		self.hidden = hidden;
	}
}

- (BOOL)isReallyHidden {
	return self.alpha == 0.f || self.hidden;
}

#pragma mark Singleton Definitions
////////////////////////////////////////////////////////////////////////

+ (MTStatusBarOverlay *)sharedInstance {
    static dispatch_once_t pred;
    __strong static MTStatusBarOverlay *sharedOverlay = nil; 
    
    dispatch_once(&pred, ^{ 
        sharedOverlay = [[MTStatusBarOverlay alloc] init]; 
    }); 
    
	return sharedOverlay;
}

+ (MTStatusBarOverlay *)sharedOverlay {
	return [self sharedInstance];
}
@end

void mt_dispatch_sync_on_main_thread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
