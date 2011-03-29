//
//  LPPageControl.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPPageControl.h"


@implementation LPPageControl

@synthesize selectedColor;
@synthesize deselectedColor;

- (void)dealloc
{
    [selectedColor release];
    [deselectedColor release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, PAGECONTROL_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedColor = [UIColor lightGrayColor];
        self.deselectedColor = [UIColor blackColor];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, PAGECONTROL_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedColor = [UIColor grayColor];
        self.deselectedColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < numberOfPages; i++) 
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (i == currentPage)
            CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        else
            CGContextSetFillColorWithColor(context, deselectedColor.CGColor);
        
        CGContextFillEllipseInRect(context, CGRectMake(2 + DOT_WIDTH * i + DOT_SPACING * i, (PAGECONTROL_HEIGHT - DOT_WIDTH) / 2, DOT_WIDTH, DOT_WIDTH));
    }
}

-(void) setNumberOfPages: (int) number
{
    numberOfPages = MAX(number, 0);
    currentPage = 0;
    
    CGPoint tempCenter = self.center;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 4 + numberOfPages * DOT_WIDTH + MAX(numberOfPages - 1, 0) * DOT_SPACING, self.frame.size.height);
    self.center = tempCenter;
    
    [self setNeedsDisplay];
}

-(int) numberOfPages
{
    return numberOfPages;
}

-(void) setCurrentPage: (int) index
{
    if (index >= numberOfPages)
        currentPage = 0;
    else
        currentPage = MAX(0, index);
    
    [self setNeedsDisplay];
}

-(int) currentPage
{
    return currentPage;
}



@end
