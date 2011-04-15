//
//  LPPageControl.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGECONTROL_FRAME CGRectMake(0.0, 393.0, 320, 43)
#define PAGECONTROL_HEIGHT 43
#define DOT_WIDTH 8
#define DOT_SPACING 10


@interface LPPageControl : UIPageControl 
{
    NSInteger numberOfPages;
    NSInteger currentPage;
    UIColor *selectedColor;
    UIColor *deselectedColor;
}

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, retain) UIColor *deselectedColor;

@end
