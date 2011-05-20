//
//  LPVBarChart.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 16..
//  Copyright 2011 Lilac Studio. All rights reserved.
//


#import "LPVBarChart.h"


@implementation LPVBarComponent

@synthesize value, title, perc, colour;

- (id)initWithTitle:(NSString*)_title value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.perc = [NSString stringWithFormat:@"%.2f%%", _value];
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


@implementation LPVBarChart

@synthesize components;
@synthesize titleFont;
@synthesize percFont;
@synthesize sameColorLabel;
@synthesize barWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
		
		self.titleFont = [UIFont boldSystemFontOfSize:20];
		self.sameColorLabel = NO;
	}
    return self;
}

#define BAR_MAX_HEIGHT 62.0
#define BAR_MARGIN 30.0
#define LABEL_MARGIN 16.0
#define DEFAULT_FONT_SIZE 14

- (void)drawRect:(CGRect)rect
{
    if ([components count] > 0)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
        
        // 수평선.
        CGPoint start = CGPointMake(0.0, 60.0);
        CGPoint end = CGPointMake(rect.size.width, 60.0);
        drawStrokedLine(ctx, start, end);
        
        
        for (int i = 0; i < [components count]; i++) 
        {
            LPVBarComponent *component  = [components objectAtIndex:i];
			float perc = [component value];
            
            // 컬러 설정.
            CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            
            // 위치와 크기 설정.
            float currentBarHeight = (fabs(perc) * BAR_MAX_HEIGHT) / 10.0;
            rect.origin.x = BAR_MARGIN + i * (self.barWidth + BAR_MARGIN);
            rect.origin.y = BAR_MAX_HEIGHT - currentBarHeight - 2;
            rect.size.width = self.barWidth;
            rect.size.height = currentBarHeight - 2;
            
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
            
            // 퍼센트 라벨 폰트 크기.
            self.percFont = [UIFont boldSystemFontOfSize:DEFAULT_FONT_SIZE - i];
            
            // 퍼센트 라벨 표시.
            CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            CGRect percFrame = CGRectMake(rect.origin.x - 20, rect.origin.y - LABEL_MARGIN + i, 60.0, 16.0);
            [component.perc drawInRect:percFrame withFont:self.percFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
            
            // 제목 라벨 표시.
            CGContextSetFillColorWithColor(ctx, [RGB(154, 154, 154) CGColor]);
            CGRect titleFrame = CGRectMake(rect.origin.x - 20, 62.0, 60.0, 10.0);
            [component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
        }
    }
}

- (void)dealloc
{
	[self.titleFont release];
    [self.percFont release];
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
