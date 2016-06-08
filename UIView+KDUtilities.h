//
//  UIView+UIView_AnimateHiding.h
//  koudaixiang
//
//  Created by Liu Yachen on 11/15/11.
//  Copyright (c) 2011 Suixing Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (KDUtilities)

- (UIView *)KD_addBlackOverlay;

- (UIView *)KD_addBorderOutsideWithWidth:(CGFloat)width
                                   color:(UIColor *)color
                            cornerRadius:(CGFloat)cornerRadius;

- (UITapGestureRecognizer *)KD_addTapAction:(void(^)(UIView *view))action;

- (void)KD_addCenterConstraint;

@end


@interface UIView (AnimatedHiding)

- (void)KD_setHidden:(BOOL)hidden animationDuration:(NSTimeInterval)duration;

@end


@interface UIView (FrameModifyHelper)

- (void)KD_setFrameOriginX:(CGFloat)value;
- (void)KD_setFrameOriginY:(CGFloat)value;
- (void)KD_setFrameSizeWidth:(CGFloat)value;
- (void)KD_setFrameSizeHeight:(CGFloat)value;
- (void)KD_setFrameOrigin:(CGPoint)value;

- (void)KD_setFrameSizeWidthBaseOnLeft:(CGFloat)value;

- (void)KD_setCenterAtSuperViewCenter;

@end

@interface UIView (Freezing)

- (void)KD_freeze;
- (void)KD_unfreeze;

- (BOOL)KD_isFreezing;

@end

@interface UITableViewCell (Margin)

- (void)KD_setSeparatorInsetZero;

@end

NS_INLINE CGRect CGRectEdgeInset(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left,
                      rect.origin.y + insets.top,
                      rect.size.width - insets.left - insets.right,
                      rect.size.height - insets.top - insets.bottom);
}


extern UIView *KDUtilFindViewInSuperViews(UIView *view, Class viewClass);