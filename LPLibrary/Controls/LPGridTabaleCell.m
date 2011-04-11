//
//  LPGridTabaleCell.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPGridTabaleCell.h"


@implementation LPGridTabaleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        columns = [NSMutableArray arrayWithCapacity:3];
		[columns retain];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect 
{ 
    [super drawRect:rect];
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 수평선의 컬러와 사이즈 매치 시킴.
	CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0); 
	CGContextSetLineWidth(ctx, 0.25);
    
	for (int i = 0; i < [columns count]; i++) 
    {
        // 수직 선의 위치 확인.
		CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
		CGContextMoveToPoint(ctx, f, 0);
		CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
	}
	
	CGContextStrokePath(ctx);
}

- (void)addColumn:(CGFloat)position 
{
	[columns addObject:[NSNumber numberWithFloat:position]];
}

- (void)dealloc
{
    [columns release];
    [super dealloc];
}

@end
