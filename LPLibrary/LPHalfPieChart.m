//
//  LPHalfPieChart.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPHalfPieChart.h"


@implementation LPHalfPieComponent

@synthesize value, title,  colour;

- (id)initWithTitle:(NSString*)_title value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.value = _value;
    }
    return self;
}

+ (id)halfPieComponentWithTitle:(NSString*)_title value:(float)_value{
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

@implementation LPHalfPieChart

@synthesize  components;
@synthesize title, subtitle;
@synthesize titleFont, subtitleFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.titleFont = [UIFont systemFontOfSize:13];
        self.subtitleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    float origin_x = self.frame.size.width/2;
    float origin_y = self.frame.size.height;
    int margin = self.frame.size.width*0.01;//5;
    float outer_cirlce_radius = self.frame.size.width/2-margin;
    float outer_circle_width = self.frame.size.width*0.05;//15;
    float inner_circle_radius = self.frame.size.width*0.2;//70;
    float inner_circle_width = self.frame.size.width*0.05;//15;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);  
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
    
    float startDeg = 0;
    float endDeg = 180;
    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 0.7f);  
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArc(ctx, origin_x, origin_y, outer_cirlce_radius, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
    CGContextMoveToPoint(ctx, origin_x+outer_cirlce_radius-inner_circle_radius-inner_circle_width, origin_y);
    startDeg = 180;
    endDeg = 0;
    CGContextAddArc(ctx, origin_x, origin_y, inner_circle_radius-inner_circle_width, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    if ([components count]>0)
    {
        int total = 0;
        for (LPHalfPieComponent *component in components)
        {
            total += component.value;
        }
        
        float start_degree = 0;
        float end_degree = 0;
        CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
        for (LPHalfPieComponent *component in components)
        {
            float degree = component.value/total*180;
            end_degree = start_degree + degree;
            
            CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            CGContextMoveToPoint(ctx, origin_x, origin_y);
            CGContextAddArc(ctx, origin_x, origin_y, outer_cirlce_radius, (start_degree+180)*M_PI/180.0, (end_degree+180)*M_PI/180.0, 0);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
            
            //NSString *display_value = [NSString stringWithFormat:@"%.1f%", component.value/total*100];
            //CGRect displayFrame = CGRectMake(component.point.x, component.point.y, 100, 100);
            //[display_value drawInRect:displayFrame withFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:27]];
            
            start_degree = end_degree;
        }
        
        if (!self.subtitle)
        {
            self.subtitle = [NSString stringWithFormat:@"%i", total]; 
        }
        
    }
    
    startDeg = 0;
    endDeg = 180;
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArc(ctx, origin_x, origin_y, inner_circle_radius-inner_circle_width, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
    startDeg = 0;
    endDeg = 180;
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 0.3f);  
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArc(ctx, origin_x, origin_y, outer_cirlce_radius, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
    CGContextMoveToPoint(ctx, origin_x+outer_cirlce_radius-outer_circle_width, origin_y);
    startDeg = 180;
    endDeg = 0;
    CGContextAddArc(ctx, origin_x, origin_y, outer_cirlce_radius-outer_circle_width, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    startDeg = 0;
    endDeg = 180;
    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 0.2f);  
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArc(ctx, origin_x, origin_y, inner_circle_radius, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
    CGContextMoveToPoint(ctx, origin_x+inner_circle_radius-inner_circle_width, origin_y);
    startDeg = 180;
    endDeg = 0;
    CGContextAddArc(ctx, origin_x, origin_y, inner_circle_radius-inner_circle_width, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f); 
    if (self.subtitle)
    {
        CGRect textFrame = CGRectMake(self.frame.size.width/2-inner_circle_radius, self.frame.size.height-self.subtitleFont.pointSize-5, 2*inner_circle_radius, self.subtitleFont.pointSize);
        [self.subtitle drawInRect:textFrame withFont:self.subtitleFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
    }
    if (self.title)
    {
        CGRect textFrame = CGRectMake(self.frame.size.width/2-inner_circle_radius, self.frame.size.height-self.subtitleFont.pointSize-self.titleFont.pointSize-5, 2*inner_circle_radius, self.titleFont.pointSize);
        [self.title drawInRect:textFrame withFont:self.titleFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
    }
}

- (void)dealloc
{
    [self.title release];
    [self.subtitle release];
    [self.titleFont release];
    [self.subtitleFont release];
    [super dealloc];
}

@end
