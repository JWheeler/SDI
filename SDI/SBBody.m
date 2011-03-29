//
//  SBBody.m
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SBBody.h"


@implementation SBBody

@synthesize TRCD;
@synthesize CMD;
@synthesize mdClsf;

- (void)dealloc 
{
    [TRCD release];
    [CMD release];
    [mdClsf release];
	[super dealloc];
}

@end
