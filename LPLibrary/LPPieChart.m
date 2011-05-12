//
//  LPPieChart.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 라벨 위치/크기 등 조절.
//

#import "LPPieChart.h"


@implementation LPPieComponent

@synthesize value, title, colour, startDeg, endDeg;

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

+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value
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

@implementation LPPieChart

@synthesize  components;
@synthesize diameter;
@synthesize titleFont, percentageFont;
@synthesize showArrow, sameColorLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
		
		self.titleFont = [UIFont fontWithName:@"GeezaPro" size:10];//[UIFont boldSystemFontOfSize:20];
		self.percentageFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];//[UIFont boldSystemFontOfSize:14];
		self.showArrow = YES;
		self.sameColorLabel = NO;
	}
    return self;
}

#define LABEL_TOP_MARGIN 10
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float margin = 15;
    if (self.diameter == 0)
    {
        diameter = MIN(rect.size.width, rect.size.height) - 2 * margin;
    }
    float x = (rect.size.width - diameter) / 2;
    float y = (rect.size.height - diameter) / 2;
    float gap = 1;
    float inner_radius = diameter / 2;
    float origin_x = x + diameter / 2;
    float origin_y = y + diameter / 2;
    
    // 라벨.
    float left_label_y = LABEL_TOP_MARGIN;
    float right_label_y = LABEL_TOP_MARGIN;
    
    if ([components count] > 0)
    {
        float total = 0;
        for (LPPieComponent *component in components)
        {
            total += component.value;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
		CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // 흰색.
		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
		CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));  // 흰색원의 지름은 100, 중심은 (60, 60).
		UIGraphicsPopContext();
		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
		
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i = 0; i < [components count]; i++)
		{
			LPPieComponent *component  = [components objectAtIndex:i];
			float perc = [component value]/total;
			endDeg = nextStartDeg+perc*360;
			
			CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextFillPath(ctx);
			
			CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
			CGContextSetLineWidth(ctx, gap);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextStrokePath(ctx);
			
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
			if (nextStartDeg < 180)
			{
				[tmpComponents addObject:component];
			}
			else
			{
				if (last_insert == -1)
				{
					last_insert = i;
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
		
		nextStartDeg = 0;
		endDeg = 0;
		float max_text_width = x;
		for (int i = 0; i < [tmpComponents count]; i++)
		{
			LPPieComponent *component  = [tmpComponents objectAtIndex:i];
			nextStartDeg = component.startDeg;
			endDeg = component.endDeg;
			
			if (nextStartDeg > 180 ||  (nextStartDeg < 180 && endDeg> 270) )
			{
				// 왼쪽.
				
				// 퍼센트 라벨 표시.
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 3);
				
				//float text_x = x + 10;
				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect percFrame = CGRectMake(5, left_label_y,  max_text_width, optimumSize.height);
				[percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
				
				if (self.showArrow)
				{
					// 포인트에서 차트까지 선 그리기.
					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
					CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
					
					
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
					CGContextSetLineWidth(ctx, 1);
					if (left_label_y + optimumSize.height/2 < y)//(left_label_y==LABEL_TOP_MARGIN)
					{
						
						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
						CGContextClosePath(ctx);
						CGContextFillPath(ctx);
						
					}
					else
					{
						
						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
						if (left_label_y + optimumSize.height/2 > y + diameter)
						{
							CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
							CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
						else
						{
							float y_diff = y1 - (left_label_y + optimumSize.height/2);
							if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
							{
								
								// straight arrow
								y1 = left_label_y + optimumSize.height/2;
								
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_LENGTH, y1);
								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							}
							else if (left_label_y + optimumSize.height/2<y1)
							{
								// arrow point down
								
								y1 -= ARROW_HEAD_LENGTH;
								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							} 
							else
							{
								// arrow point up
								
								y1 += ARROW_HEAD_LENGTH;
								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
								CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							}
						}
					}
					
				}
				// 왼쪽에 제목 표시.
				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
				left_label_y += optimumSize.height - 4;
				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect titleFrame = CGRectMake(5, left_label_y, max_text_width, optimumSize.height);
				[component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
				left_label_y += optimumSize.height + 10;
			}
			else 
			{
				// 오른쪽.
				
				// 퍼센트 라벨 표시.
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.5);
					//CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 2);
				
				float text_x = x + diameter + 10;
				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect percFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
				[percentageText drawInRect:percFrame withFont:self.percentageFont];
				
				if (self.showArrow)
				{
					// 포인트에서 차트까지 선 그리기.
					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
					
					CGContextSetLineWidth(ctx, 1);
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
					
					
					if (right_label_y + optimumSize.height/2 < y)//(right_label_y==LABEL_TOP_MARGIN)
					{
						
						CGContextMoveToPoint(ctx, text_x - 3, right_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
						CGContextClosePath(ctx);
						CGContextFillPath(ctx);
					}
					else
					{
						float y_diff = y1 - (right_label_y + optimumSize.height/2);
						if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
						{
							// straight arrow
							y1 = right_label_y + optimumSize.height/2;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
							CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_LENGTH, y1);
							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
						else if (right_label_y + optimumSize.height/2<y1)
						{
							// arrow point down
							
							y1 -= ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
							//CGContextAddLineToPoint(ctx, x1+5, y1);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx); 
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						} 
						else //if (nextStartDeg<180 && endDeg>180)
						{
							// arrow point up
							y1 += ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
					}
				}

                // 제목을 왼쪽부터 출력한다.
				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
				right_label_y += optimumSize.height - 4;
				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect titleFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
				[component.title drawInRect:titleFrame withFont:self.titleFont];
				right_label_y += optimumSize.height + 10;
			}
			
			nextStartDeg = endDeg;
		}
    }
}

- (void)dealloc
{
	[self.titleFont release];
	[self.percentageFont release];
    [self.components release];
    [super dealloc];
}

@end


