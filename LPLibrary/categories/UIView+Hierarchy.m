//
//  UIView+Hierarchy.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 5..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "UIView+Hierarchy.h"


@implementation UIView (Hierarchy)

- (int)getSubviewIndex
{
	return [self.superview.subviews indexOfObject:self];
}

- (void)bringToFront
{
	[self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
	[self.superview sendSubviewToBack:self];
}

- (void)bringOneLevelUp
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

- (void)sendOneLevelDown
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

- (BOOL)isInFront
{
	return ([self.superview.subviews lastObject] == self);
}

- (BOOL)isAtBack
{
	return ([self.superview.subviews objectAtIndex:0] == self);
}

- (void)swapDepthsWithView:(UIView*)swapView
{
	[self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

@end
