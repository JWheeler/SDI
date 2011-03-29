//
//  LPPageControl.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGECONTROL_HEIGHT 36
#define DOT_WIDTH 6
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
