//
//  HotBoxTransitionAnimator.m
//

#import "HotBoxTransitionAnimator.h"

@implementation HotBoxTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return VABoxTransitionAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Get the set of relevant objects.
    UIView *containerView = [transitionContext containerView];
//    UIViewController *fromVC = [transitionContext
//                                viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext
                                viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // Set up some variables for the animation.
    CGRect containerFrame = containerView.frame;
//    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
//    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    
    // Set up the animation parameters.
    if (self.presenting) {
        // Modify the frame of the presented view so that it starts
        // offscreen at the lower-right corner of the container.
//        toViewStartFrame.origin.x = containerFrame.size.width;
//        toViewStartFrame.origin.y = containerFrame.size.height;
        toViewStartFrame = CGRectMake(0, -CGRectGetHeight(containerFrame), CGRectGetWidth(containerFrame), CGRectGetHeight(containerFrame));
    }
    else {
        // Modify the frame of the dismissed view so it ends in
        // the lower-right corner of the container view.
//        fromViewFinalFrame = CGRectMake(containerFrame.size.width,
//                                        containerFrame.size.height,
//                                        toView.frame.size.width,
//                                        toView.frame.size.height);
//        fromViewFinalFrame = CGRectMake(0, -CGRectGetHeight(containerFrame), CGRectGetWidth(containerFrame), CGRectGetHeight(containerFrame));
    }
    
    // Always add the "to" view to the container.
    // And it doesn't hurt to set its start frame.
    [containerView addSubview:toView];
    toView.frame = toViewStartFrame;
    
    // Animate using the animator's own duration value.
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
                         if (self.presenting) {
                             // Move the presented view into position.
                             [toView setFrame:toViewFinalFrame];
                         }
                         else {
                             // Move the dismissed view offscreen.
//                             [fromView setFrame:fromViewFinalFrame];
                             [fromView setTransform:CGAffineTransformMakeTranslation(0, -CGRectGetHeight(fromView.frame))];
                         }
                     }
                     completion:^(BOOL finished){
                         BOOL success = ![transitionContext transitionWasCancelled];
                         
                         // After a failed presentation or successful dismissal, remove the view.
                         if ((self.presenting && !success) || (!self.presenting && success)) {
                             [toView removeFromSuperview];
                         }
                         
                         // Notify UIKit that the transition has finished
                         [transitionContext completeTransition:success];
                     }];
    
}

@end