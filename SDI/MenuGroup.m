//
//  MenuGroup.m
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 11..
//  Copyright 2010 YouFirst. All rights reserved.
//

#import "MenuGroup.h"


@implementation MenuGroup


@synthesize menuID;
@synthesize name;
@synthesize icon;
@synthesize isUse;
@synthesize target;
@synthesize loginType;


- (void)dealloc {
	[menuID release];
	[name release];
	[icon release];
	[isUse release];
	[target release];
	[loginType release];
	[super dealloc];
}


@end
