//
//  LPBarChart.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPHBarChart.h"


@implementation LPHBarComponent

@synthesize value, title, colour;

- (id)initWithTitle:(NSString*)_title value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.value = _value;
        self.colour = LPColorDefault;
    }
    return self;
}

+ (id)barComponentWithTitle:(NSString*)_title value:(float)_value
{
    return [[[super alloc] initWithTitle:_title value:_value] autorelease];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}

@end


@implementation LPHBarChart

@synthesize components;
@synthesize titleFont;
@synthesize sameColorLabel;
@synthesize barWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
		
		self.titleFont = [UIFont fontWithName:@"GeezaPro" size:10];//[UIFont boldSystemFontOfSize:20];
		self.sameColorLabel = NO;
	}
    return self;
}

#define BAR_MAX_WIDTH 120
#define BAR_MARGIN 4
#define LABEL_MARGIN 10

- (void)drawRect:(CGRect)rect
{
    if ([components count] > 0)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
        
        // 수직선.
        CGPoint vStart = CGPointMake(0.0, 0.0);
        CGPoint vEnd = CGPointMake(0.0, rect.size.height);
        drawStrokedLine(ctx, vStart, vEnd);
        
        // 수평선.
        CGPoint hStart = CGPointMake(0.0, rect.size.height);
        CGPoint hEnd = CGPointMake(rect.size.width, rect.size.height);
        drawStrokedLine(ctx, hStart, hEnd);
        
        
        for (int i = 0; i < [components count]; i++) 
        {
            LPHBarComponent *component  = [components objectAtIndex:i];
			float perc = [component value];
            
            // 컬러 설정.
            CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            
            // 위치와 크기 설정.
            rect.origin.x = 1.0;
            rect.origin.y = BAR_MARGIN + i * (barWidth + BAR_MARGIN);
            rect.size.width = (fabs(perc) * BAR_MAX_WIDTH) / 100.0;
            rect.size.height = self.barWidth;
            
            // 사각형 채우기.
            CGContextFillRect(ctx, rect);
            
            // 퍼센트 라벨 표시.
            if (self.sameColorLabel)
            {
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            }
            else 
            {
                CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
            }
       

            CGRect titleFrame = CGRectMake(rect.size.width + BAR_MARGIN, rect.origin.y, 50.0, self.barWidth);
            [component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
        }
    }
}

- (void)dealloc
{
	[self.titleFont release];
    [self.components release];
    [super dealloc];
}

#pragma mark - 커스텀 메서드

static void drawStrokedLine(CGContextRef context, CGPoint start, CGPoint end) 
{
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, start.x, start.y);
	CGContextAddLineToPoint(context, end.x, end.y);
	CGContextDrawPath(context, kCGPathStroke);
}

@end
