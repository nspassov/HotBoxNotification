//
//  HotBox.h
//

#import <UIKit/UIKit.h>

@protocol HotBoxDelegate <NSObject>

@optional
- (void)hotBoxWasTapped:(NSString *)type;
- (void)hotBoxButtonWasTapped:(NSString *)type;
- (void)hotBoxHasExpired:(NSString *)type;

@end

@interface HotBox : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) CGSize dimensions;
@property (assign, nonatomic) NSTimeInterval defaultDuration;
@property (strong, nonatomic) NSDictionary* settings;

- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type;
- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate;
- (void)showStickyMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate buttonTitle:(NSString *)buttonTitle;

- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type;
- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate;
- (void)showMessage:(NSAttributedString *)text ofType:(NSString *)type withDelegate:(id<HotBoxDelegate>)delegate duration:(NSTimeInterval)timeout;

- (void)dismiss;
- (void)dismissAll;

@end
