//
//  UISearchBarMaskLayer.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 15..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPUISearchBarMaskLayer.h"


@implementation LPUISearchBarMaskLayer

- (void)drawInContext:(CGContextRef)context
{
    CGRect imageBounds = CGRectMake(0, 0, 270, 34);
    CGRect bounds = imageBounds;
    
    CGFloat alignStroke;
    CGFloat resolution;
    CGMutablePathRef path;
    CGPoint point;
    CGPoint controlPoint1;
    CGPoint controlPoint2;
    UIColor *color;
    resolution = 0.5 * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    
    // Layer 1
    
    alignStroke = 0.0;
    path = CGPathCreateMutable();
    point = CGPointMake(295.0, 32.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(310.0, 17.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(303.229, 32.0);
    controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
    controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
    controlPoint2 = CGPointMake(310.0, 25.229);
    controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
    controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(310.0, 17.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(295.0, 2.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(310.0, 8.771);
    controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
    controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
    controlPoint2 = CGPointMake(303.229, 2.0);
    controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
    controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(15.0, 2.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(0.0, 17.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(6.771, 2.0);
    controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
    controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
    controlPoint2 = CGPointMake(0.0, 8.771);
    controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
    controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(0.0, 17.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(15.0, 32.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(0.0, 25.229);
    controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
    controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
    controlPoint2 = CGPointMake(6.771, 32.0);
    controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
    controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(295.0, 32.0);
    point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathCloseSubpath(path);
    color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [color setFill];
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
}

@end
