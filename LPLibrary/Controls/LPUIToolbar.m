//
//  LPUIToolbar.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 15..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPUIToolbar.h"


@implementation LPUIToolbar

- (void)drawRect:(CGRect)rect 
{
	// 배경 이미지.
	UIImage *image = [[UIImage imageNamed:@"toolbar_bg.png"] retain];
	[image drawInRect:rect];
	[image release];
}

- (void)dealloc 
{
    [super dealloc];
}

@end
