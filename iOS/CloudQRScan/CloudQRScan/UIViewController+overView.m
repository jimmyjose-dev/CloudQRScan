//
//  UIViewController+overView.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 29/03/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "UIViewController+overView.h"


@implementation UIViewController (OverView)

#define kUIViewControllerOverViewDismissNotification @"OverViewDismissNotification"

const float kUIViewControllerOverViewAnimationDuration = 0.75;
const NSInteger kUIViewControllerOverViewTag = 8008135; // Arbitrary number, so as not to conflict
- (void)overViewDismissed
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUIViewControllerOverViewDismissNotification object:self.view];
}

- (void)presentOverViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    UIView *toView = self.view;
    
    CGRect finalRect = CGRectIntersection([[UIScreen mainScreen] applicationFrame], self.view.frame); // Make sure it doesn't go under menu bar
    modalViewController.view.frame = finalRect;
    modalViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    modalViewController.view.tag = kUIViewControllerOverViewTag+modalViewController.modalTransitionStyle; // Hiding some info here :)
    
    if(animated)
    {
        switch(modalViewController.modalTransitionStyle)
        {
                // Currently only cross dissolve and cover vertical supported... if you add support let me know.
            case UIModalTransitionStyleCrossDissolve:
            {
                float beforeAlpha = modalViewController.view.alpha;
                modalViewController.view.alpha = 0;
                [toView addSubview:modalViewController.view];
                [UIView animateWithDuration:kUIViewControllerOverViewAnimationDuration animations:^{
                    modalViewController.view.alpha = beforeAlpha;
                }];
                break;
            }
            case UIModalTransitionStyleCoverVertical:
            default:
            {
                modalViewController.view.frame = CGRectMake(modalViewController.view.frame.origin.x, modalViewController.view.frame.size.height,
                                                            modalViewController.view.frame.size.width, modalViewController.view.frame.size.height);
                [toView addSubview:modalViewController.view];
                [UIView animateWithDuration:kUIViewControllerOverViewAnimationDuration animations:^{
                    modalViewController.view.frame = finalRect;
                }];
                break;
            }
        }
    }
    else {
        [toView addSubview:modalViewController.view];
    }
    
    // [modalViewController retain]; // Keep it around until we dismiss it.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overViewDismissed) name:kUIViewControllerOverViewDismissNotification object:modalViewController.view]; // Release will happen when this notification is posted
}

NSInteger transitionStyleForTag(tag)
{
    if (tag >= kUIViewControllerOverViewTag && tag <= kUIViewControllerOverViewTag+UIModalTransitionStylePartialCurl)
    {
        return tag-kUIViewControllerOverViewTag;
    }
    else {
        return -1; // Not a Over View
    }
}

- (void)dismissOverViewControllerAnimated:(BOOL)animated
{
    UIView *overView = transitionStyleForTag(self.view.tag) >= 0 ? self.view : nil; // Can dismiss ourselves
    for(UIView *subview in self.view.subviews)
    {
        if(transitionStyleForTag(subview.tag) >= 0)
            overView = subview; // Keep going, lets dismiss last presented first
    }
    if(!overView) return; // None to dismiss
    
    if(animated)
    {
        switch(transitionStyleForTag(overView.tag))
        {
                // Currently only cross dissolve and cover vertical supported... if you add support let me know.
            case UIModalTransitionStyleCrossDissolve:
            {
                float beforeAlpha = overView.alpha;
                [UIView animateWithDuration:kUIViewControllerOverViewAnimationDuration animations:^{
                    overView.alpha = 0;
                } completion:^(BOOL finished) {
                    [overView removeFromSuperview];
                    overView.alpha = beforeAlpha;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUIViewControllerOverViewDismissNotification object:overView];
                }];
                break;
            }
            case UIModalTransitionStyleCoverVertical:
            default:
            {
                [UIView animateWithDuration:kUIViewControllerOverViewAnimationDuration animations:^{
                    overView.frame = CGRectMake(0, overView.frame.size.height, overView.frame.size.width, overView.frame.size.height);
                } completion:^(BOOL finished) {
                    [overView removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUIViewControllerOverViewDismissNotification object:overView];
                }];
                break;
            }
        }
    }
    else {
        [overView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUIViewControllerOverViewDismissNotification object:overView];
    }
}

@end