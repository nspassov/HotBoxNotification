//
//  HotBox.h
//

#import <UIKit/UIKit.h>

@protocol HotBoxDelegate <NSObject>

@optional
- (void)hotBoxWasTapped:(NSString *)type;
- (void)hotBoxWasSwiped:(NSString *)type;
- (void)hotBoxButtonWasTapped:(NSString *)type;
- (void)hotBoxHasExpired:(NSString *)type;

@end

@interface HotBox : NSObject

+ (instancetype)sharedInstance;

/**
 Specifies notification box dimensions.
 */
@property (assign, nonatomic) CGSize dimensions;

/**
 Specifies standard duration in seconds for non-sticky notifications.
 */
@property (assign, nonatomic) NSTimeInterval defaultDuration;

/**
 Specifies background colour and image configurations for notification types.
 */
@property (strong, nonatomic) NSDictionary* settings;

/**
 Notification that remains on screen until dismissed via tap.
 */
- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type;

/**
 Notification that remains on screen until dismissed via tap. The delegate may react on tap event.
 */
- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate;

/**
 Notification with button that remains on screen until dismissed via tap or button. The delegate may react on tap event or button action.
 */
- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate buttonTitle:(NSString *)buttonTitle;

/**
 Notification that remains on screen for the time of the default duration or until dismissed via tap.
 */
- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type;

/**
 Notification that remains on screen for the time of the default duration or until dismissed via tap. The delegate may react on tap event or expiration event.
 */
- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate;

/**
 Notification that remains on screen for the time of the specified duration or until dismissed via tap. The delegate may react on tap event or expiration event.
 */
- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate duration:(NSTimeInterval)timeout;

/**
 Dismisses the topmost notfication in the stack.
 */
- (void)dismiss;

/**
 Dismisses all notfications in the stack.
 */
- (void)dismissAll;

@end
