//
//  LPHalfPieChart.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPHalfPieComponent : NSObject
{
    float value;
    NSString *title;
    UIColor *colour;
}

@property (nonatomic, assign) float value;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;

+ (id)halfPieComponentWithTitle:(NSString*)_title value:(float)_value;
- (id)initWithTitle:(NSString*)_title value:(float)_value;

@end

#define LPColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define LPColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define LPColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define LPColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define LPColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define LPColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]


@interface LPHalfPieChart : UIView 
{
    NSMutableArray *components;
    NSString *title, *subtitle;
    UIFont *titleFont, *subtitleFont;
}

@property (nonatomic, retain) NSString *title, *subtitle;
@property (nonatomic, retain) NSMutableArray *components;
@property (nonatomic, retain) UIFont *titleFont, *subtitleFont;

@end
