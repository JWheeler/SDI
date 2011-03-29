//
//  SBInit.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 28..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SBRegBodyHeader.h"


@implementation SBRegBodyHeader

@synthesize TRCD;
@synthesize CMD;

- (void)dealloc 
{
	[TRCD release];
    [CMD release];
    [super dealloc];
}

@end
