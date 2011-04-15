//
//  UIView+FirstResponder.h
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (LPCategory) 

- (UIView *)findFirstResponder;

// DRAW GRADIENT
+ (void)drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors;

// DRAW ROUNDED RECTANGLE
+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;

// DRAW LINE
+ (void)drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (void)drawLineInRect:(CGRect)rect colors:(CGFloat[])colors;
+ (void)drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap;

@end
