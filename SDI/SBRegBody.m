//
//  SBRegisterBody.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 29..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SBRegBody.h"


@implementation SBRegBody

@synthesize idx;
@synthesize code;

- (void)dealloc 
{
    [idx release];
    [code release];
	[super dealloc];
}

@end
