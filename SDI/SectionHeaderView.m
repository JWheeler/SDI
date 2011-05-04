//
//  SectionHeader.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SectionHeaderView.h"


static UIImage *_headerImage = nil;

@implementation SectionHeaderView

@synthesize imageName;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _headerImage = [[UIImage imageNamed:self.imageName] retain];
    [_headerImage drawInRect:rect];
    [_headerImage release];
}

- (void)dealloc
{
    [imageName release];
    [super dealloc];
}

@end
