//
//  LPSlidePageControl.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 23..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LPSliderPageControlDelegate
@optional
- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page;
- (BOOL)respondsToSelector:(SEL)aSelector;
@end


@interface LPSliderPageControl : UIControl {
	UIImageView *backgroundView;
	int numberOfPages;
	int currentPage;
	UIImageView *slider;
	CGPoint beganPoint;
	BOOL hasDragged;
	UIView *maskView;
	UILabel *hintLabel;
	id<LPSliderPageControlDelegate> delegate;
	BOOL showsHint;
}

@property (nonatomic, retain) id<LPSliderPageControlDelegate> delegate;
@property (nonatomic, assign) BOOL showsHint;
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UIImageView *slider;

- (void)setNumberOfPages:(int)page;
- (int)currentPage;
- (void)setCurrentPage:(int)_currentPage animated:(BOOL)animated;

@end
