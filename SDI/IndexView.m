//
//  IndexView.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IndexView.h"


@implementation IndexView

@synthesize indexLabel;
@synthesize fluctuationLabel;
@synthesize fluctuationRateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
