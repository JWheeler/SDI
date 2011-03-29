//
//  DataHeader.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "DataHeader.h"


@implementation DataHeader

@synthesize handle;
@synthesize trcode;
@synthesize dispno;
@synthesize tradetime;
@synthesize custmerno;
@synthesize msg;
@synthesize termno;
@synthesize macaddr;
@synthesize termialix;
@synthesize version;
@synthesize model;
//@synthesize filler;

- (void)dealloc 
{
	[handle release];
	[trcode release];
	[dispno release];
	[tradetime release];
	[custmerno release];
	[msg release];
	[termno release];
	[macaddr release];
	[termialix release];
	[version release];
	[model release];
	//[filler release];
    [super dealloc];
}

@end
