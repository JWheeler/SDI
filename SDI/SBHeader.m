//
//  SBHeader.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SBHeader.h"


@implementation SBHeader

@synthesize GID;
@synthesize MGL;
@synthesize SID;

- (void)dealloc 
{
    [GID release];
    [MGL release];
    [SID release];
	[super dealloc];
}

@end
