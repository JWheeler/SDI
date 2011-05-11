//
//  LPLineChart.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPLineChartComponent : NSObject
{
    NSString *title;
    NSArray *points;
    UIColor *colour;
	BOOL shouldLabelValues;
}

@property (nonatomic, assign) BOOL shouldLabelValues;
@property (nonatomic, retain) NSArray *points;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;
@end


#define LPColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define LPColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define LPColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define LPColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define LPColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define LPColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]


@interface LPLineChart : UIView 
{
    NSMutableArray *components;
	NSMutableArray *xLabels;
	UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;
    int interval;
	float minValue;
	float maxValue;
}

@property (nonatomic, assign) int interval;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, retain) NSMutableArray *components, *xLabels;
@property (nonatomic, retain) UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;

@end
