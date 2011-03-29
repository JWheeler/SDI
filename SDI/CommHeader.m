//
//  CommHeader.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "CommHeader.h"


@implementation CommHeader

@synthesize lengcode;
@synthesize funccode; 
@synthesize media_ix; 
@synthesize mgl;
@synthesize compress; 
@synthesize pub_auth; 
@synthesize tradetype; 
@synthesize conninfo;

- (void)dealloc 
{
    [lengcode release];
	[funccode release];
	[media_ix release];
	[mgl release];
	[compress release];
	[pub_auth release];
	[tradetype release];
	[conninfo release];
    [super dealloc];
}

@end
