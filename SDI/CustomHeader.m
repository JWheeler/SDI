//
//  CustomHeader.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 28..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "CustomHeader.h"


@implementation CustomHeader

@synthesize imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //self.imageName = @"interest_header01.png";
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // 테이블뷰 헤더 이미지..
	UIImage *image = [[UIImage imageNamed:self.imageName] retain];
	[image drawInRect:rect];
	[image release];
}


- (void)dealloc
{
    [imageName release];
    [super dealloc];
}

@end
