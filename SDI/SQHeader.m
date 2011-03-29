//
//  SQHeader.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SQHeader.h"


@implementation SQHeader

@synthesize length;
@synthesize function;
@synthesize trcode;
@synthesize type;
@synthesize code;

- (void)dealloc 
{
	[length release];
	[function release];
	[trcode release];
	[type release];
	[code release];
	[super dealloc];
}

@end
