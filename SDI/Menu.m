//
//  Menu.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Menu.h"


@implementation Menu

@synthesize groupID;
@synthesize iconForAdd;
@synthesize iconForMyMenu;
@synthesize iconForTotal;
@synthesize menuID;
@synthesize name;
@synthesize target;
@synthesize isMyMenu;

- (id)init 
{
    self = [super init];
	if (self) 
    {
		isMyMenu = NO;
	}
	return self;
}

- (void)dealloc 
{
    [groupID release];
    [iconForAdd release];
    [iconForMyMenu release];
    [iconForTotal release];
    [menuID release];
    [name release];
    [target release];
    [super dealloc];
}

@end
