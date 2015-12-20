//
//  HotBoxViewController.h
//

#import <UIKit/UIKit.h>
#import "HotBox.h"

@interface HotBoxViewController : UIViewController

- (instancetype)initWithOwner:(HotBox *)owner;

@property (weak, nonatomic) id<HotBoxDelegate> delegate;

@property (copy, nonatomic) NSString* notificationType;
@property (copy, nonatomic) NSString* buttonTitle;

@property (strong, nonatomic) UILabel* messageLabel;
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) UIButton* actionButton;

@property (readonly, nonatomic) BOOL hasButton;
@property (readonly, nonatomic) NSString* messageString;

@end
