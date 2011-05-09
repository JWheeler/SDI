//
//  MenuGroup.m
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 11..
//  Copyright 2010 YouFirst. All rights reserved.
//

#import "MenuGroup.h"


@implementation MenuGroup


@synthesize groupID;
@synthesize icon;
@synthesize name;
@synthesize target;
@synthesize titleIcon;
@synthesize headerIcon;
@synthesize subMenus;


- (void)dealloc 
{
	[groupID release];
    [icon release];
    [name release];
    [target release];
    [titleIcon release];
    [headerIcon release];
	[super dealloc];
}


@end
