//
//  NSString+LPCategory.m
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 7. 23..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "NSString+LPCategory.h"


@implementation NSString (LPCategory)


- (void)drawCenteredInRect:(CGRect)rect withFont:(UIFont *)font {
    CGSize size = [self sizeWithFont:font];
    
    CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
                                   rect.origin.y + (rect.size.height - size.height) / 2,
                                   size.width, size.height);
    [self drawInRect:textBounds withFont:font];    
}


- (CGSize)heightWithFont:(UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode {
	[withFont retain];
	CGSize suggestedSize = [self sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	[withFont release];
	
	return suggestedSize;
}


@end
