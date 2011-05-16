//
//  LPBarChart.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  Daily의 매매동향을 표시하기위한 가로 바 차트를 그기기 위해...
//  TODO: 데일리에 특화되어 있으므로 일반화 시키려면 조금 변경해야 함!
//

#import <Foundation/Foundation.h>

@interface LPHBarComponent : NSObject
{
    float value;
    NSString *title;
    UIColor *colour;
}

@property (nonatomic, assign) float value;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;

- (id)initWithTitle:(NSString*)_title value:(float)_value;
+ (id)barComponentWithTitle:(NSString*)_title value:(float)_value;

@end


#define LPColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define LPColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define LPColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define LPColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define LPColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define LPColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]


@interface LPHBarChart : UIView 
{
    NSMutableArray *components;
    UIFont *titleFont;
    BOOL sameColorLabel;
    float barWidth;             // 바차트의 각 바의 넓이(폭)
}

@property (nonatomic, retain) NSMutableArray *components;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, assign) BOOL sameColorLabel;
@property (nonatomic, assign) float barWidth;

static void drawStrokedLine(CGContextRef context, CGPoint start, CGPoint end);

@end