//
//  HotBox.m
//

#import "HotBoxViewController.h"
#import "HotBoxTransitionAnimator.h"


@interface HotBox () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIWindow* window;

@property (strong, nonatomic) NSMutableArray* viewControllers;

@end

@implementation HotBox

+ (instancetype)sharedInstance
{
    static HotBox* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark -

- (instancetype)init
{
    if(self = [super init]) {
        self.defaultDuration = 5;
    }
    return self;
}

- (UIWindow *)window
{
    if(!_window) {
        _window = [UIWindow new];
        [_window setFrame:CGRectMake(0, 0, self.dimensions.width, self.dimensions.height)];
        [_window setWindowLevel:UIWindowLevelStatusBar];
        [_window setRootViewController:[self.viewControllers firstObject]];
        [_window setBackgroundColor:[UIColor clearColor]];
        
        [_window setHidden:NO];
    }
    return _window;
}

- (NSMutableArray *)viewControllers
{
    if(!_viewControllers) {
        _viewControllers = [NSMutableArray arrayWithObject:[[HotBoxViewController alloc] initWithOwner:self]];
    }
    return _viewControllers;
}

- (CGSize)dimensions
{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 64);
}

- (NSDictionary *)settings
{
    if(!_settings) {
        _settings = @{ @"": @{
                               @"backgroundColor": [UIColor redColor],
                               @"image": [UIImage new],
                               }
                      };
    }
    return _settings;
}


#pragma mark -

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    HotBoxTransitionAnimator* animator = [HotBoxTransitionAnimator new];
    [animator setPresenting:YES];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    HotBoxTransitionAnimator* animator = [HotBoxTransitionAnimator new];
    return animator;
}


#pragma mark - Interface

- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate buttonTitle:(NSString *)buttonTitle
{
    [self presentViewControllerWithText:text ofType:type withDelegate:delegate buttonTitle:buttonTitle];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
}

- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate
{
    [self showStickyMessage:text ofType:type withDelegate:delegate buttonTitle:@""];
}

- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type
{
    [self showStickyMessage:text ofType:type withDelegate:nil];
}


- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate duration:(NSTimeInterval)timeout
{
    [self presentViewControllerWithText:text ofType:type withDelegate:delegate buttonTitle:@""];
    
    if ([self.viewControllers count] > 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    }
    else {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:timeout];
    }
}

- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate
{
    [self showMessage:text ofType:type withDelegate:delegate duration:self.defaultDuration];
}

- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type
{
    [self showMessage:text ofType:type withDelegate:nil duration:self.defaultDuration];
}


#pragma mark -

- (void)presentViewControllerWithText:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate buttonTitle:(NSString *)buttonTitle
{
    if(![self.viewControllers lastObject]
       || ![[[self.viewControllers lastObject] messageString] isEqualToString:[text string]]
       || (![[[self.viewControllers lastObject] buttonTitle] isEqualToString:buttonTitle] && buttonTitle.length)) {
        // we prevent multiple consecutive notifications of the same type containing the same message,
        // except if the latest one has a button and the previous one does not

        HotBoxViewController* vc = [[HotBoxViewController alloc] initWithOwner:self];
        [vc setDelegate:delegate];
        [vc setNotificationType:type];
        if(self.settings[type][@"image"])
            [vc setImage:self.settings[type][@"image"]];
        [vc.messageLabel setAttributedText:text];
        [vc setButtonTitle:buttonTitle];
        [vc setModalPresentationStyle:UIModalPresentationCustom];
        [vc setTransitioningDelegate:self];
        
        if(self.settings[type][@"backgroundColor"])
            [vc.view setBackgroundColor:self.settings[type][@"backgroundColor"]];
        [vc.view setFrame:self.window.bounds];
        
        UIViewController* topmostVC = [self.viewControllers lastObject];
        [self.viewControllers addObject:vc];
        
        [topmostVC presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dismiss
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    if([self.viewControllers count]) {
        HotBoxViewController* topmostVC = [self.viewControllers lastObject];
        [self.viewControllers removeLastObject];
        [topmostVC dismissViewControllerAnimated:YES completion:nil];
        
        if([topmostVC.delegate respondsToSelector:@selector(hotBoxHasExpired:)]) {
            [topmostVC.delegate hotBoxHasExpired:topmostVC.notificationType];
        }

        if([topmostVC.presentingViewController isEqual:self.window.rootViewController])
            [self performSelector:@selector(cleanup) withObject:nil afterDelay:VABoxTransitionAnimationDuration];
    }
}

- (void)dismissAll
{
    if([self.viewControllers count] > 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        
        [UIView animateWithDuration:VABoxTransitionAnimationDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:1
                            options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self.window setFrame:CGRectOffset(self.window.frame, 0, -CGRectGetHeight(self.window.frame))];

         } completion:^(BOOL finished) {
             [[self.viewControllers firstObject] dismissViewControllerAnimated:NO completion:nil];
             [self.viewControllers removeAllObjects];

             [self cleanup];
         }];
    }
}

- (void)cleanup
{
    [self.window setHidden:YES];

    _viewControllers = nil;
    _window = nil;
}

@end
