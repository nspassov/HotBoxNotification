//
//  HotBoxTransitionAnimator.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat VABoxTransitionAnimationDuration = .5;

@interface HotBoxTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property(assign, nonatomic, getter=isPresenting) BOOL presenting;

@end
