//
//  UIView+FirstResponder.m
//  AddToKeyboard
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "UIView+FirstResponder.h"


@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder {
	if ([self isFirstResponder]) {
		return self;
	}
	
	for (UIView *subview in [self subviews]) {
		UIView *firstResponder = [subview findFirstResponder];
		if (nil != firstResponder) {
			return firstResponder;
		}
	}
	
	return nil;
}

@end
